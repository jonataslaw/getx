import 'package:flutter/material.dart';

import '../router_report.dart';
import 'default_route.dart';

abstract class Module extends StatefulWidget {
  Module({Key? key, required this.builder}) : super(key: key);

  final WidgetBuilder builder;

  @override
  _ModuleState createState() => _ModuleState();
}

class _ModuleState extends State<Module> with RouteReportMixin<Module> {
  @override
  void initState() {
    RouterReportManager.instance.reportCurrentRoute(this);
    super.initState();
  }

  @override
  void dispose() {
    RouterReportManager.instance.reportRouteDispose(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
