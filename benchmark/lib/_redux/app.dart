import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:benckmark/item.dart';
import 'package:redux/redux.dart';
import '_store.dart';

final store =
    Store<AppState>(appReducer, initialState: AppState.initialState());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Sample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Page(title: 'Redux Sample'),
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
    super.initState();
    fill();
  }

  fill() async {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      store.dispatch(
          AddItemAction(payload: Item(title: DateTime.now().toString())));
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
    return StoreConnector<AppState, List<Item>>(
      converter: (store) => store.state.items,
      builder: (context, items) {
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          itemCount: items.length,
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
