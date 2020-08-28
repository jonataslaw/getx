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

class GetInstance {
  factory GetInstance() => _getInstance ??= GetInstance._();
  const GetInstance._();
  static GetInstance _getInstance;

  /// Holds references to every registered Instance when using
  /// Get.[put]
  static Map<String, _FcBuilder> _singl = {};

  /// Holds a reference to every registered callback when using
  /// Get.[lazyPut]
  static Map<String, _Lazy> _factory = {};

  static Map<String, String> _routesKey = {};

  static GetQueue _queue = GetQueue();

  void lazyPut<S>(FcBuilderFunc builder, {String tag, bool fenix = false}) {
    String key = _getKey(S, tag);
    _factory.putIfAbsent(key, () => _Lazy(builder, fenix));
  }

  Future<S> putAsync<S>(FcBuilderFuncAsync<S> builder,
      {String tag, bool permanent = false}) async {
    return put<S>(await builder(), tag: tag, permanent: permanent);
  }

  /// Injects an instance <[S]> in memory to be globally accessible.
  ///
  /// No need to define the generic type <[S]> as it's inferred from the [dependency]
  ///
  /// - [dependency] The Instance to be injected.
  /// - [tag] optionally, use a [tag] as an "id" to create multiple records of the same Type<[S]>
  /// - [permanent] keeps the Instance in memory, not following [GetConfig.smartManagement]
  ///   rules.
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
  void create<S>(
    FcBuilderFunc<S> builder, {
    String name,
    bool permanent = true,
  }) {
    _insert(
        isSingleton: false, name: name, builder: builder, permanent: permanent);
  }

  /// Injects the Instance [S] builder into the [_singleton] HashMap.
  void _insert<S>({
    bool isSingleton,
    String name,
    bool permanent = false,
    FcBuilderFunc<S> builder,
  }) {
    assert(builder != null);
    final key = _getKey(S, name);
    _singl.putIfAbsent(
        key, () => _FcBuilder<S>(isSingleton, builder, permanent, false));
  }

  /// Clears from memory registered Instances associated with [routeName] when
  /// using [GetConfig.smartManagement] as [SmartManagement.full] or [SmartManagement.keepFactory]
  /// Meant for internal usage of [GetPageRoute] and [GetDialogRoute]
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
  void _registerRouteInstance<S>({String tag}) {
    _routesKey.putIfAbsent(_getKey(S, tag), () => GetConfig.currentRoute);
  }

  /// Finds and returns a Instance<[S]> (or [tag]) without further processing.
  S findByType<S>(Type type, {String tag}) {
    String key = _getKey(type, tag);
    return _singl[key].getDependency() as S;
  }

  /// Initializes the controller
  void _startController<S>({String tag}) {
    final key = _getKey(S, tag);
    final i = _singl[key].getDependency();
    if (i is DisposableInterface) {
      i.onStart();
      GetConfig.log('"$key" has been initialized');
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

  /// Finds the registered type <[S]> (or [tag])
  /// In case of using Get.[create] to register a type <[S]> or [tag], it will create an instance
  /// each time you call [find].
  /// If the registered type <[S]> (or [tag]) is a Controller, it will initialize
  /// it's lifecycle.
  S find<S>({String tag}) {
    String key = _getKey(S, tag);
    if (isRegistered<S>(tag: tag)) {
      _FcBuilder builder = _singl[key] as _FcBuilder;
      if (builder == null) {
        if (tag == null) {
          throw 'Class "$S" is not register';
        } else {
          throw 'Class "$S" with tag "$tag" is not register';
        }
      }
      _initDependencies<S>(name: tag);

      return _singl[key].getDependency() as S;
    } else {
      if (!_factory.containsKey(key))
        throw '"$S" not found. You need to call "Get.put<$S>($S())"';

      // TODO: This message is not clear
      GetConfig.log('"$S" instance was created at that time');

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

  // Future<bool> delete<S>({String tag, String key, bool force = false}) async {
  //   final s = await queue
  //       .add<bool>(() async => dele<S>(tag: tag, key: key, force: force));
  //   return s;
  // }

  /// Delete registered Class Instance [S] (or [tag]) and, closes any open
  /// controllers [DisposableInterface], cleans up the memory
  Future<bool> delete<S>({String tag, String key, bool force = false}) async {
    final newKey = key ?? _getKey(S, tag);

    return _queue.add<bool>(() async {
      if (!_singl.containsKey(newKey)) {
        GetConfig.log('Instance "$newKey" already removed.', isError: true);
        return false;
      }

      _FcBuilder builder = _singl[newKey] as _FcBuilder;
      if (builder.permanent && !force) {
        GetConfig.log(
            '"$newKey" has been marked as permanent, SmartManagement is not authorized to delete it.',
            isError: true);
        return false;
      }
      final i = builder.dependency;

      if (i is GetxService && !force) {
        return false;
      }
      if (i is DisposableInterface) {
        await i.onClose();
        GetConfig.log('"$newKey" onClose() called');
      }

      _singl.removeWhere((oldKey, value) => (oldKey == newKey));
      if (_singl.containsKey(newKey)) {
        GetConfig.log('Error removing object "$newKey"', isError: true);
      } else {
        GetConfig.log('"$newKey" deleted from memory');
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

/// Internal class to register instances with Get.[put]<[S]>().
class _FcBuilder<S> {
  /// Marks the Builder as a single instance.
  /// For reusing [dependency] instead of [builderFunc]
  bool isSingleton;

  /// Stores the actual object instance when [isSingleton]=true.
  S dependency;

  /// Generates (and regenerates) the instance when [isSingleton]=false.
  /// Usually used by factory methods
  FcBuilderFunc<S> builderFunc;

  /// Flag to persist the instance in memory,
  /// without considering [GetConfig.smartManagement]
  bool permanent = false;

  bool isInit = false;

  _FcBuilder(this.isSingleton, this.builderFunc, this.permanent, this.isInit);

  /// Gets the actual instance by it's [builderFunc] or the persisted instance.
  S getDependency() {
    return isSingleton ? dependency ??= builderFunc() : builderFunc();
  }
}

/// Internal class to register a future instance with [lazyPut],
/// keeps a reference to the callback to be called.
class _Lazy {
  bool fenix;
  FcBuilderFunc builder;
  _Lazy(this.builder, this.fenix);
}
