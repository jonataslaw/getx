import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:benckmark/item.dart';
import 'package:provider/provider.dart';

import '_state.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Provider Sample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Page(title: 'Provider Sample'),
      ),
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      for (int i = 0; i < 10; i++) {
        await Future.delayed(Duration(milliseconds: 500));
        final state = Provider.of<AppState>(context, listen: false);
        state.addItem(Item(title: DateTime.now().toString()));
      }
      print("It's done. Print now!");
    });
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
    return Consumer<AppState>(
      builder: (context, state, child) {
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(state.items[index].title),
            );
          },
        );
      },
    );
  }
}
