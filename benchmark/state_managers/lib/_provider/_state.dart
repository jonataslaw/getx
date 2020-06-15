import 'package:flutter/foundation.dart';
import 'package:benckmark/item.dart';
import 'package:flutter/scheduler.dart';

class AppState with ChangeNotifier {
  AppState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      for (int i = 0; i < 10; i++) {
        await Future.delayed(Duration(milliseconds: 500));
        addItem(Item(title: DateTime.now().toString()));
      }
      print("It's done. Print now!");
    });
  }

  List<Item> _items = sampleItems;

  List<Item> get items => _items;

  void addItem(Item item) {
    _items.add(item);

    notifyListeners();
  }
}
