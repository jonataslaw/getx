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
    final uri = routeInformation.uri;
    var location = uri.toString();
    if (location == '/') {
      //check if there is a corresponding page
      //if not, relocate to initialRoute
      if (!(Get.rootController.rootDelegate)
          .registeredRoutes
          .any((element) => element.name == '/')) {
        location = initialRoute;
      }
    } else if (location.isEmpty) {
      location = initialRoute;
    }

    Get.log('GetInformationParser: route location: $location');

    return SynchronousFuture(RouteDecoder.fromRoute(location));
  }

  @override
  RouteInformation restoreRouteInformation(RouteDecoder configuration) {
    return RouteInformation(
      uri: Uri.tryParse(configuration.pageSettings?.name ?? ''),
      state: null,
    );
  }
}
