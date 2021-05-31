import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../../get.dart';

class GetInformationParser extends RouteInformationParser<GetPage> {
  @override
  SynchronousFuture<GetPage> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    if (routeInformation.location == '/') {
      return SynchronousFuture(Get.routeTree.routes.first);
    }
    print('route location: ${routeInformation.location}');
    final page = Get.routeTree.matchRoute(routeInformation.location!);
    print(page.parameters);
    final val = page.route!.copy(
      name: routeInformation.location,
      parameter: Map.from(page.parameters),
    );
    return SynchronousFuture(val);
  }

  @override
  RouteInformation restoreRouteInformation(GetPage uri) {
    print('restore $uri');

    return RouteInformation(location: uri.name);
  }
}
