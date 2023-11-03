import 'package:flutter/widgets.dart';

import '../../../get.dart';

class GetNavigator extends Navigator {

  GetNavigator({
    required List<GetPage> super.pages, super.key,
    final bool Function(Route<dynamic>, dynamic)? onPopPage,
    final List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    final TransitionDelegate? transitionDelegate,
    super.initialRoute,
    super.restorationScopeId,
  }) : super(
          //keys should be optional
          onPopPage: onPopPage ??
              (final route, final result) {
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
  GetNavigator.onGenerateRoute({
    required List<GetPage> super.pages, GlobalKey<NavigatorState>? super.key,
    final bool Function(Route<dynamic>, dynamic)? onPopPage,
    final List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    final TransitionDelegate? transitionDelegate,
    super.initialRoute,
    super.restorationScopeId,
  }) : super(
          //keys should be optional
          onPopPage: onPopPage ??
              (final route, final result) {
                final didPop = route.didPop(result);
                if (!didPop) {
                  return false;
                }
                return true;
              },
          onGenerateRoute: (final settings) {
            final selectedPageList =
                pages.where((final element) => element.name == settings.name);
            if (selectedPageList.isNotEmpty) {
              final selectedPage = selectedPageList.first;
              return GetPageRoute(
                page: selectedPage.page,
                settings: settings,
              );
            }
            return null;
          },
          observers: [
            // GetObserver(),
            ...?observers,
          ],
          transitionDelegate:
              transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );
}
