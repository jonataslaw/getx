import 'package:benckmark/item.dart';
import 'package:mobx/mobx.dart';

part '_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  ObservableList<Item> items = ObservableList<Item>.of(sampleItems);

  @observable
  ObservableSet<String> checkedItemIds = ObservableSet<String>();

  @action
  void addItem(Item item) {
    items.add(item);
  }
}
