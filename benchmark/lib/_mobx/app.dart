import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:benckmark/_mobx/_store.dart';
import 'package:benckmark/item.dart';

final store = AppStore();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page(title: 'MobX Sample'),
    );
  }
}

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
    fill();
    super.initState();
  }

  fill() async {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      store.addItem(Item(title: DateTime.now().toString()));
    }
    print("It's done. Print now!");
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
    return Observer(
      builder: (_) {
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          itemCount: store.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(store.items[index].title),
            );
          },
        );
      },
    );
  }
}
