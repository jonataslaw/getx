import 'package:flutter/widgets.dart';

import '../../../get.dart';

class GetNavigator extends Navigator {
  /// Creates a navigator whose page owner handles committed removals.
  ///
  /// [onDidRemovePage] updates the caller-owned page list after a route is
  /// removed. Configure back vetoes on [GetPage.canPop] or with `PopScope`.
  GetNavigator.onGenerateRoute({
    GlobalKey<NavigatorState>? super.key,
    DidRemovePageCallback? onDidRemovePage,
    required List<GetPage> super.pages,
    List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    TransitionDelegate? transitionDelegate,
    super.initialRoute,
    super.restorationScopeId,
  }) : super(
         onDidRemovePage: onDidRemovePage ?? (_) {},
         onGenerateRoute: (settings) {
           final selectedPageList = pages.where(
             (element) => element.name == settings.name,
           );
           if (selectedPageList.isNotEmpty) {
             final selectedPage = selectedPageList.first;
             return GetPageRoute(page: selectedPage.page, settings: settings);
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

  /// Creates a page-based navigator with a committed-removal callback.
  ///
  /// [onDidRemovePage] updates the caller-owned page list. It cannot veto a
  /// removal; use [GetPage.canPop] or `PopScope` for back policy.
  GetNavigator({
    super.key,
    DidRemovePageCallback? onDidRemovePage,
    required List<GetPage> super.pages,
    List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    TransitionDelegate? transitionDelegate,
    super.initialRoute,
    super.restorationScopeId,
  }) : super(
         onDidRemovePage: onDidRemovePage ?? (_) {},
         observers: [
           // GetObserver(null, Get.routing),
           HeroController(),
           ...?observers,
         ],
         transitionDelegate:
             transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
       );
}
