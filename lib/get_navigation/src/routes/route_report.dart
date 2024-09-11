import 'package:flutter/material.dart';

import '../router_report.dart';
import 'default_route.dart';

class RouteReport extends StatefulWidget {
  const RouteReport({super.key, required this.builder});
  final WidgetBuilder builder;

  @override
  RouteReportState createState() => RouteReportState();
}

class RouteReportState extends State<RouteReport> with RouteReportMixin {
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
