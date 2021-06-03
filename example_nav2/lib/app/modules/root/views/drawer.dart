import 'package:example_nav2/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.red,
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Get.getDelegate()?.toNamed(Routes.HOME);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Get.getDelegate()?.toNamed(Routes.SETTINGS);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
