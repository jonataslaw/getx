import 'package:benckmark/item.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final List<Item> items;

  AppState({
    this.items,
  });

  AppState.initialState() : items = sampleItems;
}

class AddItemAction {
  Item payload;

  AddItemAction({
    this.payload,
  });
}

AppState appReducer(AppState state, dynamic action) {
  return AppState(items: itemsReducer(state.items, action));
}

List<Item> itemsReducer(List<Item> state, dynamic action) {
  if (action is AddItemAction) {
    return [...state, action.payload];
  }

  return state;
}
