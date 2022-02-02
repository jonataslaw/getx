import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body:
      SingleChildScrollView(
        child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => Image.network("${controller.userProfileImage}")),
              MaterialButton(
                child: Text(
                  'search champion where yo gradesat !!',
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                onPressed: () {
                  controller.searchSummoner();
                },
              ),
              Obx(() => Text("${controller.updateText}")),
              Hero(
                tag: 'heroLogo',
                child: const FlutterLogo(),
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
              ),
              MaterialButton(
                child: Obx(() => Text("${controller.myNameAndLevel}")),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Test Dialog In Home Outlet !!',
                    barrierDismissible: true,
                    navigatorKey: Get.nestedKey(Routes.HOME),
                  );
                },
              ),
              SfCartesianChart(
                // Initialize category axis
                  primaryXAxis: CategoryAxis(),
                  series: <LineSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                      // Bind data source
                        dataSource: controller.salesData,
                        onRendererCreated: (ChartSeriesController ct) {
                          controller.chartSeriesController = ct;
                        },
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales)
                  ]),
                  Obx(() => ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.matchItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.matchItems[index];
                        return ListTile(
                          onTap: () {
                            Get.rootDelegate.toNamed(Routes.SETTINGS);
                          },
                          title: Text(item.kda),
                          tileColor: Colors.red,
                          subtitle: Text(item.timeAgo),
                          leading: Image.network(item.imageUrl),
                        );
                      })
              )
            ],
          ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
