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

Controller c = Controller();

class Page extends StatefulWidget {
  Page({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  void initState() {
    c.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListViewWidget(),
    );
  }
}

class ListViewWidget extends StatelessWidget {
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
