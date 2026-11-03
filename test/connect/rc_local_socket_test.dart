@TestOn('vm')
library;

import 'dart:async';
import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/sockets/sockets.dart';

void main() {
  late io.HttpServer server;
  late List<io.WebSocket> peers;
  late List<GetSocket> clients;
  late String url;
  late void Function(io.WebSocket) accepted;
  Future<void> Function(io.HttpRequest)? beforeUpgrade;

  setUp(() async {
    server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    peers = [];
    clients = [];
    url = 'ws://${server.address.address}:${server.port}/socket';
    beforeUpgrade = null;
    accepted = (peer) {
      peer.listen(peer.add);
    };
    server.listen((request) async {
      await beforeUpgrade?.call(request);
      final peer = await io.WebSocketTransformer.upgrade(request);
      peers.add(peer);
      accepted(peer);
    });
  });

  tearDown(() async {
    for (final client in clients) {
      client.close();
    }
    for (final peer in peers) {
      await peer.close().timeout(const Duration(seconds: 2));
    }
    for (final client in clients) {
      client.dispose();
    }
    await server.close(force: true);
  });

  GetSocket makeClient({bool allowSelfSigned = false}) {
    final client = GetSocket(url,
        allowSelfSigned: allowSelfSigned,
        ping: const Duration(milliseconds: 50));
    clients.add(client);
    return client;
  }

  for (final allowSelfSigned in [false, true]) {
    test(
        'local socket exchanges text, binary and named events '
        '(allowSelfSigned=$allowSelfSigned)', () async {
      final client = makeClient(allowSelfSigned: allowSelfSigned);
      final text = Completer<dynamic>();
      final binary = Completer<dynamic>();
      final event = Completer<dynamic>();
      client.onOpen(() {});
      client.onMessage((data) {
        if (data == 'hello' && !text.isCompleted) text.complete(data);
        if (data is List<int> && !binary.isCompleted) binary.complete(data);
      });
      client.on('answer', (data) => event.complete(data));
      await client.connect();
      client.send('hello');
      client.send([0, 127, 255]);
      client.emit('answer', {'value': 42});
      expect(await text.future.timeout(const Duration(seconds: 3)), 'hello');
      expect(await binary.future.timeout(const Duration(seconds: 3)),
          [0, 127, 255]);
      expect(await event.future.timeout(const Duration(seconds: 3)),
          {'value': 42});
    });
  }

  test('onOpen registration is optional for a message-only client', () async {
    final client = makeClient();
    final received = Completer<dynamic>();
    client.onMessage(received.complete);
    await client.connect();
    client.send('message without open callback');
    expect(await received.future.timeout(const Duration(seconds: 3)),
        'message without open callback');
  });

  test('remote close reports code and send reconnects once before delivery',
      () async {
    final client = makeClient();
    final closed = Completer<int?>();
    final received = Completer<dynamic>();
    var opens = 0;
    client.onOpen(() => opens++);
    client.onClose((event) {
      if (!closed.isCompleted) closed.complete(event.reason);
    });
    client.onMessage(received.complete);
    await client.connect();
    await peers.single.close(io.WebSocketStatus.normalClosure, 'server done');
    expect(await closed.future.timeout(const Duration(seconds: 3)),
        io.WebSocketStatus.normalClosure);
    client.send('after reconnect');
    expect(await received.future.timeout(const Duration(seconds: 3)),
        'after reconnect');
    expect(opens, 2);
    expect(peers, hasLength(2));
  });

  test('messages sent together after remote close share one reconnect',
      () async {
    final client = makeClient();
    var opens = 0;
    final closed = Completer<void>();
    final received = <dynamic>[];
    final both = Completer<void>();
    client.onOpen(() => opens++);
    client.onClose((_) {
      if (!closed.isCompleted) closed.complete();
    });
    client.onMessage((message) {
      received.add(message);
      if (received.length == 2) both.complete();
    });
    await client.connect();
    await peers.single.close();
    await closed.future.timeout(const Duration(seconds: 3));
    client.send('first');
    client.send('second');
    await both.future.timeout(const Duration(seconds: 3));
    expect(received, ['first', 'second']);
    expect(opens, 2);
    expect(peers, hasLength(2));
  });

  test('manual native reconnect closes its previous live transport', () async {
    final oldClosed = Completer<void>();
    accepted = (peer) {
      final isFirst = peers.length == 1;
      peer.listen(peer.add, onDone: () {
        if (isFirst && !oldClosed.isCompleted) oldClosed.complete();
      });
    };
    final client = makeClient();
    client.onOpen(() {});
    await client.connect();
    await client.connect();
    await oldClosed.future.timeout(const Duration(seconds: 2));
    expect(peers, hasLength(2));
  });

  test('connection refusal notifies onError without an open callback',
      () async {
    final unavailable =
        await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final port = unavailable.port;
    await unavailable.close(force: true);
    final client = GetSocket('ws://127.0.0.1:$port', allowSelfSigned: false);
    clients.add(client);
    final error = Completer<String?>();
    client.onError((event) => error.complete(event.message));
    await client.connect().timeout(const Duration(seconds: 3));
    expect(await error.future.timeout(const Duration(seconds: 3)), isNotEmpty);
  });

  test('dispose during handshake closes the late connection without callbacks',
      () async {
    final requestArrived = Completer<void>();
    final release = Completer<void>();
    final disconnected = Completer<void>();
    addTearDown(() {
      if (!release.isCompleted) release.complete();
    });
    beforeUpgrade = (request) async {
      requestArrived.complete();
      await release.future;
    };
    accepted = (peer) {
      peer.listen((_) {}, onDone: disconnected.complete);
    };
    final client = makeClient();
    var opened = false;
    client.onOpen(() => opened = true);
    final connecting = client.connect();
    await requestArrived.future.timeout(const Duration(seconds: 3));
    client.dispose();
    release.complete();
    await connecting.timeout(const Duration(seconds: 3));
    await disconnected.future.timeout(const Duration(seconds: 3));
    expect(opened, isFalse);
  });

  test('dispose closes the transport and is safe to call twice', () async {
    final disconnected = Completer<void>();
    accepted = (peer) {
      peer.listen((_) {}, onDone: disconnected.complete);
    };
    final client = makeClient();
    client.onOpen(() {});
    await client.connect();
    client.dispose();
    client.dispose();
    await disconnected.future.timeout(const Duration(seconds: 3));
    expect(disconnected.isCompleted, isTrue);
  });
}
