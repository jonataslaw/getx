// Real-browser integration runner using only Node and a locally installed Chrome.
// Build lib/browser_navigation_probe.dart with Flutter --no-web-resources-cdn,
// then run: node --experimental-websocket test/browser/navigation_smoke.mjs
//   --build-dir /absolute/build/web --mode js|wasm --report /absolute/result.json
import assert from 'node:assert/strict';
import { createServer } from 'node:http';
import { spawn } from 'node:child_process';
import { mkdtemp, readFile, writeFile, rm, stat, mkdir } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { resolve, join, extname, dirname } from 'node:path';

const args = Object.fromEntries(process.argv.slice(2).reduce((pairs, value, index, all) => {
  if (value.startsWith('--')) pairs.push([value.slice(2), all[index + 1]]);
  return pairs;
}, []));
assert(args['build-dir'] && args.report, 'Provide --build-dir and --report.');
assert(typeof WebSocket !== 'undefined', 'Node 20 requires --experimental-websocket.');
const buildDir = resolve(args['build-dir']);
const mode = args.mode ?? 'js';
const report = { mode, steps: [], exceptions: [], consoleErrors: [], resources: [] };
const pause = ms => new Promise(resolvePause => setTimeout(resolvePause, ms));
const mime = { '.html': 'text/html', '.js': 'application/javascript', '.mjs': 'application/javascript', '.wasm': 'application/wasm', '.json': 'application/json', '.png': 'image/png', '.ttf': 'font/ttf', '.otf': 'font/otf' };
await mkdir(dirname(resolve(args.report)), { recursive: true });
const server = createServer(async (request, response) => {
  try {
    const pathname = decodeURIComponent(new URL(request.url, 'http://localhost').pathname);
    let path = resolve(buildDir, `.${pathname}`);
    assert(path === buildDir || path.startsWith(`${buildDir}/`));
    try {
      if (!(await stat(path)).isFile()) path = join(path, 'index.html');
    } catch {
      if (extname(path)) throw new Error('Missing asset');
      path = join(buildDir, 'index.html');
    }
    const body = await readFile(path);
    response.writeHead(200, {
      'Content-Type': mime[extname(path)] ?? 'application/octet-stream',
      'Cache-Control': 'no-store',
      'Cross-Origin-Opener-Policy': 'same-origin',
      'Cross-Origin-Embedder-Policy': 'require-corp',
    });
    response.end(body);
  } catch {
    response.writeHead(404); response.end('Not found');
  }
});
await new Promise(resolveListen => server.listen(0, '127.0.0.1', resolveListen));
const origin = `http://127.0.0.1:${server.address().port}`;
const profile = await mkdtemp(join(tmpdir(), 'getx-browser-probe-'));
const chrome = spawn(args.chrome ?? process.env.CHROME_EXECUTABLE ?? (process.platform === 'darwin' ? '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' : 'google-chrome'), [
  '--headless=new', '--no-first-run', '--no-default-browser-check',
  '--disable-background-networking', '--disable-component-update', '--disable-sync',
  '--enable-unsafe-swiftshader', '--use-angle=swiftshader', '--window-size=1280,900',
  '--remote-debugging-port=0', `--user-data-dir=${profile}`,
  '--host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE localhost, EXCLUDE 127.0.0.1',
  'about:blank',
], { stdio: ['ignore', 'ignore', 'pipe'] });
let chromeLog = '';
chrome.stderr.on('data', data => { chromeLog += data; });
let socket;
let nextId = 1;
const pending = new Map();
function call(method, params = {}) {
  return new Promise((resolveCall, rejectCall) => {
    const id = nextId++;
    const timer = setTimeout(() => { pending.delete(id); rejectCall(new Error(`CDP timeout: ${method}`)); }, 15000);
    pending.set(id, { resolveCall, rejectCall, timer });
    socket.send(JSON.stringify({ id, method, params }));
  });
}
async function evaluate(expression) {
  const result = await call('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
  if (result.exceptionDetails) throw new Error(JSON.stringify(result.exceptionDetails));
  return result.result.value;
}
async function stateAt(path, label, parameters, previousBoot) {
  const deadline = Date.now() + 20000;
  let state;
  let url;
  while (Date.now() < deadline) {
    state = await evaluate('window.getxProbeState ? JSON.parse(window.getxProbeState) : null');
    url = await evaluate('location.pathname + location.search');
    if (state?.location === path && state.label === label && url === path && state.boot !== previousBoot) {
      assert.deepEqual(state.parameters, parameters);
      return state;
    }
    await pause(100);
  }
  throw new Error(`Route timeout: expected ${path}/${label}, got ${JSON.stringify({ state, url })}`);
}
async function step(name, action, path, label, parameters, previousBoot) {
  try {
    await action();
    const state = await stateAt(path, label, parameters, previousBoot);
    report.steps.push({ name, passed: true, state });
    process.stdout.write(`PASS ${name}\n`);
    return state;
  } catch (error) {
    report.steps.push({ name, passed: false, error: error.message });
    process.stdout.write(`FAIL ${name}: ${error.message}\n`);
    return null;
  }
}
let failed;
try {
  let port;
  const deadline = Date.now() + 15000;
  while (!port && Date.now() < deadline) {
    try { port = Number((await readFile(join(profile, 'DevToolsActivePort'), 'utf8')).split('\n')[0]); } catch { await pause(100); }
  }
  assert(port, 'Chrome did not start remote debugging.');
  const targets = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
  const target = targets.find(item => item.type === 'page');
  socket = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((resolveOpen, rejectOpen) => { socket.addEventListener('open', resolveOpen, { once: true }); socket.addEventListener('error', rejectOpen, { once: true }); });
  socket.addEventListener('message', event => {
    const message = JSON.parse(event.data);
    if (message.id && pending.has(message.id)) {
      const entry = pending.get(message.id); pending.delete(message.id); clearTimeout(entry.timer);
      if (message.error) entry.rejectCall(new Error(JSON.stringify(message.error))); else entry.resolveCall(message.result);
    } else if (message.method === 'Runtime.exceptionThrown') {
      report.exceptions.push(message.params.exceptionDetails);
    } else if (message.method === 'Runtime.consoleAPICalled' && message.params.type === 'error') {
      report.consoleErrors.push(message.params.args.map(value => value.value ?? value.description));
    } else if (message.method === 'Network.responseReceived') {
      const { url, status, mimeType } = message.params.response;
      report.resources.push({ url, status, mimeType });
    }
  });
  await call('Page.enable'); await call('Runtime.enable'); await call('Network.enable');
  report.browser = await call('Browser.getVersion');
  const encoded = args.case === 'encoded';
  report.case = args.case ?? 'all';
  const initial = encoded ? '/item/a+b?tag=a%2Bb&label=%D8%B3%D9%84%D8%A7%D9%85' : '/item/42?tag=active&label=%D8%B3%D9%84%D8%A7%D9%85';
  const initialParams = { id: encoded ? 'a+b' : '42', tag: encoded ? 'a+b' : 'active', label: 'سلام' };
  const first = await step(encoded ? 'strict encoded query deep link' : 'direct deep link with query and Unicode', () => call('Page.navigate', { url: origin + initial }), initial, 'item', initialParams);
  const refreshed = await step('refresh preserves deep link and query', () => call('Page.reload', { ignoreCache: true }), initial, 'item', initialParams, first?.boot);
  if (first && refreshed) assert.notEqual(refreshed.boot, first.boot, 'Refresh must execute a new application instance.');
  if (!encoded) {
  await step('public navigation updates URL', () => evaluate('window.getxProbeNavigate("/second?from=history")'), '/second?from=history', 'second', { from: 'history' });
  await step('browser back restores query parameters', () => evaluate('history.back()'), initial, 'item', initialParams);
  await step('browser forward restores next page', () => evaluate('history.forward()'), '/second?from=history', 'second', { from: 'history' });
  const nested = '/shell/item/42?tab=notes&filter=active';
  await step('direct nested outlet deep link', () => call('Page.navigate', { url: origin + nested }), nested, 'nested item', { id: '42', tab: 'notes', filter: 'active' });
  await step('nested navigation updates outlet and query', () => evaluate('window.getxProbeNavigate("/shell/item/43?tab=files")'), '/shell/item/43?tab=files', 'nested item', { id: '43', tab: 'files' });
  await step('nested browser back restores outlet', () => evaluate('history.back()'), nested, 'nested item', { id: '42', tab: 'notes', filter: 'active' });
  await step('nested browser forward restores outlet', () => evaluate('history.forward()'), '/shell/item/43?tab=files', 'nested item', { id: '43', tab: 'files' });
  const beforeReload = await evaluate('JSON.parse(window.getxProbeState).boot');
  const afterReload = await step('nested refresh retains selected child', () => call('Page.reload', { ignoreCache: true }), '/shell/item/43?tab=files', 'nested item', { id: '43', tab: 'files' }, beforeReload);
  if (afterReload) assert.notEqual(afterReload.boot, beforeReload);
  await step('nested redirect updates visible route and URL', () => evaluate('window.getxProbeNavigate("/shell/private")'), '/shell/item/redirected?from=guard', 'nested item', { id: 'redirected', from: 'guard' });
  await step('browser back after redirect restores child', () => evaluate('history.back()'), '/shell/item/43?tab=files', 'nested item', { id: '43', tab: 'files' });
  await step('browser forward after redirect restores target', () => evaluate('history.forward()'), '/shell/item/redirected?from=guard', 'nested item', { id: 'redirected', from: 'guard' });
  }
  if ((args.case ?? 'all') === 'all') {
    const strictPath = '/item/a+b?tag=a%2Bb&label=%D8%B3%D9%84%D8%A7%D9%85';
    const strictParameters = { id: 'a+b', tag: 'a+b', label: 'سلام' };
    const strictFirst = await step('strict encoded query deep link', () => call('Page.navigate', { url: origin + strictPath }), strictPath, 'item', strictParameters);
    await step('strict encoded query survives refresh', () => call('Page.reload', { ignoreCache: true }), strictPath, 'item', strictParameters, strictFirst?.boot);
  }
  const appWasm = report.resources.some(resource => resource.url.endsWith('/main.dart.wasm') && resource.status === 200);
  const appJs = report.resources.some(resource => resource.url.endsWith('/main.dart.js') && resource.status === 200);
  assert.equal(appWasm, mode === 'wasm', 'Check actual app WASM module loading, not only CanvasKit WASM.');
  assert.equal(appJs, mode === 'js', 'WASM run must not silently use JavaScript fallback.');
  assert.deepEqual(report.exceptions, [], 'No uncaught browser runtime exceptions.');
  assert.deepEqual(report.consoleErrors, [], 'No Flutter framework console errors.');
  assert(report.steps.every(step => step.passed), 'One or more browser navigation steps failed.');
  const capture = await call('Page.captureScreenshot', { format: 'png' });
  await writeFile(`${args.report}.png`, Buffer.from(capture.data, 'base64'));
} catch (error) {
  failed = error;
  report.failure = error.stack ?? String(error);
  if (socket?.readyState === WebSocket.OPEN) {
    try { report.finalState = await evaluate('({url:location.href,state:window.getxProbeState})'); } catch {}
  }
} finally {
  report.passed = !failed;
  await writeFile(args.report, `${JSON.stringify(report, null, 2)}\n`);
  await writeFile(`${args.report}.chrome.log`, chromeLog);
  if (socket) socket.close();
  chrome.kill();
  server.closeAllConnections();
  await new Promise(resolveClose => server.close(resolveClose));
  await rm(profile, { recursive: true, force: true, maxRetries: 5, retryDelay: 100 });
}
if (failed) { process.stderr.write(`${failed.stack}\n`); process.exitCode = 1; }
