# Real Chrome navigation and WASM smoke tests

These checks run the GetX example's separate `browser_navigation_probe.dart`
entry point. The normal `lib/main.dart` application is unchanged. They exercise
actual browser navigation, not simulated widget-test history.

Use an already installed Flutter SDK, resolved example dependencies, Chrome and
Node. No npm packages or browser downloads are needed. Node 20.18.0 was verified
with `--experimental-websocket`; keep that flag on Node 20. The runner also works
with Node versions that expose a global WebSocket. Chrome 156.0.8078.74 was used
locally. Set `CHROME_EXECUTABLE` or pass `--chrome /path/to/chrome` when Chrome is
not at the default macOS location or `google-chrome` on Linux.

From `example_nav2`:

```sh
flutter build web --no-pub --no-web-resources-cdn --no-wasm-dry-run \
  --target lib/browser_navigation_probe.dart --output build/browser-js
node --experimental-websocket test/browser/navigation_smoke.mjs \
  --build-dir build/browser-js --mode js --case ordinary \
  --report build/browser-results/js.json

flutter build web --no-pub --no-web-resources-cdn --wasm \
  --target lib/browser_navigation_probe.dart --output build/browser-wasm
node --experimental-websocket test/browser/navigation_smoke.mjs \
  --build-dir build/browser-wasm --mode wasm --case ordinary \
  --report build/browser-results/wasm.json
```

The runner starts an isolated headless Chrome profile and a local SPA server
with cross-origin isolation headers. External DNS resolution is blocked.
The server supports direct URLs and refresh. The JSON report records each step,
parameters, browser version, loaded assets and runtime errors. Successful runs
also write a screenshot. A WASM run requires a successful `main.dart.wasm`
response and rejects silent `main.dart.js` fallback; loading CanvasKit WASM
alone does not count as executing the application's WASM artifact.

The ordinary case checks Unicode query values, direct and refreshed deep links,
actual browser back/forward, a nested GetRouterOutlet, nested child selection,
and middleware redirects. A rendered current page publishes test state through
small JS hooks; navigation hooks call the public GetX API. Browser history and
reload operations are Chrome operations, and refresh must start a new Dart app.

## Strict query encoding gate

Run the complete contract with `--case all` (the default), or isolate the strict
encoding check with `--case encoded`:

```sh
node --experimental-websocket test/browser/navigation_smoke.mjs \
  --build-dir build/browser-js --mode js --case all \
  --report build/browser-results/all.json
```

Every step is recorded even when another step fails. The command exits nonzero
if any required step fails. `ordinary` is an explicit diagnostic subset, not a
replacement for the complete gate.

Flutter 3.47.5 locally fails the strict case: a literal plus encoded as `%2B` in
the query is rewritten as `+`, then becomes a space after refresh. GetX's
in-memory parameters are initially correct. The following pure Flutter control
contains no GetX code and reproduces the same loss:

```sh
flutter build web --no-pub --no-web-resources-cdn --no-wasm-dry-run \
  --target test/browser/encoding_control.dart --output build/browser-control
node --experimental-websocket test/browser/navigation_smoke.mjs \
  --build-dir build/browser-control --mode js --case encoded \
  --report build/browser-results/control.json
```

The control uses Flutter's existing SDK `flutter_web_plugins` dependency already
resolved through the local GetX package. No dependency constraint is changed.
Do not label the strict encoding gate fixed on another SDK without running it on
that SDK and revision. Ordinary JavaScript/WASM success does not clear this gate.
