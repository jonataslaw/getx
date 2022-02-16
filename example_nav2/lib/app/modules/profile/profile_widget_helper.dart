import 'package:example_nav2/app/modules/profile/controllers/profile_controller.dart';
import 'package:example_nav2/app/modules/profile/views/profile_view.dart';
import 'package:example_nav2/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";

SfCartesianChart returnCartesianChart(ProfileController controller) {
  return SfCartesianChart(
    // Initialize category axis
      primaryXAxis: CategoryAxis(),
      series: <LineSeries<KDAData, String>>[
        LineSeries<KDAData, String>(
          // Bind data source
            dataSource: controller.kdaData,
            onRendererCreated: (ChartSeriesController ct) {
              controller.chartSeriesController = ct;
            },
            xValueMapper: (KDAData sales, _) => sales.champion,
            yValueMapper: (KDAData sales, _) => sales.kda)
      ]);
}

Column returnSomething() {
  final List<ChartData> chartData = <ChartData>[
    ChartData(x: 'Jan', yValue1: 45, yValue2: 1000),
    ChartData(x: 'Feb', yValue1: 100, yValue2: 3000),
    ChartData(x: 'March', yValue1: 25, yValue2: 1000),
    ChartData(x: 'April', yValue1: 100, yValue2: 7000),
    ChartData(x: 'May', yValue1: 85, yValue2: 5000),
    ChartData(x: 'June', yValue1: 140, yValue2: 7000)
  ];

  return Column(children: <Widget>[
    Container(
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          axes: <ChartAxis>[
            NumericAxis(
                numberFormat: NumberFormat.compact(),
                majorGridLines: const MajorGridLines(width: 0),
                opposedPosition: true,
                name: 'yAxis1',
                interval: 1000,
                minimum: 0,
                maximum: 7000)
          ],
          series: <ChartSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
                animationDuration: 2000,
                dataSource: chartData,
                xValueMapper: (ChartData sales, _) => sales.x,
                yValueMapper: (ChartData sales, _) => sales.yValue1,
                name: 'Unit Sold'),
            LineSeries<ChartData, String>(
                animationDuration: 4500,
                animationDelay: 2000,
                dataSource: chartData,
                xValueMapper: (ChartData sales, _) => sales.x,
                yValueMapper: (ChartData sales, _) => sales.yValue2,
                yAxisName: 'yAxis1',
                markerSettings: MarkerSettings(isVisible: true),
                name: 'Total Transaction')
          ],)),
    ]);
}

Column returnColumnLineGraph(ProfileController controller) {
  return Column(children: <Widget>[
    Container(
        child: Obx(() => SfCartesianChart(
          primaryXAxis: CategoryAxis(
            labelRotation: 45
          ),
          axes: <ChartAxis>[
            NumericAxis(
                numberFormat: NumberFormat.compact(),
                majorGridLines: const MajorGridLines(width: 0),
                opposedPosition: true,
                name: 'yAxis1',
                interval: 500,
                minimum: 0,
                maximum: controller.maxDamageToChampions.toDouble())
          ],
          series: <ChartSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
                animationDuration: 2000,
                dataSource: controller.kdaDamageData,
                onRendererCreated: (ChartSeriesController ct) {
                  controller.kdaColumnController = ct;
                },
                xValueMapper: (ChartData sales, _) => sales.x,
                yValueMapper: (ChartData sales, _) => sales.yValue1,
                name: 'KDA'),
            LineSeries<ChartData, String>(
                animationDuration: 4500,
                animationDelay: 2000,
                dataSource: controller.kdaDamageData,
                onRendererCreated: (ChartSeriesController ct) {
                  controller.damageLineController = ct;
                },
                xValueMapper: (ChartData sales, _) => sales.x,
                yValueMapper: (ChartData sales, _) => sales.yValue2,
                yAxisName: 'yAxis1',
                markerSettings: MarkerSettings(isVisible: true),
                name: 'Damage to champions')
          ],))),
  ]);
}


class ChartData {
  ChartData({this.x, this.yValue1, this.yValue2});
  final String? x;
  final double? yValue1;
  final double? yValue2;
}

SfCartesianChart returnColumnChart(ProfileController controller) {
  return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<KDAData, String>(
            dataSource: controller.kdaData,
            xValueMapper: (KDAData data, _) => data.champion,
            yValueMapper: (KDAData data, _) => data.kda,
            // Duration of series animation
            animationDuration: 1000
        )
      ]
  );
}

SfCartesianChart returnColumnChartMostPlayedChampions(ProfileController controller) {
  return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<KDAData, String>(
            dataSource: controller.mostPlayedChampionsData,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
            onRendererCreated: (ChartSeriesController ct) {
              controller.mostPlayedChampionsColumnController = ct;
            },
            xValueMapper: (KDAData data, _) => data.champion,
            yValueMapper: (KDAData data, _) => data.kda,
            // Duration of series animation
            animationDuration: 1000
        )
      ]
  );
}

SfCartesianChart returnColumnChartMostPlayedWithFriend(ProfileController controller) {
  return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<KDAData, String>(
            dataSource: controller.friendsData,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
            enableTooltip: true,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            onRendererCreated: (ChartSeriesController ct) {
              controller.friendsColumnController = ct;
            },
            xValueMapper: (KDAData data, _) => data.champion,
            yValueMapper: (KDAData data, _) => data.kda,
            // Duration of series animation
            animationDuration: 1000
        )
      ]
  );
}


ListView returnListView(ProfileController controller) {
  return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.matchItems.length,
      itemBuilder: (context, index) {
        final item = controller.matchItems[index];
        return ListTile(
          onTap: () {
            Get.rootDelegate.toNamed(Routes.SETTINGS);
          },
          title: Text("${item.kda} and ${item.damageDealtToChampions} damage"),
          tileColor: Colors.red,
          subtitle: Text("${item.timeAgo} as ${item.championName} for ${(item.gameDuration??1/60).toStringAsFixed(0)} minutes"),
          leading: Image.network(item.imageUrl??""),
        );
      });
}
