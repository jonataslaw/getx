import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class DetailsView extends GetView<HomeController> {
  const DetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PageSettings;
    final parameter = args.params; //Get.rootDelegate.parameters;
    final country = controller.getCountryById(parameter['id'] ?? '');
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.linearToSrgbGamma(),
          image: NetworkImage(
              "https://flagpedia.net/data/flags/normal/${country.countryCode.toLowerCase()}.png"),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('details'.tr),
              backgroundColor: Colors.black12,
              elevation: 0,
              centerTitle: true,
            ),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${country.country}',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 35,
                ),
                Text(
                  'total_confirmed'.tr,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text(
                  '${country.totalConfirmed}',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'total_deaths'.tr,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text(
                  '${country.totalDeaths}',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'total_recovered'.tr,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text(
                  '${country.totalRecovered}',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      Get.back(result: 'djsoidjsoidj');
                    },
                    child: Text('back'))
              ],
            )),
          ),
        ),
      ),
    );
  }
}
