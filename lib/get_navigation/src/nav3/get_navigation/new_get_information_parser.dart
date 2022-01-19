import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../../get.dart';

class NewGetInformationParser extends RouteInformationParser<PageSettings> {
  final String initialRoute;

  NewGetInformationParser({
    required this.initialRoute,
  }) {
    Get.log('GetInformationParser is created !');
  }
  @override
  SynchronousFuture<PageSettings> parseRouteInformation(
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

    // final matchResult = Get.routeTree.matchRoute(location ?? initialRoute);

    return SynchronousFuture(
      PageSettings(
        Uri.parse(location!),
      ),
    );
  }

  @override
  RouteInformation restoreRouteInformation(PageSettings config) {
    return RouteInformation(
      location: config.name,
      state: null,
    );
  }
}
