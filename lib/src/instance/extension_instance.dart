import 'package:get/src/core/get_interface.dart';

import 'get_instance.dart';

extension Inst on GetInterface {
  void lazyPut<S>(FcBuilderFunc builder, {String tag, bool fenix = false}) {
    return GetInstance().lazyPut<S>(builder, tag: tag, fenix: fenix);
  }

  Future<S> putAsync<S>(FcBuilderFuncAsync<S> builder,
          {String tag, bool permanent = false}) async =>
      GetInstance().putAsync<S>(builder, tag: tag, permanent: permanent);

  void create<S>(FcBuilderFunc<S> builder,
          {String name, bool permanent = true}) =>
      GetInstance().create<S>(builder, name: name, permanent: permanent);

  S find<S>({String tag}) => GetInstance().find<S>(tag: tag);

  S put<S>(S dependency,
          {String tag, bool permanent = false, FcBuilderFunc<S> builder}) =>
      GetInstance()
          .put<S>(dependency, tag: tag, permanent: permanent, builder: builder);

  bool reset({bool clearFactory = true, bool clearRouteBindings = true}) =>
      GetInstance().reset(
          clearFactory: clearFactory, clearRouteBindings: clearRouteBindings);

  /// Delete class instance on [S] and clean memory
  Future<bool> delete<S>({String tag, String key}) async =>
      GetInstance().delete<S>(tag: tag, key: key);

  bool isRegistered<S>({String tag}) => GetInstance().isRegistered<S>(tag: tag);
}
