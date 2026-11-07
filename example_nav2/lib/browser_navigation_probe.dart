import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Browser integration entry point for test/browser/navigation_smoke.mjs.
// The exported hooks drive public GetX navigation and observe rendered pages.
@JS('window.getxProbeState')
external set _browserState(JSString value);

@JS('window.getxProbeNavigate')
external set _browserNavigate(JSFunction value);

@JS('window.getxProbeNavigateWithArguments')
external set _browserNavigateWithArguments(JSFunction value);

final _boot = DateTime.now().microsecondsSinceEpoch.toString();

void main() {
  _browserNavigate = ((JSString location) {
    Get.toNamed<void>(location.toDart);
  }).toJS;
  _browserNavigateWithArguments = ((JSString location, JSString arguments) {
    Get.toNamed<void>(location.toDart, arguments: jsonDecode(arguments.toDart));
  }).toJS;
  runApp(GetMaterialApp(
    initialRoute: '/',
    restorationScopeId: const bool.fromEnvironment('GETX_PROBE_RESTORATION')
        ? 'browser_navigation_probe'
        : null,
    defaultTransition: Transition.noTransition,
    getPages: [
      GetPage(name: '/', page: () => const _ProbePage('home')),
      GetPage(name: '/second', page: () => const _ProbePage('second')),
      GetPage(name: '/item/:id', page: () => const _ProbePage('item')),
      GetPage(
        name: '/shell',
        participatesInRootNavigator: true,
        page: () => Scaffold(
          appBar: AppBar(title: const Text('Nested browser probe')),
          body: GetRouterOutlet(
            anchorRoute: '/shell',
            initialRoute: '/shell/item/default',
          ),
        ),
        children: [
          GetPage(
            name: '/item/:id',
            participatesInRootNavigator: false,
            page: () => const _ProbePage('nested item'),
          ),
          GetPage(
            name: '/private',
            participatesInRootNavigator: false,
            middlewares: [_NestedRedirect()],
            page: () => const _ProbePage('private must not render'),
          ),
        ],
      ),
    ],
  ));
}

class _NestedRedirect extends GetMiddleware {
  @override
  RouteDecoder redirectDelegate(RouteDecoder route) =>
      RouteDecoder.fromRoute('/shell/item/redirected?from=guard');
}

class _ProbePage extends StatelessWidget {
  const _ProbePage(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => RouterListener(builder: (context) {
        final location = Get.rootController.rootDelegate.currentConfiguration
            ?.pageSettings?.name;
        final parameters = Map<String, String>.from(Get.parameters);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          var route = ModalRoute.of(context);
          if (route == null) return;
          // A child can stay current inside a covered parent navigator.
          while (route != null) {
            if (!route.isCurrent) return;
            final navigatorContext = route.navigator?.context;
            route = navigatorContext == null
                ? null
                : ModalRoute.of(navigatorContext);
          }
          _browserState = jsonEncode({
            'boot': _boot,
            'label': label,
            'location': location,
            'parameters': parameters,
            'arguments': Get.arguments,
            'argumentIsInt': Get.arguments is int,
            'argumentIsDouble': Get.arguments is double,
            'history': [
              for (final entry in Get.rootController.rootDelegate.activePages)
                entry.pageSettings?.name,
            ],
          }).toJS;
        });
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, textDirection: TextDirection.ltr),
                Text(location ?? 'no route', textDirection: TextDirection.ltr),
                Text(jsonEncode(parameters), textDirection: TextDirection.ltr),
                TextButton(
                  onPressed: () => Get.toNamed<void>('/second?from=button'),
                  child: const Text('Open second page'),
                ),
              ],
            ),
          ),
        );
      });
}
