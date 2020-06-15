import 'package:benckmark/_get_rx/_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetX Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page(title: 'GetX Sample'),
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
        title: Text("GetX"),
      ),
      body: ListViewWidget(),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  final Controller c = Controller();
  @override
  Widget build(BuildContext context) {
    return Obxx(() => ListView.builder(
        padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        itemCount: c.items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(c.items[index].title),
          );
        }));
  }
}
