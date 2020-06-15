part of 'items_bloc.dart';

abstract class ItemsEvent {}

class AddItemEvent extends ItemsEvent {
  AddItemEvent(this.item);

  final Item item;
}
