import 'package:benckmark/_bloc_lib/_shared/entitity.dart';
import 'package:benckmark/_bloc_lib/_shared/item.entity.dart';

import 'items.events.dart';
import 'items.state.dart';

class ItemsBloc extends EntityBloc<EntityEvent, ItemsState> {
  @override
  ItemsState get initialState => ItemsState(sampleItems);

  @override
  Stream<ItemsState> mapEventToState(EntityEvent event) async* {
    if (event is AddItemEvent) {
      final List<Item> items = List.from(state.entities)..add(event.item);

      yield ItemsState(items);
    } else if (event is AddItemsEvent) {
      final List<Item> items = List.from(state.entities)..addAll(event.items);

      yield ItemsState(items);
    } else if (event is RemoveItemsEvent) {
      final List<Item> items = List.from(state.entities);

      items.removeWhere((item) => event.itemIds.contains(item.id));

      yield ItemsState(items);
    }
  }
}
