import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:benckmark/item.dart';

import '_bloc.dart';
import '_provider.dart';

class App extends StatelessWidget {
  final ItemsBloc itemsBloc = ItemsBloc();

  @override
  Widget build(BuildContext context) {
    return ItemsBlocProvider(
      bloc: itemsBloc,
      child: MaterialApp(
        title: 'BLoC Sample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Page(title: 'BLoC Sample'),
      ),
    );
  }
}

class Page extends StatefulWidget {
  Page({Key key, this.title}) : super(key: key);

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
        ItemsBlocProvider.of(context)
            .addItem(Item(title: DateTime.now().toString()));
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
    final ItemsBloc itemsBloc = ItemsBlocProvider.of(context);

    return StreamBuilder<List<Item>>(
      stream: itemsBloc.items,
      builder: (context, snapshot) {
        final items = snapshot.data;
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          itemCount: items is List<Item> ? items.length : 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index].title),
            );
          },
        );
      },
    );
  }
}
