import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Widget pageRemovalApp({
  required String initialRoute,
  required List<GetPage> getPages,
}) {
  // Chrome's widget-test host has no valid base href for PathUrlStrategy.
  // Browser navigation probes cover the production URL strategy separately.
  final delegate = GetDelegate(pages: getPages, showHashOnUrl: true);
  final provider = PlatformRouteInformationProvider(
    initialRouteInformation: RouteInformation(uri: Uri.parse(initialRoute)),
  );
  addTearDown(delegate.dispose);
  addTearDown(provider.dispose);
  return GetMaterialApp.router(
    routerDelegate: delegate,
    routeInformationProvider: provider,
  );
}
