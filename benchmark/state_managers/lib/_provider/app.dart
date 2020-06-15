import 'package:flutter/material.dart';
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
    final state = context.watch<AppState>();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(state.items[index].title),
        );
      },
    );
  }
}
