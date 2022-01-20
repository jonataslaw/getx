import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () {
                final isLoggedIn = AuthService.to.isLoggedInValue;
                return Text(
                  'You are currently:'
                  ' ${isLoggedIn ? "Logged In" : "Not Logged In"}'
                  "\nIt's impossible to enter this "
                  "route when you are logged in!",
                );
              },
            ),
            MaterialButton(
              child: Text(
                'Do LOGIN !!',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              onPressed: () {
                AuthService.to.login();
                final thenTo = context.params['then'];
                Get.offNamed(thenTo ?? Routes.HOME);
              },
            ),
          ],
        ),
      ),
    );
  }
}
