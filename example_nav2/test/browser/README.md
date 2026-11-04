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

## Opt-in history restoration

Build the same probe with `--dart-define=GETX_PROBE_RESTORATION=true` and run
`--case history` in both JS and WASM modes. For example:

```sh
flutter build web --no-pub --no-web-resources-cdn --wasm \
  --dart-define=GETX_PROBE_RESTORATION=true \
  --target lib/browser_navigation_probe.dart --output build/browser-history-wasm
node --experimental-websocket test/browser/navigation_smoke.mjs \
  --build-dir build/browser-history-wasm --mode wasm --case history \
  --report build/browser-results/history-wasm.json
```

This case checks the complete ordered stack through three pushes and real
browser back/forward, including integer and double argument types. Use
`--no-wasm-dry-run` instead of `--wasm`, a separate build output, and `--mode js`
for the JavaScript counterpart. Ordinary builds leave restoration disabled.

A fresh browser reload uses Flutter's initial URI. It does not import the
previous browser entry's full route state through the default information
provider on the selected SDK. Full stack persistence across web refresh is
therefore outside this case's contract; live back/forward replay and native
OS restoration are verified separately.

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

Flutter 3.47.5 and 3.47.9 locally fail the strict case: a literal plus encoded as `%2B` in
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


Flutter tracks this engine limitation in
[flutter/flutter#147857](https://github.com/flutter/flutter/issues/147857) and
[flutter/flutter#180373](https://github.com/flutter/flutter/issues/180373).
The engine fix [#189835](https://github.com/flutter/flutter/pull/189835) merged
into Flutter master on 2026-10-03; it is absent from the tested 3.47.9 SDK.
[Flutter's web deployment documentation](https://docs.flutter.dev/deployment/web#url-percent-encoding-in-browser-history)
assigns percent-encoding preservation to Flutter 3.50 or later. This is an
upstream fix version, not a claim that a 3.50 SDK has been tested here.

A custom `RouteInformationProvider` that still calls public
`SystemNavigator.routeInformationUpdated` passes through the same engine path.
Double-encoding values changes the URI contract and fails across SDK versions;
raw browser-history writes can desynchronize Flutter's history state. Neither
is used by this harness or added to GetX. Applications whose identifiers permit
it can choose URL-safe opaque tokens at their own API boundary; that is an
application data contract, not a transparent fix for arbitrary query values.
Keep the strict gate red until the intended SDK passes both this probe and the
pure Flutter control, including a refresh that preserves the original value.
