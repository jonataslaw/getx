import 'dart:async';
import 'dart:collection';
import 'rx_interface.dart';

RxInterface getObs;

class _RxImpl<T> implements RxInterface<T> {
  StreamController<T> subject = StreamController<T>.broadcast();
  HashMap<Stream<T>, StreamSubscription> _subscriptions =
      HashMap<Stream<T>, StreamSubscription>();

  T _value;

  /// Common to all Types [T], this operator overloading is using for
  /// assignment, same as rx.value
  ///
  /// Example:
  /// ```
  /// var counter = 0.obs ;
  /// counter >>= 3; // same as counter.value=3;
  /// print(counter); // calls .toString() now
  /// ```
  ///
  /// WARNING: still WIP, needs testing!
  _RxImpl<T> operator >>(T val) {
    subject.add(value = val);
    return this;
  }

  bool get canUpdate => _subscriptions.isNotEmpty;

  /// Makes this Rx looks like a function so you can update a new
  /// value using [rx(someOtherValue)]. Practical to assign the Rx directly
  /// to some Widget that has a signature ::onChange( value )
  ///
  /// Example:
  /// ```
  /// final myText = 'GetX rocks!'.obs;
  ///
  /// // in your Constructor, just to check it works :P
  /// ever( myText, print ) ;
  ///
  /// // in your build(BuildContext) {
  /// TextField(
  //    onChanged: myText,
  //  ),
  ///```
  T call([T v]) {
    if (v != null) this.value = v;
    return this.value;
  }

  /// Makes a direct update of [value] adding it to the Stream
  /// useful when you make use of Rx for custom Types to referesh your UI.
  ///
  /// Sample:
  /// ```
  ///  class Person {
  ///     String name, last;
  ///     int age;
  ///     Person({this.name, this.last, this.age});
  ///     @override
  ///     String toString() => '$name $last, $age years old';
  ///  }
  ///
  /// final person = Person(name: 'John', last: 'Doe', age: 18).obs;
  /// person.value.name = 'Roi';
  /// person.refresh();
  /// print( person );
  /// ```
  void refresh() {
    subject.add(value);
  }

  /// Uses a callback to update [value] internally, similar to [refresh], but provides
  /// the current value as the argument.
  /// Makes sense for custom Rx types (like Models).
  ///
  /// Sample:
  /// ```
  ///  class Person {
  ///     String name, last;
  ///     int age;
  ///     Person({this.name, this.last, this.age});
  ///     @override
  ///     String toString() => '$name $last, $age years old';
  ///  }
  ///
  /// final person = Person(name: 'John', last: 'Doe', age: 18).obs;
  /// person.update((person) {
  ///   person.name = 'Roi';
  /// });
  /// print( person );
  /// ```
  void update(void fn(T value)) {
    fn(value);
    subject.add(value);
  }

  String get string => value.toString();

  @override
  String toString() => value.toString();

  /// This equality override works for _RxImpl instances and the internal values.
  @override
  bool operator ==(dynamic o) {
    // Todo, find a common implementation for the hashCode of different Types.
    if (o is T) return _value == o;
    if (o is RxInterface<T>) return _value == o.value;
    return false;
  }

  @override
  int get hashCode => _value.hashCode;

  void close() {
    _subscriptions.forEach((observable, subscription) => subscription.cancel());
    _subscriptions.clear();
    subject.close();
  }

  void addListener(Stream<T> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }
    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  bool firstRebuild = true;

  set value(T val) {
    if (_value == val && !firstRebuild) return;
    firstRebuild = false;
    _value = val;
    subject.add(_value);
  }

  T get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _value;
  }

  Stream<T> get stream => subject.stream;

  StreamSubscription<T> listen(void Function(T) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<T> stream) => stream.listen((va) => value = va);

  Stream<R> map<R>(R mapper(T data)) => stream.map(mapper);
}

class RxBool extends _RxImpl<bool> {
  RxBool([bool initial]) {
    _value = initial;
  }
}

class RxDouble extends _RxImpl<double> {
  RxDouble([double initial]) {
    _value = initial;
  }

  RxDouble operator +(double val) {
    subject.add(value += val);
    return this;
  }

  RxDouble operator -(double val) {
    subject.add(value -= val);
    return this;
  }

  RxDouble operator /(double val) {
    subject.add(value /= val);
    return this;
  }

  RxDouble operator *(double val) {
    subject.add(value *= val);
    return this;
  }
}

class RxNum extends _RxImpl<num> {
  RxNum([num initial]) {
    _value = initial;
  }

  RxNum operator >>(num val) {
    subject.add(value = val);
    return this;
  }

  RxNum operator +(num val) {
    subject.add(value += val);
    return this;
  }

  RxNum operator -(num val) {
    subject.add(value -= val);
    return this;
  }

  RxNum operator /(num val) {
    subject.add(value /= val);
    return this;
  }

  RxNum operator *(num val) {
    subject.add(value *= val);
    return this;
  }
}

class RxString extends _RxImpl<String> {
  RxString([String initial]) {
    _value = initial;
  }

  RxString operator >>(String val) {
    subject.add(value = val);
    return this;
  }

  RxString operator +(String val) {
    subject.add(value += val);
    return this;
  }

  RxString operator *(int val) {
    subject.add(value *= val);
    return this;
  }
}

class RxInt extends _RxImpl<int> {
  RxInt([int initial]) {
    _value = initial;
  }

  RxInt operator >>(int val) {
    subject.add(value = val);
    return this;
  }

  RxInt operator +(int val) {
    subject.add(value += val);
    return this;
  }

  RxInt operator -(int val) {
    subject.add(value -= val);
    return this;
  }

  RxInt operator /(int val) {
    subject.add(value ~/= val);
    return this;
  }

  RxInt operator *(int val) {
    subject.add(value *= val);
    return this;
  }
}

class Rx<T> extends _RxImpl<T> {
  Rx([T initial]) {
    _value = initial;
  }
}

extension StringExtension on String {
  RxString get obs => RxString(this);
}

extension IntExtension on int {
  RxInt get obs => RxInt(this);
}

extension DoubleExtension on double {
  RxDouble get obs => RxDouble(this);
}

extension BoolExtension on bool {
  RxBool get obs => RxBool(this);
}

extension RxT<T> on T {
  Rx<T> get obs => Rx<T>(this);
}
