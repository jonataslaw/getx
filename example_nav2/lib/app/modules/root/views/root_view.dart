import 'package:example_nav2/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/root_controller.dart';
import 'drawer.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, rDelegate, currentRoute) {
        final title = currentRoute?.location;
        return Scaffold(
          drawer: DrawerWidget(),
          appBar: AppBar(
            title: Text(title ?? ''),
            centerTitle: true,
          ),
          body: GetRouterOutlet(
            emptyPage: (delegate) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('<<<< Select something from the drawer on the left'),
                    Builder(
                      builder: (context) => MaterialButton(
                        child: Icon(Icons.open_in_new_outlined),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    )
                  ],
                ),
              );
            },
            pickPages: (currentNavStack) {
              //show all routes here except the root view
              print('Root RouterOutlet: $currentNavStack');
              return currentNavStack.currentTreeBranch.skip(1).take(1).toList();
            },
          ),
        );
      },
    );
  }
}
