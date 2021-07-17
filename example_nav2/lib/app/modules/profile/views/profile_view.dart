import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          children: [
            Text(
              'ProfileView is working',
              style: TextStyle(fontSize: 20),
            ),
            MaterialButton(
              child: Text('Show a test dialog'),
              onPressed: () {
                //shows a dialog
                Get.defaultDialog(
                  title: 'Test Dialog !!',
                  barrierDismissible: true,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
