import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.linearToSrgbGamma(),
          image: NetworkImage(
              "https://images.pexels.com/photos/3902882/pexels-photo-3902882.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('covid'.tr),
          backgroundColor: Colors.white10,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: controller.obx(
            (state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'total_confirmed'.tr,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '${state!.global.totalConfirmed}',
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'total_deaths'.tr,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '${state.global.totalDeaths}',
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: TextStyle(color: Colors.black),
                      side: BorderSide(
                        color: Colors.deepPurple,
                        width: 3,
                      ),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      Get.rootDelegate.toNamed('/home/country');
                    },
                    child: Text(
                      'fetch_country'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: TextStyle(color: Colors.black),
                      side: BorderSide(
                        color: Colors.deepPurple,
                        width: 3,
                      ),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      Get.updateLocale(Locale('pt', 'BR'));
                    },
                    child: Text(
                      'Update language to Portuguese',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
