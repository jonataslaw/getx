import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
// The GetX consumer already resolves this Flutter SDK package through get.
// This control deliberately uses no GetX code and changes no dependencies.
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

@JS('window.getxProbeState')
external set _browserState(JSString value);

final _boot = DateTime.now().microsecondsSinceEpoch.toString();

void main() {
  usePathUrlStrategy();
  runApp(MaterialApp.router(
    routerDelegate: _ControlDelegate(),
    routeInformationParser: _ControlParser(),
  ));
}

class _ControlParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async =>
      routeInformation.uri;

  @override
  RouteInformation restoreRouteInformation(Uri configuration) =>
      RouteInformation(uri: configuration);
}

class _ControlDelegate extends RouterDelegate<Uri> with ChangeNotifier {
  Uri current = Uri.parse('/');

  @override
  Future<bool> popRoute() async => false;

  @override
  Uri get currentConfiguration => current;

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    current = configuration;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _browserState = jsonEncode({
        'boot': _boot,
        'label': 'item',
        'location': current.toString(),
        'parameters': {
          ...current.queryParameters,
          'id': current.pathSegments.isEmpty ? '' : current.pathSegments.last,
        },
      }).toJS;
    });
    return Scaffold(body: Center(child: Text(current.toString())));
  }
}
