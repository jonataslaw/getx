import 'dart:io' show pid;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

final _processBootId = DateTime.now().microsecondsSinceEpoch.toString();

void main() => runApp(const FlutterRestorationControl());

class FlutterRestorationControl extends StatefulWidget {
  const FlutterRestorationControl({super.key});

  @override
  State<FlutterRestorationControl> createState() =>
      _FlutterRestorationControlState();
}

class _FlutterRestorationControlState extends State<FlutterRestorationControl> {
  late final SemanticsHandle _semantics;

  @override
  void initState() {
    super.initState();
    _semantics = WidgetsBinding.instance.ensureSemantics();
  }

  @override
  void dispose() {
    _semantics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    restorationScopeId: 'device_probe_app',
    theme: ThemeData(platform: TargetPlatform.iOS),
    home: const _ControlRoot(),
  );
}

Widget _status(String identifier, String text) => Semantics(
  identifier: identifier,
  label: text,
  excludeSemantics: true,
  child: Text(text),
);

Widget _button(String identifier, String text, VoidCallback onPressed) =>
    Semantics(
      identifier: identifier,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );

class _ControlRoot extends StatefulWidget {
  const _ControlRoot();

  @override
  State<_ControlRoot> createState() => _ControlRootState();
}

@pragma('vm:entry-point')
class _ControlRootState extends State<_ControlRoot> with RestorationMixin {
  String _result = 'unset';
  late final RestorableRouteFuture<int> _detail = RestorableRouteFuture<int>(
    onPresent: (navigator, arguments) =>
        navigator.restorablePush<int>(_detailRoute, arguments: arguments),
    onComplete: (result) {
      if (mounted) setState(() => _result = '$result');
    },
  );

  @pragma('vm:entry-point')
  static Route<int> _detailRoute(BuildContext context, Object? arguments) =>
      MaterialPageRoute<int>(builder: (context) => const _ControlDetail());

  @override
  String get restorationId => 'control_root';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_detail, 'detail_route');
  }

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('FLUTTER_CONTROL')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _status('probe.root.marker', 'ROOT_ROUTE'),
          _status('probe.boot', 'BOOT:$_processBootId'),
          _status('probe.pid', 'PID:$pid'),
          _status('probe.result', 'RESULT:$_result'),
          _button('probe.open.detail', 'OPEN_DETAIL', () {
            setState(() => _result = 'pending');
            _detail.present();
          }),
        ],
      ),
    ),
  );
}

class _ControlDetail extends StatefulWidget {
  const _ControlDetail();

  @override
  State<_ControlDetail> createState() => _ControlDetailState();
}

class _ControlDetailState extends State<_ControlDetail> with RestorationMixin {
  final _count = RestorableInt(0);
  final _note = RestorableTextEditingController();

  @override
  String get restorationId => 'probe_detail';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_count, 'count');
    registerForRestoration(_note, 'note');
  }

  @override
  void dispose() {
    _count.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('DETAIL'),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _status('probe.detail.marker', 'DETAIL_ROUTE'),
          _status('probe.boot', 'BOOT:$_processBootId'),
          _status('probe.pid', 'PID:$pid'),
          _status('probe.detail.policy', 'CAN_POP:true'),
          _status('probe.count', 'COUNT:${_count.value}'),
          _button('probe.increment', 'COUNTER_PLUS', () {
            setState(() => _count.value++);
          }),
          Semantics(
            identifier: 'probe.note.input',
            child: TextField(
              controller: _note.value,
              decoration: const InputDecoration(labelText: 'NOTE_INPUT'),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _note.value,
            builder: (context, value, child) => _status(
              'probe.note.value',
              'NOTE:${value.text.isEmpty ? 'EMPTY' : value.text}',
            ),
          ),
          _button('probe.close.result', 'CLOSE_WITH_42', () {
            Navigator.of(context).pop<int>(42);
          }),
        ],
      ),
    ),
  );
}
