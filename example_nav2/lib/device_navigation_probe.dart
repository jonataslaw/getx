import 'dart:io' show pid;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:get/get.dart';

final _processBootId = DateTime.now().microsecondsSinceEpoch.toString();
const _buildFingerprint = String.fromEnvironment(
  'PROBE_BUILD_FINGERPRINT',
  defaultValue: 'UNSET',
);
final _artifactInformationParser = GetInformationParser(
  initialRoute: _initialRoute,
);
const _initialRoute = String.fromEnvironment(
  'PROBE_INITIAL_ROUTE',
  defaultValue: '/probe/root',
);

void main() => runApp(const DeviceNavigationProbeApp());

/// A native-only entry point for navigation and restoration acceptance tests.
///
/// The default route is the root. Set `PROBE_INITIAL_ROUTE=/probe/detail` only
/// for a separate page-state restoration control, not a route-stack test.
/// [bootId] allows widget tests to inject a process marker without persistence.
class DeviceNavigationProbeApp extends StatefulWidget {
  const DeviceNavigationProbeApp({
    super.key,
    this.bootId,
    this.initialRoute = _initialRoute,
  });

  final String? bootId;
  final String initialRoute;

  @override
  State<DeviceNavigationProbeApp> createState() =>
      _DeviceNavigationProbeAppState();
}

class _DeviceNavigationProbeAppState extends State<DeviceNavigationProbeApp> {
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
  Widget build(BuildContext context) {
    final bootId = widget.bootId ?? _processBootId;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'device_probe_app',
      theme: ThemeData(platform: TargetPlatform.iOS),
      initialRoute: widget.initialRoute,
      popGesture: true,
      getPages: [
        GetPage<void>(
          name: '/probe/root',
          restorationId: 'probe_root_page',
          page: () => _ProbeRoot(bootId: bootId),
        ),
        GetPage<int>(
          name: '/probe/detail',
          restorationId: 'probe_detail_page',
          transition: Transition.cupertino,
          popGesture: true,
          page: () => _ProbeDetail(bootId: bootId),
        ),
        GetPage<int>(
          name: '/probe/veto',
          restorationId: 'probe_veto_page',
          transition: Transition.cupertino,
          popGesture: true,
          canPop: false,
          page: () => _ProbeDetail(bootId: bootId, veto: true),
        ),
      ],
    );
  }
}

Widget _status(String identifier, String text) => Semantics(
  identifier: identifier,
  label: text,
  excludeSemantics: true,
  child: Text(text),
);

Widget _snapshotStatus() => RouterListener(
  builder: (context) {
    final configuration = Get.rootController.rootDelegate.currentConfiguration;
    final present =
        configuration != null &&
        _artifactInformationParser
                .restoreRouteInformation(configuration)
                .state !=
            null;
    return _status('probe.snapshot', 'SNAPSHOT_PRESENT:$present');
  },
);

Widget _button(String identifier, String text, VoidCallback onPressed) =>
    Semantics(
      identifier: identifier,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );

class _ProbeRoot extends StatefulWidget {
  const _ProbeRoot({required this.bootId});
  final String bootId;

  @override
  State<_ProbeRoot> createState() => _ProbeRootState();
}

class _ProbeRootState extends State<_ProbeRoot> {
  String _result = 'unset';

  Future<void> _open(String route) async {
    setState(() => _result = 'pending');
    final int? result = await Get.toNamed<int>(route);
    if (mounted) setState(() => _result = '$result');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('DEVICE_PROBE')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _status('probe.root.marker', 'ROOT_ROUTE'),
          _status('probe.boot', 'BOOT:${widget.bootId}'),
          _status('probe.pid', 'PID:$pid'),
          _status('probe.build', 'BUILD:$_buildFingerprint'),
          _snapshotStatus(),
          _status('probe.result', 'RESULT:$_result'),
          _button(
            'probe.open.detail',
            'OPEN_DETAIL',
            () => _open('/probe/detail'),
          ),
          _button('probe.open.veto', 'OPEN_VETO', () => _open('/probe/veto')),
        ],
      ),
    ),
  );
}

class _ProbeDetail extends StatefulWidget {
  const _ProbeDetail({required this.bootId, this.veto = false});
  final String bootId;
  final bool veto;

  @override
  State<_ProbeDetail> createState() => _ProbeDetailState();
}

class _ProbeDetailState extends State<_ProbeDetail> with RestorationMixin {
  final _count = RestorableInt(0);
  final _note = RestorableTextEditingController();

  @override
  String get restorationId => widget.veto ? 'probe_veto' : 'probe_detail';

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
      title: Text(widget.veto ? 'VETO' : 'DETAIL'),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _status(
            widget.veto ? 'probe.veto.marker' : 'probe.detail.marker',
            widget.veto ? 'VETO_ROUTE' : 'DETAIL_ROUTE',
          ),
          _status('probe.boot', 'BOOT:${widget.bootId}'),
          _status('probe.pid', 'PID:$pid'),
          _status('probe.build', 'BUILD:$_buildFingerprint'),
          _snapshotStatus(),
          _status(
            widget.veto ? 'probe.veto.policy' : 'probe.detail.policy',
            'CAN_POP:${!widget.veto}',
          ),
          _status('probe.count', 'COUNT:${_count.value}'),
          _button(
            'probe.increment',
            'COUNTER_PLUS',
            () => setState(() => _count.value++),
          ),
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
          if (widget.veto)
            _button(
              'probe.reset.root',
              'RESET_TO_ROOT',
              () => Get.offAllNamed<void>('/probe/root'),
            )
          else
            _button(
              'probe.close.result',
              'CLOSE_WITH_42',
              () => Get.back<int>(result: 42),
            ),
        ],
      ),
    ),
  );
}
