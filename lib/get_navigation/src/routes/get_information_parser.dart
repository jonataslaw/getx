import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../get.dart';

class GetInformationParser extends RouteInformationParser<RouteDecoder> {
  factory GetInformationParser.createInformationParser(
      {String initialRoute = '/'}) {
    return GetInformationParser(initialRoute: initialRoute);
  }

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
      if (!(Get.rootController.rootDelegate)
          .registeredRoutes
          .any((element) => element.name == '/')) {
        location = initialRoute;
      }
    }

    Get.log('GetInformationParser: route location: $location');

    final routeName = location ?? initialRoute;

    return SynchronousFuture(RouteDecoder.fromRoute(routeName));
  }

  @override
  RouteInformation restoreRouteInformation(RouteDecoder configuration) {
    return RouteInformation(
      location: configuration.pageSettings?.name,
      state: null,
    );
  }
}
