import 'package:flutter/cupertino.dart';
import 'package:get/src/core/log.dart';
import 'package:get/src/navigation/root/smart_management.dart';
import 'package:get/src/state_manager/rx/rx_interface.dart';
import 'package:get/src/utils/queue/get_queue.dart';

class GetConfig {
  static SmartManagement smartManagement = SmartManagement.full;
  static bool isLogEnable = true;
  static LogWriterCallback log = defaultLogWriterCallback;
  static String currentRoute;
}

class Lazy {
  Lazy(this.builder, this.fenix);
  bool fenix;
  FcBuilderFunc builder;
}

class GetInstance {
  factory GetInstance() {
    if (_getInstance == null) _getInstance = GetInstance._();
    return _getInstance;
  }
  const GetInstance._();
  static GetInstance _getInstance;

  static Map<dynamic, dynamic> _singl = {};
  static Map<dynamic, Lazy> _factory = {};
  static Map<String, String> _routesKey = {};

  void lazyPut<S>(FcBuilderFunc builder, {String tag, bool fenix = false}) {
    String key = _getKey(S, tag);

    _factory.putIfAbsent(key, () => Lazy(builder, fenix));
  }

  Future<S> putAsync<S>(FcBuilderFuncAsync<S> builder,
      {String tag, bool permanent = false}) async {
    return put<S>(await builder(), tag: tag, permanent: permanent);
  }

  /// Injects a Instance [S] in [GetInstance].
  ///
  /// No need to define the generic type <[S]> as it's inferred from the [dependency]
  ///
  /// - [dependency] The Instance to be injected.
  /// - [tag] optionally, use a [tag] as an "id" to create multiple records of the same Type<[S]>
  /// - [permanent] keeps the Instance in memory, not following [GetConfig.smartManagement]
  ///   rules.
  ///
  S put<S>(
    S dependency, {
    String tag,
    bool permanent = false,
    FcBuilderFunc<S> builder,
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
  ///
  /// Example:
  ///
  /// ```create(() => Repl());
  /// Repl a = find();
  /// Repl b = find();
  /// print(a==b); (false)```
  ///
  void create<S>(
    FcBuilderFunc<S> builder, {
    String name,
    bool permanent = true,
  }) {
    _insert(
        isSingleton: false, name: name, builder: builder, permanent: permanent);
  }

  /// Injects the Instance [S] builder into the [_singleton] HashMap.
  ///
  void _insert<S>({
    bool isSingleton,
    String name,
    bool permanent = false,
    FcBuilderFunc<S> builder,
  }) {
    assert(builder != null);
    final key = _getKey(S, name);
    _singl.putIfAbsent(
        key, () => FcBuilder<S>(isSingleton, builder, permanent, false));
  }

  /// Clears from memory registered Instances associated with [routeName] when
  /// using [GetConfig.smartManagement] as [SmartManagement.full] or [SmartManagement.keepFactory]
  /// Meant for internal usage of [GetPageRoute] and [GetDialogRoute]
  ///
  Future<void> removeDependencyByRoute(String routeName) async {
    final keysToRemove = <String>[];
    _routesKey.forEach((key, value) {
      if (value == routeName) {
        keysToRemove.add(key);
      }
    });

    keysToRemove.forEach((element) async {
      await delete(key: element);
    });
    keysToRemove.forEach((element) {
      _routesKey?.remove(element);
    });
    keysToRemove.clear();
  }

  /// Initializes the dependencies for a Class Instance [S] (or tag),
  /// If its a Controller, it starts the lifecycle process.
  /// Optionally associating the current Route to the lifetime of the instance,
  /// if [GetConfig.smartManagement] is marked as [SmartManagement.full] or
  /// [GetConfig.keepFactory]
  ///
  bool _initDependencies<S>({String name}) {
    final key = _getKey(S, name);
    bool isInit = _singl[key].isInit;
    if (!isInit) {
      _startController<S>(tag: name);
      _singl[key].isInit = true;
      if (GetConfig.smartManagement != SmartManagement.onlyBuilder) {
        _registerRouteInstance<S>(tag: name);
      }
    }
    return true;
  }

  /// Links a Class instance [S] (or [tag]) to the current route.
  /// Requires usage of [GetMaterialApp].
  ///
  void _registerRouteInstance<S>({String tag}) {
    _routesKey.putIfAbsent(_getKey(S, tag), () => GetConfig.currentRoute);
  }

  /// Finds and returns a Class instance [S] (or tag) without further processing.
  S findByType<S>(Type type, {String tag}) {
    String key = _getKey(type, tag);
    return _singl[key].getDependency() as S;
  }

  void _startController<S>({String tag}) {
    final key = _getKey(S, tag);
    final i = _singl[key].getDependency();
    if (i is DisposableInterface) {
      i.onStart();
      GetConfig.log('$key has been initialized');
    }
  }

  // S putOrFind<S>(S Function() dep, {String tag}) {
  //   final key = _getKey(S, tag);

  //   if (_singl.containsKey(key)) {
  //     return _singl[key].getDependency() as S;
  //   } else {
  //     if (_factory.containsKey(key)) {
  //       S _value = put<S>((_factory[key].builder() as S), tag: tag);

  //       if (GetConfig.smartManagement != SmartManagement.keepFactory) {
  //         if (!_factory[key].fenix) {
  //           _factory.remove(key);
  //         }
  //       }
  //       return _value;
  //     }

  //     return GetInstance().put(dep(), tag: tag);
  //   }
  // }

  /// Finds a instance of the required Class<[S]> (or [tag])
  /// In the case of using Get.[create], it will create an instance
  /// each time you call [find]
  ///
  S find<S>({String tag}) {
    String key = _getKey(S, tag);

    if (isRegistered<S>(tag: tag)) {
      FcBuilder builder = _singl[key] as FcBuilder;
      if (builder == null) {
        if (tag == null) {
          throw "class ${S.toString()} is not register";
        } else {
          throw "class ${S.toString()} with tag '$tag' is not register";
        }
      }
      _initDependencies<S>(name: tag);

      return _singl[key].getDependency() as S;
    } else {
      if (!_factory.containsKey(key))
        throw "$S not found. You need call put<$S>($S()) before";

      GetConfig.log('$S instance was created at that time');
      S _value = put<S>(_factory[key].builder() as S);

      _initDependencies<S>(name: tag);

      if (GetConfig.smartManagement != SmartManagement.keepFactory &&
          !_factory[key].fenix) {
        _factory.remove(key);
      }

      return _value;
    }
  }

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

  static GetQueue queue = GetQueue();

  // Future<bool> delete<S>({String tag, String key, bool force = false}) async {
  //   final s = await queue
  //       .add<bool>(() async => dele<S>(tag: tag, key: key, force: force));
  //   return s;
  // }

  /// Delete registered Class Instance [S] (or [tag]) and, closes any open
  /// controllers [DisposableInterface], cleans up the memory
  Future<bool> delete<S>({String tag, String key, bool force = false}) async {
    final newKey = key ?? _getKey(S, tag);

    return queue.add<bool>(() async {
      if (!_singl.containsKey(newKey)) {

        GetConfig.log('Instance $newKey already been removed.', isError: true);
        return false;
      }

      FcBuilder builder = _singl[newKey] as FcBuilder;
      if (builder.permanent && !force) {
        GetConfig.log(
            '[$newKey] has been marked as permanent, SmartManagement is not authorized to delete it.',
            isError: true);
        return false;
      }
      final i = builder.dependency;

      if (i is GetxService && !force) {
        return false;
      }
      if (i is DisposableInterface) {
        await i.onClose();
        GetConfig.log('onClose of $newKey called');
      }

      _singl.removeWhere((oldKey, value) => (oldKey == newKey));
      if (_singl.containsKey(newKey)) {
        GetConfig.log('error on remove object $newKey', isError: true);
      } else {
        GetConfig.log('$newKey deleted from memory');
      }
      // _routesKey?.remove(key);
      return true;
    });
  }

  /// Check if a Class instance [S] (or [tag]) is registered.
  bool isRegistered<S>({String tag}) => _singl.containsKey(_getKey(S, tag));

  /// Check if Class instance [S] (or [tag]) is prepared to be used.
  bool isPrepared<S>({String tag}) => _factory.containsKey(_getKey(S, tag));
}

typedef FcBuilderFunc<S> = S Function();

typedef FcBuilderFuncAsync<S> = Future<S> Function();

class FcBuilder<S> {
  bool isSingleton;
  FcBuilderFunc builderFunc;
  S dependency;
  bool permanent = false;
  bool isInit = false;

  FcBuilder(this.isSingleton, this.builderFunc, this.permanent, this.isInit);

  S getDependency() {
    if (isSingleton) {
      if (dependency == null) {
        dependency = builderFunc() as S;
      }
      return dependency;
    } else {
      return builderFunc() as S;
    }
  }
}
