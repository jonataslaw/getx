import 'package:flutter/widgets.dart';

import '../../../get.dart';

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
    GetPage? currentPage,
    required String? location,
    required Object? state,
  }) {
    return GetNavConfig(
      currentTreeBranch: currentTreeBranch ?? this.currentTreeBranch,
      location: location ?? this.location,
      state: state ?? this.state,
    );
  }

  @override
  String toString() => '''
======GetNavConfig=====\ncurrentTreeBranch: $currentTreeBranch\ncurrentPage: $currentPage\n======GetNavConfig=====''';
}
