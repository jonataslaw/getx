import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.snackbar('title', 'message');
            },
          ),
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
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'total_confirmed'.tr,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '${state!.global.totalConfirmed}',
                    style: const TextStyle(
                        fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'total_deaths'.tr,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '${state.global.totalDeaths}',
                    style: const TextStyle(
                        fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.black),
                      side: const BorderSide(
                        color: Colors.deepPurple,
                        width: 3,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      //await Navigation  Get.rootDelegate.toNamed('/home/country');
                      Get.toNamed('/home/country');
                    },
                    child: Text(
                      'fetch_country'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.black),
                      side: const BorderSide(
                        color: Colors.deepPurple,
                        width: 3,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Get.updateLocale(const Locale('pt', 'BR'));
                    },
                    child: const Text(
                      'Update language to Portuguese',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
