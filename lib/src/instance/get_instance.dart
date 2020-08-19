import 'package:get/src/core/log.dart';
import 'package:get/src/navigation/root/smart_management.dart';
import 'package:get/src/state_manager/rx/rx_interface.dart';

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

  /// Inject class on Get Instance Manager
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

  /// Create a new instance from builder class
  /// Example
  /// create(() => Repl());
  /// Repl a = find();
  /// Repl b = find();
  /// print(a==b); (false)
  void create<S>(
    FcBuilderFunc<S> builder, {
    String name,
    bool permanent = true,
  }) {
    _insert(
        isSingleton: false, name: name, builder: builder, permanent: permanent);
  }

  void _insert<S>({
    bool isSingleton,
    String name,
    bool permanent = false,
    FcBuilderFunc<S> builder,
  }) {
    assert(builder != null);
    String key = _getKey(S, name);

    _singl.putIfAbsent(
        key, () => FcBuilder<S>(isSingleton, builder, permanent, false));
  }

  Future<void> removeDependencyByRoute(String routeName) async {
    List<String> keysToRemove = [];
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

  bool initDependencies<S>({String name}) {
    String key = _getKey(S, name);
    bool isInit = _singl[key].isInit;
    if (!isInit) {
      startController<S>(tag: name);
      _singl[key].isInit = true;
      if (GetConfig.smartManagement != SmartManagement.onlyBuilder) {
        registerRouteInstance<S>(tag: name);
      }
    }
    return true;
  }

  void registerRouteInstance<S>({String tag}) {
    _routesKey.putIfAbsent(_getKey(S, tag), () => GetConfig.currentRoute);
  }

  S findByType<S>(Type type, {String tag}) {
    String key = _getKey(type, tag);
    return _singl[key].getDependency() as S;
  }

  void startController<S>({String tag}) {
    String key = _getKey(S, tag);
    final i = _singl[key].getDependency();

    if (i is DisposableInterface) {
      i.onStart();
      GetConfig.log('[GETX] $key has been initialized');
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

  /// Find a instance from required class
  S find<S>({String tag, FcBuilderFunc<S> instance}) {
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
      initDependencies<S>(name: tag);

      return _singl[key].getDependency() as S;
    } else {
      if (!_factory.containsKey(key))
        throw " $S not found. You need call put<$S>($S()) before";

      GetConfig.log('[GETX] $S instance was created at that time');
      S _value = put<S>(_factory[key].builder() as S);

      initDependencies<S>(name: tag);

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

  bool reset({bool clearFactory = true, bool clearRouteBindings = true}) {
    if (clearFactory) _factory.clear();
    if (clearRouteBindings) _routesKey.clear();
    _singl.clear();
    return true;
  }

  /// Delete class instance on [S] and clean memory
  Future<bool> delete<S>({String tag, String key, bool force = false}) async {
    String newKey;
    if (key == null) {
      newKey = _getKey(S, tag);
    } else {
      newKey = key;
    }

    if (!_singl.containsKey(newKey)) {
      GetConfig.log('Instance $newKey not found', isError: true);
      return false;
    }

    FcBuilder builder = _singl[newKey] as FcBuilder;
    if (builder.permanent && !force) {
      GetConfig.log(
          '[GETX] [$newKey] has been marked as permanent, SmartManagement is not authorized to delete it.',
          isError: true);
      return false;
    }
    final i = builder.dependency;

    if (i is GetxService && !force) {
      return false;
    }
    if (i is DisposableInterface) {
      await i.onClose();
      GetConfig.log('[GETX] onClose of $newKey called');
    }

    _singl.removeWhere((oldKey, value) => (oldKey == newKey));
    if (_singl.containsKey(newKey)) {
      GetConfig.log('[GETX] error on remove object $newKey', isError: true);
    } else {
      GetConfig.log('[GETX] $newKey deleted from memory');
    }
    // _routesKey?.remove(key);
    return true;
  }

  /// check if instance is registered
  bool isRegistered<S>({String tag}) => _singl.containsKey(_getKey(S, tag));

  /// check if instance is prepared
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
