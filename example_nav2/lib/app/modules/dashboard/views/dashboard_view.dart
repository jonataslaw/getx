import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../dashboard_widget_helper.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Obx(() => SingleChildScrollView(
          child:
          Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(6.0, 0, 20.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildRankedSelectionTool(controller),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(4.0, 0, 0.0, 0),
                  child: Row(
                    children: [
                      Visibility(visible: controller.showRankedSearchFilter.value,
                        child: Expanded(child: TextFormField(
                        onChanged: (text) {
                          controller.filterChallengerPlayers(text);
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Filter by summoner name',
                        ),
                      ),),
                      ),


                      Container(
                          margin: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                          child: DropdownButton<String>(
                            value: controller.queuesDropdownValue.value,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? data) {
                              print(data);
                              controller.queuesDropdownValue.value = data??QueuesHelper.getValue(Queue.RANKED_SOLO_5X5);
                            },
                            items: controller.queuesItems.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )),



                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 200.0,
                  child: returnHorizontalChallengerListView(controller)),
                ]
          )
        ))
    );
  }
}
