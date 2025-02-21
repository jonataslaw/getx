import 'package:flutter/widgets.dart';

class GetNavigator extends Navigator {
  GetNavigator({
    super.key,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    required super.pages,
    List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    TransitionDelegate? transitionDelegate,
    super.initialRoute,
    super.restorationScopeId,
  }) : super(
          // ignore: deprecated_member_use
          onPopPage: onPopPage ??
              (route, result) {
                final didPop = route.didPop(result);
                if (!didPop) {
                  return false;
                }
                return true;
              },
          observers: [
            // GetObserver(null, Get.routing),
            HeroController(),
            ...?observers,
          ],
          transitionDelegate:
              transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );
}
