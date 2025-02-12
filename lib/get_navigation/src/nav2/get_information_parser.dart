import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../get.dart';

class GetInformationParser extends RouteInformationParser<GetNavConfig> {
  final String initialRoute;

  GetInformationParser({
    this.initialRoute = '/',
  }) {
    Get.log('GetInformationParser is created !');
  }
  @override
  SynchronousFuture<GetNavConfig> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final uri = routeInformation.uri;
    var location = uri.toString();
    if (location == '/') {
      //check if there is a corresponding page
      //if not, relocate to initialRoute
      if (!Get.routeTree.routes.any((element) => element.name == '/')) {
        location = initialRoute;
      }
    } else if (location.isEmpty) {
      location = initialRoute;
    }

    Get.log('GetInformationParser: route location: $location');

    final matchResult = Get.routeTree.matchRoute(location);

    return SynchronousFuture(
      GetNavConfig(
        currentTreeBranch: matchResult.treeBranch,
        location: location,
        state: routeInformation.state,
      ),
    );
  }

  @override
  RouteInformation restoreRouteInformation(GetNavConfig configuration) {
    return RouteInformation(
      uri: Uri.tryParse(configuration.locationString),
      state: configuration.state,
    );
  }
}
