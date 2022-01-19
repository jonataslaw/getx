import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../../get.dart';
import '../../root/parse_route.dart';

class NewGetInformationParser extends RouteInformationParser<RouteDecoder> {
  final String initialRoute;

  NewGetInformationParser({
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

    return SynchronousFuture(_locationToRouteDecoder(routeName));
  }

  RouteDecoder _locationToRouteDecoder(String location) {
    var uri = Uri.parse(location);
    final args = PageSettings(uri);
    final decoder = Get.routeTree.matchRoute(location, arguments: args);
    decoder.route = decoder.route?.copy(
      completer: null,
      arguments: args,
      parameters: args.params,
    );
    return decoder;
  }

  @override
  RouteInformation restoreRouteInformation(RouteDecoder config) {
    return RouteInformation(
      location: config.arguments?.name,
      state: null,
    );
  }
}
