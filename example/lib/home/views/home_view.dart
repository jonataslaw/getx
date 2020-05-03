import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_state/home/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
              image: NetworkImage(
                  "https://images.pexels.com/photos/3902882/pexels-photo-3902882.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Corona Virus"),
          backgroundColor: Colors.white10,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: GetBuilder<Controller>(
              init: Controller(),
              initState: (_) {
                Controller.to.fetchDataFromApi();
              },
              builder: (_) {
                if (_.data == null) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "Total Confirmed",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        '${_.data.global.totalConfirmed}',
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Deaths",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        '${_.data.global.totalDeaths}',
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 3,
                          ),
                          shape: StadiumBorder(),
                          onPressed: () {
                            Get.toNamed('/country');
                          },
                          child: Text(
                            "Fetch by country",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
