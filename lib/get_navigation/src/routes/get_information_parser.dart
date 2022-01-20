import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../get.dart';
import 'parse_route.dart';

class GetInformationParser extends RouteInformationParser<RouteDecoder> {
  final String initialRoute;

  GetInformationParser({
    required this.initialRoute,
  }) {
    Get.log('GetInformationParser is created !');
  }
  @override
  SynchronousFuture<RouteDecoder> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    var location = routeInformation.location;
    if (location == '/') {
      //check if there is a corresponding page
      //if not, relocate to initialRoute
      if (!Get.routeTree.routes.any((element) => element.name == '/')) {
        location = initialRoute;
      }
    }

    Get.log('GetInformationParser: route location: $location');

    final routeName = location ?? initialRoute;

    return SynchronousFuture(RouteDecoder.fromRoute(routeName));
  }

  @override
  RouteInformation restoreRouteInformation(RouteDecoder config) {
    return RouteInformation(
      location: config.arguments?.name,
      state: null,
    );
  }
}
