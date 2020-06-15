import 'dart:async';

import 'package:benckmark/item.dart';
import 'package:rxdart/rxdart.dart';

class AddItemEvent {
  final Item item;

  AddItemEvent(this.item);
}

class ItemsBloc {
  final StreamController<dynamic> _itemsEventController = StreamController();

  StreamSink<dynamic> get _itemsEventSink => _itemsEventController.sink;

  final BehaviorSubject<List<Item>> _itemsStateSubject =
      BehaviorSubject.seeded(sampleItems);

  StreamSink<List<Item>> get _itemsStateSink => _itemsStateSubject.sink;

  ValueStream<List<Item>> get items => _itemsStateSubject.stream;

  List<StreamSubscription<dynamic>> _subscriptions;

  ItemsBloc() {
    _subscriptions = <StreamSubscription<dynamic>>[
      _itemsEventController.stream.listen(_mapEventToState)
    ];
  }

  dispose() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    _itemsStateSubject.close();
    _itemsEventController.close();
  }

  void addItem(Item item) {
    _itemsEventSink.add(AddItemEvent(item));
  }

  void _mapEventToState(dynamic event) {
    if (event is AddItemEvent) {
      _itemsStateSink.add([...items.value, event.item]);
    }
  }
}
