import 'package:flutter/widgets.dart';

import '../../../get.dart';

// class GetRouterState extends GetxController {
//   GetRouterState({required this.currentTreeBranch});
//   final List<GetPage> currentTreeBranch;
//   GetPage? get currentPage => currentTreeBranch.last;

//   static GetNavConfig? fromRoute(String route) {
//     final res = Get.routeTree.matchRoute(route);
//     if (res.treeBranch.isEmpty) return null;
//     return GetNavConfig(
//       currentTreeBranch: res.treeBranch,
//       location: route,
//       state: null,
//     );
//   }
// }

/// This config enables us to navigate directly to a sub-url
class GetNavConfig extends RouteInformation {
  final List<GetPage> currentTreeBranch;
  GetPage? get currentPage => currentTreeBranch.last;

  GetNavConfig({
    required this.currentTreeBranch,
    required String? location,
    required Object? state,
  }) : super(
          location: location,
          state: state,
        );

  GetNavConfig copyWith({
    List<GetPage>? currentTreeBranch,
    required String? location,
    required Object? state,
  }) {
    return GetNavConfig(
      currentTreeBranch: currentTreeBranch ?? this.currentTreeBranch,
      location: location ?? this.location,
      state: state ?? this.state,
    );
  }

  static GetNavConfig? fromRoute(String route) {
    final res = Get.routeTree.matchRoute(route);
    if (res.treeBranch.isEmpty) return null;
    return GetNavConfig(
      currentTreeBranch: res.treeBranch,
      location: route,
      state: null,
    );
  }

  @override
  String toString() => '''
======GetNavConfig=====\nlocation: $location\ncurrentTreeBranch: $currentTreeBranch\n======GetNavConfig=====''';
}
