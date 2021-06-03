import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../../get.dart';

class GetInformationParser extends RouteInformationParser<GetNavConfig> {
  final String initialRoute;

  GetInformationParser({
    this.initialRoute = '/',
  });
  @override
  SynchronousFuture<GetNavConfig> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    print('GetInformationParser: route location: ${routeInformation.location}');
    var location = routeInformation.location;
    if (location == '/') {
      //check if there is a corresponding page
      //if not, relocate to initialRoute
      if (!Get.routeTree.routes.any((element) => element.name == '/')) {
        location = initialRoute;
      }
    }

    final matchResult = Get.routeTree.matchRoute(location ?? initialRoute);

    return SynchronousFuture(
      GetNavConfig(
        currentTreeBranch: matchResult.treeBranch,
        location: location,
        state: routeInformation.state,
      ),
    );
  }

  @override
  RouteInformation restoreRouteInformation(GetNavConfig config) {
    return RouteInformation(
      location: config.location,
      state: config.state,
    );
  }
}
