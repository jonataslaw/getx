import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:benckmark/item.dart';

part 'items_event.dart';

class ItemsBloc extends Bloc<ItemsEvent, List<Item>> {
  ItemsBloc() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      add(AddItemEvent(Item(title: DateTime.now().toString())));
      if (state.length == 10) {
        timer.cancel();
        print("It's done. Print now!");
      }
    });
  }

  @override
  List<Item> get initialState => sampleItems;

  @override
  Stream<List<Item>> mapEventToState(ItemsEvent event) async* {
    if (event is AddItemEvent) {
      yield List.from(state)..add(event.item);
    }
  }
}
