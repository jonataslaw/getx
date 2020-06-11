import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benckmark/_bloc_lib/_blocs/items/items.bloc.dart';
import 'package:benckmark/_bloc_lib/_blocs/items/items.events.dart';
import 'package:benckmark/_bloc_lib/_blocs/items/items.state.dart';
import 'package:benckmark/_bloc_lib/_shared/item.entity.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemsBloc>(
          create: (context) => ItemsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'BLoC Lib Sample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Page(
          title: 'BLoC Lib Sample',
        ),
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
    fill();
    super.initState();
  }

  fill() async {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      BlocProvider.of<ItemsBloc>(context)
          .add(AddItemEvent(Item(title: DateTime.now().toString())));
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
    // ignore: close_sinks
    final _itemsBloc = BlocProvider.of<ItemsBloc>(context);

    return BlocBuilder<ItemsBloc, ItemsState>(
      bloc: _itemsBloc,
      builder: (context, entityState) {
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          itemCount: entityState.entities.length,
          itemBuilder: (context, index) {
            final item = entityState.entities[index];

            return ListTile(
              title: Text(item.title),
            );
          },
        );
      },
    );
  }
}
