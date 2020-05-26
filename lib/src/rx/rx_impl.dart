import 'dart:async';
import 'package:get/src/get_main.dart';
import 'rx_callbacks.dart';
import 'rx_interface.dart';
import 'rx_model.dart';
import 'utils/delegate_list.dart';

class _StoredValue<T> implements RxInterface<T> {
  StreamController<Change<T>> subject = StreamController<Change<T>>.broadcast();
  StreamController<Change<T>> _changeCtl = StreamController<Change<T>>();
  Map<Stream<Change<T>>, StreamSubscription> _subscriptions = Map();

  T _value;
  T get value {
    if (Get.obs != null) {
      Get.obs.addListener(subject.stream);
    }
    return _value;
  }

  String get string => value.toString();

  close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    _changeCtl.close();
  }

  addListener(Stream<Change<T>> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }

    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  set value(T val) {
    if (_value == val) return;
    T old = _value;
    _value = val;
    subject.add(Change<T>($new: val, $old: old, batch: _cb));
  }

  int _cb = 0;

  _StoredValue([T initial]) : _value = initial {
    _onChange = subject.stream.asBroadcastStream();
  }

  void setCast(dynamic /* T */ val) => value = val;

  Stream<Change<T>> _onChange;

  Stream<Change<T>> get onChange {
    _cb++;

    _changeCtl.add(Change<T>($new: value, $old: null, batch: _cb));
    _changeCtl.addStream(_onChange.skipWhile((v) => v.batch < _cb));
    return _changeCtl.stream.asBroadcastStream();
  }

  Stream<T> get stream => onChange.map((c) => c.$new);

  void bind(RxInterface<T> reactive) {
    value = reactive.value;
    reactive.stream.listen((v) => value = v);
  }

  void bindStream(Stream<T> stream) => stream.listen((v) => value = v);

  void bindOrSet(/* T | Stream<T> | Reactive<T> */ other) {
    if (other is RxInterface<T>) {
      bind(other);
    } else if (other is Stream<T>) {
      bindStream(other.cast<T>());
    } else {
      value = other;
    }
  }

  StreamSubscription<T> listen(ValueCallback<T> callback) =>
      stream.listen(callback);

  Stream<R> map<R>(R mapper(T data)) => stream.map(mapper);
}

class StringX<String> extends _StoredValue<String> {
  StringX([String initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class IntX<int> extends _StoredValue<int> {
  IntX([int initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class MapX<Map> extends _StoredValue<Map> {
  MapX([Map initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

// class ListX<List> extends _StoredValue<List> {
//   ListX([List initial]) {
//     _value = initial;
//     _onChange = subject.stream.asBroadcastStream();
//   }
// }

class ListX<E> extends DelegatingList<E> implements List<E>, RxInterface<E> {
  /// Create a list similar to `List<T>`
  ListX([int length]) : super(length != null ? List<E>(length) : List<E>()) {
    _onChange = subject.stream.asBroadcastStream();
  }

  ListX.filled(int length, E fill, {bool growable: false})
      : super(List<E>.filled(length, fill, growable: growable)) {
    _onChange = subject.stream.asBroadcastStream();
  }

  ListX.from(Iterable<E> items, {bool growable: true})
      : super(List<E>.from(items, growable: growable)) {
    _onChange = subject.stream.asBroadcastStream();
  }

  ListX.union(Iterable<E> items, [E item]) : super(items?.toList() ?? <E>[]) {
    if (item != null) add(item);
    _onChange = subject.stream.asBroadcastStream();
  }

  ListX.of(Iterable<E> items, {bool growable: true})
      : super(List<E>.of(items, growable: growable));

  ListX.generate(int length, E generator(int index), {bool growable: true})
      : super(List<E>.generate(length, generator, growable: growable));

  Map<Stream<Change<E>>, StreamSubscription> _subscriptions = Map();

  // StreamSubscription _changectl = StreamSubscription();

  StreamController<Change<E>> _changeCtl =
      StreamController<Change<E>>.broadcast();

  @override
  StreamController<Change<E>> subject = StreamController<Change<E>>.broadcast();

  /// Adds [item] only if [condition] resolves to true.
  void addIf(condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Adds all [items] only if [condition] resolves to true.
  void addAllIf(condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  operator []=(int index, E value) {
    super[index] = value;
    if (Get.obs != null) {
      Get.obs.addListener(subject.stream);
    }
    subject.add(Change<E>.set(item: value, pos: index));
  }

  void _add(E item) => super.add(item);

  void add(E item) {
    super.add(item);
    subject.add(Change<E>.insert(item: item, pos: length - 1));
  }

  /// Adds only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  void insert(int index, E item) {
    super.insert(index, item);
    subject.add(Change<E>.insert(item: item, pos: index));
  }

  bool remove(Object item) {
    int pos = indexOf(item);
    bool hasRemoved = super.remove(item);
    if (hasRemoved) {
      subject.add(Change<E>.remove(item: item, pos: pos));
    }
    return hasRemoved;
  }

  void clear() {
    super.clear();
    subject.add(Change<E>.clear());
  }

  close() {
    clear();
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    subject.close();
    _changeCtl.close();
  }

  /// Replaces all existing items of this list with [item]
  void assign(E item) {
    clear();
    add(item);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    clear();
    addAll(items);
  }

  /// A stream of record of changes to this list
  Stream<Change<E>> get onChange {
    final now = DateTime.now();

    _onChange.skipWhile((m) => m.time.isBefore(now));
    return _changeCtl.stream.asBroadcastStream();
  }

  Stream<Change<E>> _onChange;

  addListener(Stream<Change<E>> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }
    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  // @override
  // int get length => list.length;

  // List<E> get list => value as List<E>;

  // set list(List<E> v) => assignAll(v);

  @override
  get value {
    if (Get.obs != null) {
      Get.obs.addListener(subject.stream);
    }
    return this;
  }

  set value(E val) {
    assign(val);
  }

  @override
  Stream<E> get stream => onChange.map((c) => c.item);

  @override
  void bind(RxInterface<E> reactive) {
    value = reactive.value;
    reactive.stream.listen((v) => value = v);
  }

  void bindStream(Stream<E> stream) => stream.listen((v) => value = v);

  @override
  void bindOrSet(/* T | Stream<T> or Rx<T> */ other) {
    if (other is RxInterface<E>) {
      bind(other);
    } else if (other is Stream<E>) {
      bindStream(other.cast<E>());
    } else {
      value = other;
    }
  }

  @override
  StreamSubscription<E> listen(ValueCallback<E> callback) =>
      stream.listen(callback);

  @override
  void setCast(dynamic val) => value = val;
}

typedef bool Condition();

typedef E ChildrenListComposer<S, E>(S value);

/// An observable list that is bound to another list [binding]
class BindingList<S, E> extends ListX<E> {
  final ListX<S> binding;

  final ChildrenListComposer<S, E> composer;

  BindingList(this.binding, this.composer) {
    for (S v in binding) _add(composer(v));
    binding.onChange.listen((Change<S> n) {
      if (n.op == ListChangeOp.add) {
        insert(n.pos, composer(n.item));
      } else if (n.op == ListChangeOp.remove) {
        removeAt(n.pos);
      } else if (n.op == ListChangeOp.clear) {
        clear();
      }
    });
  }
}

class BoolX<bool> extends _StoredValue<bool> {
  BoolX([bool initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class DoubleX<double> extends _StoredValue<double> {
  DoubleX([double initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class NumX<num> extends _StoredValue<num> {
  NumX([num initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

class Rx<T> extends _StoredValue<T> {
  Rx([T initial]) {
    _value = initial;
    _onChange = subject.stream.asBroadcastStream();
  }
}

extension StringExtension on String {
  StringX<String> get obs {
    if (this != null)
      return StringX(this);
    else
      return StringX(null);
  }
}

extension IntExtension on int {
  IntX<int> get obs {
    if (this != null)
      return IntX(this);
    else
      return IntX(null);
  }
}

extension DoubleExtension on double {
  DoubleX<double> get obs {
    if (this != null)
      return DoubleX(this);
    else
      return DoubleX(null);
  }
}

extension MapExtension on Map {
  MapX<Map> get obs {
    if (this != null)
      return MapX(this);
    else
      return MapX(null);
  }
}

extension ListExtension<E> on List<E> {
  ListX<E> get obs {
    if (this != null)
      return ListX<E>()..assignAll(this);
    else
      return ListX<E>(null);
  }
}

extension BoolExtension on bool {
  BoolX<bool> get obs {
    if (this != null)
      return BoolX(this);
    else
      return BoolX(null);
  }
}

extension ObjectExtension on Object {
  Rx<Object> get obs {
    if (this != null)
      return Rx(this);
    else
      return Rx(null);
  }
}
