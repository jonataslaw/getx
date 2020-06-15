import 'package:flutter/material.dart';
import 'package:benckmark/_get/_store.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page(title: 'Get Sample'),
    );
  }
}

class Page extends StatelessWidget {
  Page({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListViewWidget(),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        init: Controller(),
        global: false,
        builder: (_) => ListView.builder(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            itemCount: _.items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_.items[index].title),
              );
            }));
  }
}
