import 'dart:async';
import 'dart:collection';

import 'package:get_core/get_core.dart';

import 'lifecircle.dart';

class GetInstance {
  factory GetInstance() => _getInstance ??= GetInstance._();

  const GetInstance._();

  static GetInstance _getInstance;

  // static final config = Get();

  /// Holds references to every registered Instance when using
  /// [Get.put()]
  static final Map<String, _InstanceBuilderFactory> _singl = {};

  /// Holds a reference to every registered callback when using
  /// [Get.lazyPut()]
  static final Map<String, _Lazy> _factory = {};

  /// Holds a reference to [Get.reference] when the Instance was
  /// created to manage the memory.
  static final Map<String, String> _routesKey = {};

  /// Stores the onClose() references of instances created with [Get.create()]
  /// using the [Get.reference].
  /// Experimental feature to keep the lifecycle and memory management with
  /// non-singleton instances.
  static final Map<String, HashSet<Function>> _routesByCreate = {};

  /// Creates a new Instance<S> lazily from the [<S>builder()] callback.
  ///
  /// The first time you call [Get.find()], the [builder()] callback will create
  /// the Instance and persisted as a Singleton (like you would
  /// use [Get.put()]).
  ///
  /// Using [Get.smartManagement] as [SmartManagement.keepFactory] has
  /// the same outcome as using [fenix:true] :
  /// The internal register of [builder()] will remain in memory to recreate
  /// the Instance if the Instance has been removed with [Get.delete()].
  /// Therefore, future calls to [Get.find()] will return the same Instance.
  ///
  /// If you need to make use of GetxController's life-cycle
  /// ([onInit(), onStart(), onClose()]) [fenix] is a great choice to mix with
  /// [GetBuilder()] and [GetX()] widgets, and/or [GetMaterialApp] Navigation.
  ///
  /// You could use [Get.lazyPut(fenix:true)] in your app's [main()] instead
  /// of [Bindings()] for each [GetPage].
  /// And the memory management will be similar.
  ///
  /// Subsequent calls to [Get.lazyPut()] with the same parameters
  /// (<[S]> and optionally [tag] will **not** override the original).
  void lazyPut<S>(
    InstanceBuilderCallback<S> builder, {
    String tag,
    bool fenix = false,
  }) {
    final key = _getKey(S, tag);
    _factory.putIfAbsent(key, () => _Lazy(builder, fenix));
  }

  /// async version of [Get.put()].
  /// Awaits for the resolution of the Future from [builder()] parameter and
  /// stores the Instance returned.
  Future<S> putAsync<S>(
    AsyncInstanceBuilderCallback<S> builder, {
    String tag,
    bool permanent = false,
  }) async {
    return put<S>(await builder(), tag: tag, permanent: permanent);
  }

  /// Injects an instance <[S]> in memory to be globally accessible.
  ///
  /// No need to define the generic type <[S]> as it's inferred from
  /// the [dependency]
  ///
  /// - [dependency] The Instance to be injected.
  /// - [tag] optionally, use a [tag] as an "id" to create multiple records of
  /// the same Type<[S]>
  /// - [permanent] keeps the Instance in memory, not following
  /// [Get.smartManagement] rules.
  S put<S>(
    S dependency, {
    String tag,
    bool permanent = false,
    InstanceBuilderCallback<S> builder,
  }) {
    _insert(
        isSingleton: true,
        name: tag,
        permanent: permanent,
        builder: builder ?? (() => dependency));
    return find<S>(tag: tag);
  }

  /// Creates a new Class Instance [S] from the builder callback[S].
  /// Every time [find]<[S]>() is used, it calls the builder method to generate
  /// a new Instance [S].
  /// It also registers each [instance.onClose()] with the current
  /// Route [Get.reference] to keep the lifecycle active.
  /// Is important to know that the instances created are only stored per Route.
  /// So, if you call `Get.delete<T>()` the "instance factory" used in this
  /// method ([Get.create<T>()]) will be removed, but NOT the instances
  /// already created by it.
  ///
  /// Example:
  ///
  /// ```create(() => Repl());
  /// Repl a = find();
  /// Repl b = find();
  /// print(a==b); (false)```
  void create<S>(
    InstanceBuilderCallback<S> builder, {
    String tag,
    bool permanent = true,
  }) {
    _insert(
        isSingleton: false, name: tag, builder: builder, permanent: permanent);
  }

  /// Injects the Instance [S] builder into the [_singleton] HashMap.
  void _insert<S>({
    bool isSingleton,
    String name,
    bool permanent = false,
    InstanceBuilderCallback<S> builder,
  }) {
    assert(builder != null);
    final key = _getKey(S, name);
    _singl.putIfAbsent(
        key,
        () =>
            _InstanceBuilderFactory<S>(isSingleton, builder, permanent, false));
  }

  /// Clears from memory registered Instances associated with [routeName] when
  /// using [Get.smartManagement] as [SmartManagement.full] or
  /// [SmartManagement.keepFactory]
  /// Meant for internal usage of [GetPageRoute] and [GetDialogRoute]
  Future<void> removeDependencyByRoute(String routeName) async {
    final keysToRemove = <String>[];
    _routesKey.forEach((key, value) {
      if (value == routeName) {
        keysToRemove.add(key);
      }
    });

    /// Removes [Get.create()] instances registered in [routeName].
    if (_routesByCreate.containsKey(routeName)) {
      for (final onClose in _routesByCreate[routeName]) {
        // assure the [DisposableInterface] instance holding a reference
        // to [onClose()] wasn't disposed.
        if (onClose != null) {
          await onClose();
        }
      }
      _routesByCreate[routeName].clear();
      _routesByCreate.remove(routeName);
    }

    for (final element in keysToRemove) {
      await delete(key: element);
    }

    for (final element in keysToRemove) {
      _routesKey?.remove(element);
    }
    keysToRemove.clear();
  }

  /// Initializes the dependencies for a Class Instance [S] (or tag),
  /// If its a Controller, it starts the lifecycle process.
  /// Optionally associating the current Route to the lifetime of the instance,
  /// if [Get.smartManagement] is marked as [SmartManagement.full] or
  /// [Get.keepFactory]
  /// Only flags `isInit` if it's using `Get.create()`
  /// (not for Singletons access).
  /// Returns the instance if not initialized, required for Get.create() to
  /// work properly.
  S _initDependencies<S>({String name}) {
    final key = _getKey(S, name);
    final isInit = _singl[key].isInit;
    S i;
    if (!isInit) {
      i = _startController<S>(tag: name);
      if (_singl[key].isSingleton) {
        _singl[key].isInit = true;
        if (Get.smartManagement != SmartManagement.onlyBuilder) {
          _registerRouteInstance<S>(tag: name);
        }
      }
    }
    return i;
  }

  /// Links a Class instance [S] (or [tag]) to the current route.
  /// Requires usage of [GetMaterialApp].
  void _registerRouteInstance<S>({String tag}) {
    _routesKey.putIfAbsent(_getKey(S, tag), () => Get.reference);
  }

  /// Finds and returns a Instance<[S]> (or [tag]) without further processing.
  S findByType<S>(Type type, {String tag}) {
    final key = _getKey(type, tag);
    return _singl[key].getDependency() as S;
  }

  /// Initializes the controller
  S _startController<S>({String tag}) {
    final key = _getKey(S, tag);
    final i = _singl[key].getDependency() as S;
    if (i is GetLifeCycle) {
      if (i.onStart != null) {
        i.onStart();
        Get.log('"$key" has been initialized');
      }
      if (!_singl[key].isSingleton && i.onClose != null) {
        _routesByCreate[Get.reference] ??= HashSet<Function>();
        _routesByCreate[Get.reference].add(i.onClose);
      }
    }
    return i;
  }

  // S putOrFind<S>(S Function() dep, {String tag}) {
  //   final key = _getKey(S, tag);

  //   if (_singl.containsKey(key)) {
  //     return _singl[key].getDependency() as S;
  //   } else {
  //     if (_factory.containsKey(key)) {
  //       S _value = put<S>((_factory[key].builder() as S), tag: tag);

  //       if (Get.smartManagement != SmartManagement.keepFactory) {
  //         if (!_factory[key].fenix) {
  //           _factory.remove(key);
  //         }
  //       }
  //       return _value;
  //     }

  //     return GetInstance().put(dep(), tag: tag);
  //   }
  // }

  /// Finds the registered type <[S]> (or [tag])
  /// In case of using Get.[create] to register a type <[S]> or [tag],
  /// it will create an instance each time you call [find].
  /// If the registered type <[S]> (or [tag]) is a Controller,
  /// it will initialize it's lifecycle.
  S find<S>({String tag}) {
    final key = _getKey(S, tag);
    if (isRegistered<S>(tag: tag)) {
      if (_singl[key] == null) {
        if (tag == null) {
          throw 'Class "$S" is not register';
        } else {
          throw 'Class "$S" with tag "$tag" is not register';
        }
      }

      /// although dirty solution, the lifecycle starts inside
      /// `initDependencies`, so we have to return the instance from there
      /// to make it compatible with `Get.create()`.
      final i = _initDependencies<S>(name: tag);
      return i ?? _singl[key].getDependency() as S;
    } else {
      if (!_factory.containsKey(key)) {
        // ignore: lines_longer_than_80_chars
        throw '"$S" not found. You need to call "Get.put($S())" or "Get.lazyPut(()=>$S())"';
      }

      Get.log('Lazy instance "$S" created');
      final _value = put<S>(_factory[key].builder() as S, tag: tag);
      _initDependencies<S>(name: tag);

      if (Get.smartManagement != SmartManagement.keepFactory &&
          !_factory[key].fenix) {
        _factory.remove(key);
      }

      return _value;
    }
  }

  /// Generates the key based on [type] (and optionally a [name])
  /// to register an Instance Builder in the hashmap.
  String _getKey(Type type, String name) {
    return name == null ? type.toString() : type.toString() + name;
  }

  /// Clears all registered instances (and/or tags).
  /// Even the persistent ones.
  ///
  /// [clearFactory] clears the callbacks registered by [lazyPut]
  /// [clearRouteBindings] clears Instances associated with routes.
  ///
  bool reset({bool clearFactory = true, bool clearRouteBindings = true}) {
    if (clearFactory) _factory.clear();
    if (clearRouteBindings) _routesKey.clear();
    _singl.clear();
    return true;
  }

//  Future<bool> delete<S>({
//    String tag,
//    String key,
//    bool force = false,
//  }) async {
//    final s = await queue
//        .add<bool>(() async => dele<S>(tag: tag, key: key, force: force));
//    return s;
//  }

  /// Delete registered Class Instance [S] (or [tag]) and, closes any open
  /// controllers [DisposableInterface], cleans up the memory
  ///
  /// /// Deletes the Instance<[S]>, cleaning the memory.
  //  ///
  //  /// - [tag] Optional "tag" used to register the Instance
  //  /// - [key] For internal usage, is the processed key used to register
  //  ///   the Instance. **don't use** it unless you know what you are doing.

  /// Deletes the Instance<[S]>, cleaning the memory and closes any open
  /// controllers ([DisposableInterface]).
  ///
  /// - [tag] Optional "tag" used to register the Instance
  /// - [key] For internal usage, is the processed key used to register
  ///   the Instance. **don't use** it unless you know what you are doing.
  /// - [force] Will delete an Instance even if marked as [permanent].
  Future<bool> delete<S>({String tag, String key, bool force = false}) async {
    final newKey = key ?? _getKey(S, tag);

    if (!_singl.containsKey(newKey)) {
      Get.log('Instance "$newKey" already removed.', isError: true);
      return false;
    }

    final builder = _singl[newKey];
    if (builder.permanent && !force) {
      Get.log(
        // ignore: lines_longer_than_80_chars
        '"$newKey" has been marked as permanent, SmartManagement is not authorized to delete it.',
        isError: true,
      );
      return false;
    }
    final i = builder.dependency;

    if (i is GetxServiceMixin && !force) {
      return false;
    }
    if (i is GetLifeCycle) {
      await i.onClose();
      Get.log('"$newKey" onClose() called');
    }

    _singl.removeWhere((oldKey, value) => (oldKey == newKey));
    if (_singl.containsKey(newKey)) {
      Get.log('Error removing object "$newKey"', isError: true);
    } else {
      Get.log('"$newKey" deleted from memory');
    }
    // _routesKey?.remove(key);
    return true;
  }

  /// Check if a Class Instance<[S]> (or [tag]) is registered in memory.
  /// - [tag] is optional, if you used a [tag] to register the Instance.
  bool isRegistered<S>({String tag}) => _singl.containsKey(_getKey(S, tag));

  /// Checks if a lazy factory callback ([Get.lazyPut()] that returns an
  /// Instance<[S]> is registered in memory.
  /// - [tag] is optional, if you used a [tag] to register the lazy Instance.
  bool isPrepared<S>({String tag}) => _factory.containsKey(_getKey(S, tag));
}

typedef InstanceBuilderCallback<S> = S Function();

typedef AsyncInstanceBuilderCallback<S> = Future<S> Function();

/// Internal class to register instances with Get.[put]<[S]>().
class _InstanceBuilderFactory<S> {
  /// Marks the Builder as a single instance.
  /// For reusing [dependency] instead of [builderFunc]
  bool isSingleton;

  /// Stores the actual object instance when [isSingleton]=true.
  S dependency;

  /// Generates (and regenerates) the instance when [isSingleton]=false.
  /// Usually used by factory methods
  InstanceBuilderCallback<S> builderFunc;

  /// Flag to persist the instance in memory,
  /// without considering [Get.smartManagement]
  bool permanent = false;

  bool isInit = false;

  _InstanceBuilderFactory(
    this.isSingleton,
    this.builderFunc,
    this.permanent,
    this.isInit,
  );

  /// Gets the actual instance by it's [builderFunc] or the persisted instance.
  S getDependency() {
    return isSingleton ? dependency ??= builderFunc() : builderFunc();
  }
}

/// Internal class to register a future instance with [lazyPut],
/// keeps a reference to the callback to be called.
class _Lazy {
  bool fenix;
  InstanceBuilderCallback builder;

  _Lazy(this.builder, this.fenix);
}
