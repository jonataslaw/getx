import 'package:get/src/root/smart_management.dart';
import 'package:get/src/rx/rx_interface.dart';
import 'package:get/src/typedefs/typedefs.dart';

class GetConfig {
  //////////// INSTANCE MANAGER
  static Map<dynamic, dynamic> _singl = {};
  static Map<dynamic, Lazy> _factory = {};
  static Map<String, String> routesKey = {};
  static SmartManagement smartManagement = SmartManagement.full;
  static bool isLogEnable = true;
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
  GetInstance._();
  static GetInstance _getInstance;

  void lazyPut<S>(FcBuilderFunc builder, {String tag, bool fenix = false}) {
    String key = _getKey(S, tag);

    GetConfig._factory.putIfAbsent(key, () => Lazy(builder, fenix));
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
    bool overrideAbstract = false,
    FcBuilderFunc<S> builder,
  }) {
    _insert(
        isSingleton: true,
        replace: overrideAbstract,
        //?? (("$S" == "${dependency.runtimeType}") == false),
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
  }) {
    _insert(isSingleton: false, name: name, builder: builder);
  }

  void _insert<S>({
    bool isSingleton,
    String name,
    bool replace = true,
    bool permanent = false,
    FcBuilderFunc<S> builder,
  }) {
    assert(builder != null);
    String key = _getKey(S, name);
    if (replace) {
      GetConfig._singl[key] = FcBuilder<S>(isSingleton, builder, permanent);
    } else {
      GetConfig._singl.putIfAbsent(
          key, () => FcBuilder<S>(isSingleton, builder, permanent));
    }
  }

  void removeDependencyByRoute(String routeName) async {
    List<String> keysToRemove = [];
    GetConfig.routesKey.forEach((key, value) {
      // if (value == routeName && value != null) {
      if (value == routeName) {
        keysToRemove.add(key);
      }
    });
    keysToRemove.forEach((element) async {
      await delete(key: element);
    });
    keysToRemove.forEach((element) {
      GetConfig.routesKey?.remove(element);
    });
    keysToRemove.clear();
  }

  bool isRouteDependecyNull<S>({String name}) {
    return (GetConfig.routesKey[_getKey(S, name)] == null);
  }

  bool isDependencyInit<S>({String name}) {
    String key = _getKey(S, name);
    return GetConfig.routesKey.containsKey(key);
  }

  void registerRouteInstance<S>({String tag}) {
    GetConfig.routesKey
        .putIfAbsent(_getKey(S, tag), () => GetConfig.currentRoute);
  }

  S findByType<S>(Type type, {String tag}) {
    String key = _getKey(type, tag);
    return GetConfig._singl[key].getSependency() as S;
  }

  void initController<S>({String tag}) {
    String key = _getKey(S, tag);
    final i = GetConfig._singl[key].getSependency();

    if (i is DisposableInterface) {
      i.onStart();
      if (GetConfig.isLogEnable) print('[GET] $key has been initialized');
    }
  }

  /// Find a instance from required class
  S find<S>({String tag, FcBuilderFunc<S> instance}) {
    String key = _getKey(S, tag);
    bool callInit = false;
    if (isRegistred<S>(tag: tag)) {
      if (!isDependencyInit<S>() &&
          GetConfig.smartManagement != SmartManagement.onlyBuilder) {
        registerRouteInstance<S>(tag: tag);
        callInit = true;
      }

      FcBuilder builder = GetConfig._singl[key] as FcBuilder;
      if (builder == null) {
        if (tag == null) {
          throw "class ${S.toString()} is not register";
        } else {
          throw "class ${S.toString()} with tag '$tag' is not register";
        }
      }
      if (callInit) {
        initController<S>(tag: tag);
      }

      return GetConfig._singl[key].getSependency() as S;
    } else {
      if (!GetConfig._factory.containsKey(key))
        throw " $S not found. You need call put<$S>($S()) before";

      if (GetConfig.isLogEnable)
        print('[GET] $S instance was created at that time');
      S _value = put<S>(GetConfig._factory[key].builder() as S);

      if (!isDependencyInit<S>() &&
          GetConfig.smartManagement != SmartManagement.onlyBuilder) {
        registerRouteInstance<S>(tag: tag);
        callInit = true;
      }

      if (GetConfig.smartManagement != SmartManagement.keepFactory) {
        if (!GetConfig._factory[key].fenix) {
          GetConfig._factory.remove(key);
        }
      }

      if (callInit) {
        initController<S>(tag: tag);
      }
      return _value;
    }
  }

  /// Remove dependency of [S] on dependency abstraction. For concrete class use delete
  void remove<S>({String tag}) {
    String key = _getKey(S, tag);
    FcBuilder builder = GetConfig._singl[key] as FcBuilder;
    final i = builder.dependency;

    if (i is DisposableInterface) {
      i.onClose();
      if (GetConfig.isLogEnable) print('[GET] onClose of $key called');
    }
    if (builder != null) builder.dependency = null;
    if (GetConfig._singl.containsKey(key)) {
      print('error on remove $key');
    } else {
      if (GetConfig.isLogEnable) print('[GET] $key removed from memory');
    }
  }

  String _getKey(Type type, String name) {
    return name == null ? type.toString() : type.toString() + name;
  }

  bool reset({bool clearFactory = true, bool clearRouteBindings = true}) {
    if (clearFactory) GetConfig._factory.clear();
    if (clearRouteBindings) GetConfig.routesKey.clear();
    GetConfig._singl.clear();
    return true;
  }

  /// Delete class instance on [S] and clean memory
  Future<bool> delete<S>({String tag, String key}) async {
    String newKey;
    if (key == null) {
      newKey = _getKey(S, tag);
    } else {
      newKey = key;
    }

    if (!GetConfig._singl.containsKey(newKey)) {
      print('Instance $newKey not found');
      return false;
    }

    FcBuilder builder = GetConfig._singl[newKey] as FcBuilder;
    if (builder.permanent) {
      (key == null)
          ? print(
              '[GET] [$newKey] has been marked as permanent, SmartManagement is not authorized to delete it.')
          : print(
              '[GET] [$newKey] has been marked as permanent, SmartManagement is not authorized to delete it.');
      return false;
    }
    final i = builder.dependency;

    if (i is DisposableInterface) {
      await i.onClose();
      if (GetConfig.isLogEnable) print('[GET] onClose of $newKey called');
    }

    GetConfig._singl.removeWhere((oldkey, value) => (oldkey == newKey));
    if (GetConfig._singl.containsKey(newKey)) {
      print('[GET] error on remove object $newKey');
    } else {
      if (GetConfig.isLogEnable) print('[GET] $newKey deleted from memory');
    }
    // GetConfig.routesKey?.remove(key);
    return true;
  }

  /// check if instance is registred
  bool isRegistred<S>({String tag}) =>
      GetConfig._singl.containsKey(_getKey(S, tag));

  /// check if instance is prepared
  bool isPrepared<S>({String tag}) =>
      GetConfig._factory.containsKey(_getKey(S, tag));
}
