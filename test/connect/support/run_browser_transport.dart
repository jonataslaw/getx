import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Runs real browser transport tests with a fresh loopback fixture and cleanup.
Future<void> main(List<String> arguments) async {
  final flutter = arguments.isEmpty ? 'flutter' : arguments.first;
  final fixture = await Process.start(Platform.resolvedExecutable,
      ['test/connect/support/browser_fixture_server.dart']);
  final fixtureErrors = fixture.stderr.listen(stderr.add);
  Process? browser;
  try {
    final ready = await fixture.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .first
        .timeout(const Duration(seconds: 15));
    final origin =
        (jsonDecode(ready) as Map<String, dynamic>)['origin'] as String;
    if (!origin.startsWith('http://127.0.0.1:')) {
      throw StateError('Expected a loopback browser fixture origin.');
    }
    browser = await Process.start(flutter, [
      'test',
      '--no-pub',
      '--platform',
      'chrome',
      '--dart-define=GETX_BROWSER_FIXTURE=$origin',
      ...arguments.skip(1),
      'test/connect/rc_browser_transport_test.dart',
    ]);
    final output = browser.stdout.listen(stdout.add);
    final errors = browser.stderr.listen(stderr.add);
    try {
      exitCode = await browser.exitCode.timeout(const Duration(minutes: 3));
    } finally {
      await output.cancel();
      await errors.cancel();
    }
  } finally {
    browser?.kill();
    fixture.kill();
    await fixture.exitCode.timeout(const Duration(seconds: 5));
    await fixtureErrors.cancel();
  }
}
