import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class CountryView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
              image: NetworkImage(
                  "https://images.pexels.com/photos/3902882/pexels-photo-3902882.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"))),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('corona_by_country'.tr),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: Center(
              child: ListView.builder(
                  itemCount: controller.state!.countries.length,
                  itemBuilder: (context, index) {
                    final country = controller.state!.countries[index];
                    return ListTile(
                      onTap: () {
                        //Get.rootDelegate.toNamed('/home/country');
                        Get.rootDelegate
                            .toNamed('/home/country/details?id=$index');
                      },
                      trailing: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://flagpedia.net/data/flags/normal/${country.countryCode.toLowerCase()}.png"),
                      ),
                      title: Text(country.country),
                      subtitle: Text(
                          // ignore: lines_longer_than_80_chars
                          '${'total_infecteds'.tr}${' ${country.totalConfirmed}'}'),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
