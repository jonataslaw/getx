import 'package:flutter/material.dart';

import '../../../instance_manager.dart';
import '../router_report.dart';

class Dependencies {
  void lazyPut<S>(final InstanceBuilderCallback<S> builder,
      {final String? tag, final bool fenix = false}) {
    Get.lazyPut<S>(builder, tag: tag, fenix: fenix);
  }

  S call<S>() {
    return find<S>();
  }

  void spawn<S>(final InstanceBuilderCallback<S> builder,
          {final String? tag, final bool permanent = true}) =>
      Get.spawn<S>(builder, tag: tag, permanent: permanent);

  S find<S>({final String? tag}) => Get.find<S>(tag: tag);

  S put<S>(final S dependency,
          {final String? tag,
          final bool permanent = false,
          final InstanceBuilderCallback<S>? builder}) =>
      Get.put<S>(dependency, tag: tag, permanent: permanent);

  Future<bool> delete<S>({final String? tag, final bool force = false}) async =>
      Get.delete<S>(tag: tag, force: force);

  Future<void> deleteAll({final bool force = false}) async =>
      Get.deleteAll(force: force);

  void reloadAll({final bool force = false}) => Get.reloadAll(force: force);

  void reload<S>({final String? tag, final String? key, final bool force = false}) =>
      Get.reload<S>(tag: tag, key: key, force: force);

  bool isRegistered<S>({final String? tag}) => Get.isRegistered<S>(tag: tag);

  bool isPrepared<S>({final String? tag}) => Get.isPrepared<S>(tag: tag);

  void replace<P>(final P child, {final String? tag}) {
    final info = Get.getInstanceInfo<P>(tag: tag);
    final permanent = info.isPermanent ?? false;
    delete<P>(tag: tag, force: permanent);
    put(child, tag: tag, permanent: permanent);
  }

  void lazyReplace<P>(final InstanceBuilderCallback<P> builder,
      {final String? tag, final bool? fenix}) {
    final info = Get.getInstanceInfo<P>(tag: tag);
    final permanent = info.isPermanent ?? false;
    delete<P>(tag: tag, force: permanent);
    lazyPut(builder, tag: tag, fenix: fenix ?? permanent);
  }
}

abstract class Module extends StatefulWidget {
  const Module({super.key});

  Widget view(final BuildContext context);

  void dependencies(final Dependencies i);

  @override
  ModuleState createState() => ModuleState();
}

class ModuleState extends State<Module> {
  @override
  void initState() {
    RouterReportManager.instance.reportCurrentRoute(this);
    widget.dependencies(Dependencies());
    super.initState();
  }

  @override
  void dispose() {
    RouterReportManager.instance.reportRouteDispose(this);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return widget.view(context);
  }
}
