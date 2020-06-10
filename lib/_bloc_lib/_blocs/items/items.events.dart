import 'package:benckmark/_bloc_lib/_shared/entitity.dart';
import 'package:benckmark/_bloc_lib/_shared/item.entity.dart';

class AddItemEvent extends EntityEvent<Item> {
  final Item item;

  AddItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class AddItemsEvent extends EntityEvent<Item> {
  final List<Item> items;

  AddItemsEvent(this.items);

  @override
  List<Object> get props => [items];
}

class RemoveItemsEvent extends EntityEvent<Item> {
  final List<String> itemIds;

  RemoveItemsEvent(this.itemIds);

  @override
  List<Object> get props => [itemIds];
}
