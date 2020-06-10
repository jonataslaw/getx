import 'package:flutter/foundation.dart';
import 'package:benckmark/item.dart';

class AppState with ChangeNotifier {
  List<Item> _items = sampleItems;

  List<Item> get items => _items;

  void addItem(Item item) {
    _items.add(item);

    notifyListeners();
  }
}
