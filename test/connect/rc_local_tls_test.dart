@TestOn('vm')
library;

import 'dart:async';
import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/http/src/certificates/certificates.dart';
import 'package:get/get_connect/http/src/http.dart';
import 'package:get/get_connect/sockets/sockets.dart';

void main() {
  io.Directory? certificates;
  io.HttpServer? server;
  late String origin;
  late String certificatePath;
  late String authorityPath;
  final peers = <io.WebSocket>[];

  setUpAll(() async {
    certificates = await io.Directory.systemTemp.createTemp('getx_tls_test_');
    certificatePath = '${certificates!.path}/certificate.pem';
    final keyPath = '${certificates!.path}/private-key.pem';
    authorityPath = '${certificates!.path}/authority.pem';
    final authorityKey = '${certificates!.path}/authority-key.pem';
    Future<void> openssl(List<String> arguments) async {
      final generated = await io.Process.run('openssl', arguments)
          .timeout(const Duration(seconds: 15));
      expect(generated.exitCode, 0,
          reason:
              'An installed OpenSSL is required for ephemeral test certificates.');
    }

    await openssl([
      'req',
      '-x509',
      '-newkey',
      'rsa:2048',
      '-nodes',
      '-keyout',
      authorityKey,
      '-out',
      authorityPath,
      '-days',
      '1',
      '-subj',
      '/CN=getx-test-authority',
      '-addext',
      'basicConstraints=critical,CA:TRUE',
      '-addext',
      'keyUsage=critical,keyCertSign,cRLSign',
    ]);
    final requestPath = '${certificates!.path}/request.csr';
    await openssl([
      'req',
      '-new',
      '-newkey',
      'rsa:2048',
      '-nodes',
      '-keyout',
      keyPath,
      '-out',
      requestPath,
      '-subj',
      '/CN=localhost',
    ]);
    final extensionsPath = '${certificates!.path}/server.ext';
    await io.File(extensionsPath)
        .writeAsString('basicConstraints=critical,CA:FALSE\n'
            'keyUsage=critical,digitalSignature,keyEncipherment\n'
            'extendedKeyUsage=serverAuth\n'
            'subjectAltName=DNS:localhost,IP:127.0.0.1\n');
    await openssl([
      'x509',
      '-req',
      '-in',
      requestPath,
      '-CA',
      authorityPath,
      '-CAkey',
      authorityKey,
      '-CAcreateserial',
      '-out',
      certificatePath,
      '-days',
      '1',
      '-extfile',
      extensionsPath,
    ]);
    final context = io.SecurityContext()
      ..useCertificateChain(certificatePath)
      ..usePrivateKey(keyPath);
    server = await io.HttpServer.bindSecure(
        io.InternetAddress.loopbackIPv4, 0, context);
    origin = 'https://127.0.0.1:${server!.port}';
    server!.listen((request) async {
      if (request.uri.path == '/socket') {
        final socket = await io.WebSocketTransformer.upgrade(request);
        peers.add(socket);
        socket.listen(socket.add);
      } else {
        request.response.headers.contentType = io.ContentType.json;
        request.response.write('{"secure":true}');
        await request.response.close();
      }
    }, onError: (Object error) {
      if (error is! io.HandshakeException) throw error;
    });
  });

  tearDownAll(() async {
    for (final peer in peers) {
      await peer.close().timeout(const Duration(seconds: 2));
    }
    await server?.close(force: true);
    await certificates?.delete(recursive: true);
  });

  for (final allow in [false, true]) {
    test('locally issued HTTPS respects allowAutoSignedCert=$allow', () async {
      final client = GetHttpClient(allowAutoSignedCert: allow);
      addTearDown(client.close);
      final response = await client
          .get<Map<String, dynamic>>('$origin/data')
          .timeout(const Duration(seconds: 3));
      if (allow) {
        expect(response.statusCode, 200);
        expect(response.body, {'secure': true});
      } else {
        expect(response.statusCode, isNull);
        expect(response.statusText, contains('HandshakeException'));
      }
    });
  }

  test('SDK control accepts the same explicit trust certificate', () async {
    final context = io.SecurityContext()..setTrustedCertificates(authorityPath);
    final control = io.HttpClient(context: context);
    addTearDown(() => control.close(force: true));
    final request = await control.getUrl(Uri.parse('$origin/data'));
    final response = await request.close();
    expect(response.statusCode, 200);
    await response.drain<void>();
  });

  test('explicit trusted certificate allows HTTPS without permissive callback',
      () async {
    final client = GetHttpClient(trustedCertificates: [
      TrustedCertificate(await io.File(authorityPath).readAsBytes()),
    ]);
    addTearDown(client.close);
    final response = await client
        .get<Map<String, dynamic>>('$origin/data')
        .timeout(const Duration(seconds: 3));
    expect(response.statusCode, 200, reason: response.statusText);
    expect(response.body, {'secure': true});
  });

  for (final allow in [false, true]) {
    test('locally issued WSS respects allowSelfSigned=$allow', () async {
      final socket = GetSocket(
          "${origin.replaceFirst('https:', 'wss:')}/socket",
          allowSelfSigned: allow,
          ping: const Duration(seconds: 10));
      addTearDown(socket.dispose);
      final echo = Completer<dynamic>();
      socket.onMessage(echo.complete);
      if (!allow) {
        await expectLater(socket.connect().timeout(const Duration(seconds: 3)),
            throwsA(isA<io.HandshakeException>()));
      } else {
        await socket.connect().timeout(const Duration(seconds: 3));
        socket.send('secure echo');
        expect(await echo.future.timeout(const Duration(seconds: 3)),
            'secure echo');
      }
    });
  }
}
