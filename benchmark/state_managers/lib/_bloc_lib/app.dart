import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benckmark/item.dart';
import 'package:benckmark/_bloc_lib/_blocs/items/items_bloc.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Lib Sample',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => ItemsBloc(),
        child: Page(title: 'BLoC Lib Sample'),
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<ItemsBloc, List<Item>>(
        builder: (context, items) {
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(items[index].title));
            },
          );
        },
      ),
    );
  }
}
