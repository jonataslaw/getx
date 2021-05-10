part of rx_types;

/// global object that registers against `GetX` and `Obx`, and allows the
/// reactivity
/// of those `Widgets` and Rx values.

mixin RxObjectMixin<T> on NotifyManager<T> {
  late T _value;

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

  /// updates the value to [null] and adds it to the Stream.
  /// Even with null-safety coming, is still an important feature to support, as
  /// [call()] doesn't accept [null] values. For instance,
  /// [InputDecoration.errorText] has to be null to not show the "error state".
  ///
  /// Sample:
  /// ```
  /// final inputError = ''.obs..nil();
  /// print('${inputError.runtimeType}: $inputError'); // outputs > RxString: null
  /// ```
  // void nil() {
  //   subject.add(_value = null);
  // }

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
  ///   onChanged: myText,
  /// ),
  ///```
  T call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  bool firstRebuild = true;

  /// Same as `toString()` but using a getter.
  String get string => value.toString();

  @override
  String toString() => value.toString();

  /// Returns the json representation of `value`.
  dynamic toJson() => value;

  /// This equality override works for _RxImpl instances and the internal
  /// values.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object o) {
    // Todo, find a common implementation for the hashCode of different Types.
    if (o is T) return value == o;
    if (o is RxObjectMixin<T>) return value == o.value;
    return false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;

  /// Updates the [value] and adds it to the stream, updating the observer
  /// Widget, only if it's different from the previous value.
  set value(T val) {
    if (subject.isClosed) return;
    if (_value == val && !firstRebuild) return;
    firstRebuild = false;
    _value = val;

    subject.add(_value);
  }

  /// Returns the current [value]
  T get value {
    if (RxInterface.proxy != null) {
      RxInterface.proxy!.addListener(subject);
    }
    return _value;
  }

  Stream<T?> get stream => subject.stream;

  /// Binds an existing [Stream<T>] to this Rx<T> to keep the values in sync.
  /// You can bind multiple sources to update the value.
  /// Closing the subscription will happen automatically when the observer
  /// Widget ([GetX] or [Obx]) gets unmounted from the Widget tree.
  void bindStream(Stream<T> stream) {
    final listSubscriptions =
        _subscriptions[subject] ??= <StreamSubscription>[];
    listSubscriptions.add(stream.listen((va) => value = va));
  }
}

class RxNotifier<T> = RxInterface<T> with NotifyManager<T>;

mixin NotifyManager<T> {
  GetStream<T> subject = GetStream<T>();
  final _subscriptions = <GetStream, List<StreamSubscription>>{};

  bool get canUpdate => _subscriptions.isNotEmpty;

  /// This is an internal method.
  /// Subscribe to changes on the inner stream.
  void addListener(GetStream<T> rxGetx) {
    if (!_subscriptions.containsKey(rxGetx)) {
      final subs = rxGetx.listen((data) {
        if (!subject.isClosed) subject.add(data);
      });
      final listSubscriptions =
          _subscriptions[rxGetx] ??= <StreamSubscription>[];
      listSubscriptions.add(subs);
    }
  }

  StreamSubscription<T> listen(
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      subject.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError ?? false,
      );

  /// Closes the subscriptions for this Rx, releasing the resources.
  void close() {
    _subscriptions.forEach((getStream, _subscriptions) {
      for (final subscription in _subscriptions) {
        subscription.cancel();
      }
    });

    _subscriptions.clear();
    subject.close();
  }
}

/// Base Rx class that manages all the stream logic for any Type.
abstract class _RxImpl<T> extends RxNotifier<T> with RxObjectMixin<T> {
  _RxImpl(T initial) {
    _value = initial;
  }

  void addError(Object error, [StackTrace? stackTrace]) {
    subject.addError(error, stackTrace);
  }

  Stream<R> map<R>(R mapper(T? data)) => stream.map(mapper);

  /// Uses a callback to update [value] internally, similar to [refresh],
  /// but provides the current value as the argument.
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
  void update(void fn(T? val)) {
    fn(_value);
    subject.add(_value);
  }

  /// Following certain practices on Rx data, we might want to react to certain
  /// listeners when a value has been provided, even if the value is the same.
  /// At the moment, we ignore part of the process if we `.call(value)` with
  /// the same value since it holds the value and there's no real
  /// need triggering the entire process for the same value inside, but
  /// there are other situations where we might be interested in
  /// triggering this.
  ///
  /// For example, supposed we have a `int seconds = 2` and we want to animate
  /// from invisible to visible a widget in two seconds:
  /// RxEvent<int>.call(seconds);
  /// then after a click happens, you want to call a RxEvent<int>.call(seconds).
  /// By doing `call(seconds)`, if the value being held is the same,
  /// the listeners won't trigger, hence we need this new `trigger` function.
  /// This will refresh the listener of an AnimatedWidget and will keep
  /// the value if the Rx is kept in memory.
  /// Sample:
  /// ```
  /// Rx<Int> secondsRx = RxInt();
  /// secondsRx.listen((value) => print("$value seconds set"));
  ///
  /// secondsRx.call(2);      // This won't trigger any listener, since the value is the same
  /// secondsRx.trigger(2);   // This will trigger the listener independently from the value.
  /// ```
  ///
  void trigger(T v) {
    var firstRebuild = this.firstRebuild;
    value = v;
    // If it's not the first rebuild, the listeners have been called already
    // So we won't call them again.
    if (!firstRebuild) {
      subject.add(v);
    }
  }
}

class RxBool extends Rx<bool> {
  RxBool(bool initial) : super(initial);
  @override
  String toString() {
    return value ? "true" : "false";
  }
}

class RxnBool extends Rx<bool?> {
  RxnBool([bool? initial]) : super(initial);
  @override
  String toString() {
    return "$value";
  }
}

extension RxBoolExt on Rx<bool> {
  bool get isTrue => value;

  bool get isFalse => !isTrue;

  bool operator &(bool other) => other && value;

  bool operator |(bool other) => other || value;

  bool operator ^(bool other) => !other == value;

  /// Toggles the bool [value] between false and true.
  /// A shortcut for `flag.value = !flag.value;`
  /// FIXME: why return this? fluent interface is not
  ///  not really a dart thing since we have '..' operator
  // ignore: avoid_returning_this
  Rx<bool> toggle() {
    subject.add(_value = !_value);
    return this;
  }
}

extension RxnBoolExt on Rx<bool?> {
  bool? get isTrue => value;

  bool? get isFalse {
    if (value != null) return !isTrue!;
  }

  bool? operator &(bool other) {
    if (value != null) {
      return other && value!;
    }
  }

  bool? operator |(bool other) {
    if (value != null) {
      return other || value!;
    }
  }

  bool? operator ^(bool other) => !other == value;

  /// Toggles the bool [value] between false and true.
  /// A shortcut for `flag.value = !flag.value;`
  /// FIXME: why return this? fluent interface is not
  ///  not really a dart thing since we have '..' operator
  // ignore: avoid_returning_this
  Rx<bool?>? toggle() {
    if (_value != null) {
      subject.add(_value = !_value!);
      return this;
    }
  }
}

/// Foundation class used for custom `Types` outside the common native Dart
/// types.
/// For example, any custom "Model" class, like User().obs will use `Rx` as
/// wrapper.
class Rx<T> extends _RxImpl<T> {
  Rx(T initial) : super(initial);

  @override
  dynamic toJson() {
    try {
      return (value as dynamic)?.toJson();
    } on Exception catch (_) {
      throw '$T has not method [toJson]';
    }
  }
}

class Rxn<T> extends Rx<T?> {
  Rxn([T? initial]) : super(initial);

  @override
  dynamic toJson() {
    try {
      return (value as dynamic)?.toJson();
    } on Exception catch (_) {
      throw '$T has not method [toJson]';
    }
  }
}

extension StringExtension on String {
  /// Returns a `RxString` with [this] `String` as initial value.
  RxString get obs => RxString(this);
}

extension IntExtension on int {
  /// Returns a `RxInt` with [this] `int` as initial value.
  RxInt get obs => RxInt(this);
}

extension DoubleExtension on double {
  /// Returns a `RxDouble` with [this] `double` as initial value.
  RxDouble get obs => RxDouble(this);
}

extension BoolExtension on bool {
  /// Returns a `RxBool` with [this] `bool` as initial value.
  RxBool get obs => RxBool(this);
}

extension RxT<T> on T {
  /// Returns a `Rx` instace with [this] `T` as initial value.
  Rx<T> get obs => Rx<T>(this);
}
