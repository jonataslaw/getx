import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../routes/app_pages.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirect(RouteDecoder route) async {
    // you can do whatever you want here
    // but it's preferable to make this method fast
    // await Future.delayed(Duration(milliseconds: 500));

    if (!AuthService.to.isLoggedInValue) {
      final path = route.pageSettings?.name as String;
      final newRoute = Routes.LOGIN_THEN(path);

      return RouteDecoder.fromRoute(newRoute);
    }
    return super.redirect(route);
  }
}

class EnsureNotAuthedMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirect(RouteDecoder route) async {
    if (AuthService.to.isLoggedInValue) {
      //NEVER navigate to auth screen, when user is already authed
      return null;

      //OR redirect user to another screen
      //return RouteDecoder.fromRoute(Routes.PROFILE);
    }
    return super.redirect(route);
  }
}
