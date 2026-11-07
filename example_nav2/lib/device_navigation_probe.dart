import 'dart:io' show pid;

import 'package:flutter/foundation.dart';
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
    this.platform,
  });

  final String? bootId;
  final String initialRoute;

  /// The platform used for transitions, or the runtime platform when omitted.
  final TargetPlatform? platform;

  @override
  State<DeviceNavigationProbeApp> createState() =>
      _DeviceNavigationProbeAppState();
}

class _DeviceNavigationProbeAppState extends State<DeviceNavigationProbeApp> {
  late final SemanticsHandle _semantics;
  final _metrics = _ProbeMetrics();
  late final _observer = _ProbeNavigationObserver(_metrics);

  @override
  void initState() {
    super.initState();
    _semantics = WidgetsBinding.instance.ensureSemantics();
  }

  @override
  void dispose() {
    _semantics.dispose();
    _observer.dispose();
    _metrics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bootId = widget.bootId ?? _processBootId;
    final platform = widget.platform ?? defaultTargetPlatform;
    final android = platform == TargetPlatform.android;
    final transition = android ? Transition.native : Transition.cupertino;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'device_probe_app',
      theme: ThemeData(platform: platform),
      navigatorObservers: [_observer],
      initialRoute: widget.initialRoute,
      popGesture: !android,
      getPages: [
        GetPage<void>(
          name: '/probe/root',
          restorationId: 'probe_root_page',
          page: () => _ProbeRoot(bootId: bootId, metrics: _metrics),
        ),
        GetPage<int>(
          name: '/probe/detail',
          restorationId: 'probe_detail_page',
          transition: transition,
          popGesture: !android,
          binding: _ProbeBinding(_metrics, '/probe/detail'),
          page: () => _ProbeDetail(bootId: bootId, metrics: _metrics),
        ),
        GetPage<int>(
          name: '/probe/veto',
          restorationId: 'probe_veto_page',
          transition: transition,
          popGesture: !android,
          canPop: false,
          binding: _ProbeBinding(_metrics, '/probe/veto'),
          page: () =>
              _ProbeDetail(bootId: bootId, metrics: _metrics, veto: true),
        ),
        GetPage<int>(
          name: '/probe/scope',
          restorationId: 'probe_scope_page',
          transition: transition,
          popGesture: !android,
          binding: _ProbeBinding(_metrics, '/probe/scope'),
          page: () =>
              _ProbeDetail(bootId: bootId, metrics: _metrics, scopeVeto: true),
        ),
      ],
    );
  }
}

class _ProbeMetrics extends ChangeNotifier {
  int created = 0;
  int closed = 0;
  int started = 0;
  int stopped = 0;
  int progressed = 0;
  bool _disposed = false;

  void changed() {
    // Controller disposal can occur while Navigator is finalizing its tree.
    Future.microtask(() {
      if (!_disposed) notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _ProbeController extends GetxController {
  _ProbeController(this.metrics);
  final _ProbeMetrics metrics;

  @override
  void onInit() {
    super.onInit();
    metrics.created++;
    metrics.changed();
  }

  @override
  void onClose() {
    metrics.closed++;
    metrics.changed();
    super.onClose();
  }
}

class _ProbeBinding extends Binding {
  _ProbeBinding(this.metrics, this.tag);
  final _ProbeMetrics metrics;
  final String tag;

  @override
  List<Bind> dependencies() => [
    Bind.lazyPut(() => _ProbeController(metrics), tag: tag),
  ];
}

class _ProbeNavigationObserver extends NavigatorObserver {
  _ProbeNavigationObserver(this.metrics);
  final _ProbeMetrics metrics;
  Animation<double>? _animation;
  bool _progressRecorded = false;

  void _onProgress() {
    if (!_progressRecorded && _animation!.value < 0.99) {
      _progressRecorded = true;
      metrics.progressed++;
      metrics.changed();
    }
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    _animation?.removeListener(_onProgress);
    _animation = route is TransitionRoute<dynamic> ? route.animation : null;
    _progressRecorded = false;
    _animation?.addListener(_onProgress);
    metrics.started++;
    metrics.changed();
  }

  @override
  void didStopUserGesture() {
    _animation?.removeListener(_onProgress);
    _animation = null;
    metrics.stopped++;
    metrics.changed();
  }

  void dispose() {
    _animation?.removeListener(_onProgress);
    _animation = null;
  }
}

Widget _metricsStatus(_ProbeMetrics metrics) => ListenableBuilder(
  listenable: metrics,
  builder: (context, child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _status(
        'probe.lifetime',
        'LIFETIME:created=${metrics.created},closed=${metrics.closed},'
            'active=${metrics.created - metrics.closed}',
      ),
      _status(
        'probe.gestures',
        'GESTURES:started=${metrics.started},stopped=${metrics.stopped},'
            'progressed=${metrics.progressed}',
      ),
    ],
  ),
);

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
  const _ProbeRoot({required this.bootId, required this.metrics});
  final String bootId;
  final _ProbeMetrics metrics;

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
          _metricsStatus(widget.metrics),
          _status('probe.result', 'RESULT:$_result'),
          _button(
            'probe.open.detail',
            'OPEN_DETAIL',
            () => _open('/probe/detail'),
          ),
          _button('probe.open.veto', 'OPEN_VETO', () => _open('/probe/veto')),
          _button(
            'probe.open.scope',
            'OPEN_SCOPE_VETO',
            () => _open('/probe/scope'),
          ),
        ],
      ),
    ),
  );
}

class _ProbeDetail extends StatefulWidget {
  const _ProbeDetail({
    required this.bootId,
    required this.metrics,
    this.veto = false,
    this.scopeVeto = false,
  });
  final String bootId;
  final _ProbeMetrics metrics;
  final bool veto;
  final bool scopeVeto;

  @override
  State<_ProbeDetail> createState() => _ProbeDetailState();
}

class _ProbeDetailState extends State<_ProbeDetail> with RestorationMixin {
  final _count = RestorableInt(0);
  final _note = RestorableTextEditingController();
  bool _scopeBlocked = true;
  bool get _blocked => widget.veto || (widget.scopeVeto && _scopeBlocked);

  String get _route => widget.veto
      ? '/probe/veto'
      : widget.scopeVeto
      ? '/probe/scope'
      : '/probe/detail';

  @override
  void initState() {
    super.initState();
    Get.find<_ProbeController>(tag: _route);
  }

  @override
  String get restorationId => _route.substring(1).replaceAll('/', '_');

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
  Widget build(BuildContext context) {
    final page = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.veto
              ? 'VETO'
              : widget.scopeVeto
              ? 'SCOPE VETO'
              : 'DETAIL',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _status(
              widget.veto
                  ? 'probe.veto.marker'
                  : widget.scopeVeto
                  ? 'probe.scope.marker'
                  : 'probe.detail.marker',
              widget.veto
                  ? 'VETO_ROUTE'
                  : widget.scopeVeto
                  ? 'SCOPE_VETO_ROUTE'
                  : 'DETAIL_ROUTE',
            ),
            _status('probe.boot', 'BOOT:${widget.bootId}'),
            _status('probe.pid', 'PID:$pid'),
            _status('probe.build', 'BUILD:$_buildFingerprint'),
            _snapshotStatus(),
            _metricsStatus(widget.metrics),
            _status(
              widget.veto ? 'probe.veto.policy' : 'probe.detail.policy',
              'CAN_POP:${!_blocked}',
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
            if (widget.scopeVeto && _scopeBlocked)
              _button(
                'probe.scope.allow',
                'ALLOW_SCOPE_BACK',
                () => setState(() => _scopeBlocked = false),
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
    return widget.scopeVeto
        ? PopScope<int>(canPop: !_scopeBlocked, child: page)
        : page;
  }
}
