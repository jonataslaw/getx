import 'package:get/src/core/get_interface.dart';

import 'get_instance.dart';

extension Inst on GetInterface {
  void lazyPut<S>(InstanceBuilderCallback<S> builder,
      {String tag, bool fenix = false}) {
    return GetInstance().lazyPut<S>(builder, tag: tag, fenix: fenix);
  }

  Future<S> putAsync<S>(AsyncInstanceBuilderCallback<S> builder,
          {String tag, bool permanent = false}) async =>
      GetInstance().putAsync<S>(builder, tag: tag, permanent: permanent);

  /// Creates a new Instance<[S]> from the <[S]>[builder] callback.
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
  void create<S>(InstanceBuilderCallback<S> builder,
          {String name, bool permanent = true}) =>
      GetInstance().create<S>(builder, name: name, permanent: permanent);

  /// Finds a instance of the required Class<[S]> (or [tag])
  /// In the case of using Get.[create], it will create an instance
  /// each time you call [find]
  ///
  S find<S>({String tag}) => GetInstance().find<S>(tag: tag);

  /// Injects a Instance [S] in [GetInstance].
  ///
  /// No need to define the generic type <[S]> as it's inferred from the [dependency]
  ///
  /// - [dependency] The Instance to be injected.
  /// - [tag] optionally, use a [tag] as an "id" to create multiple records of the same Type<[S]>
  /// - [permanent] keeps the Instance in memory, not following [GetConfig.smartManagement]
  ///   rules
  ///
  S put<S>(S dependency,
          {String tag,
          bool permanent = false,
          InstanceBuilderCallback<S> builder}) =>
      GetInstance()
          .put<S>(dependency, tag: tag, permanent: permanent, builder: builder);

  bool reset({bool clearFactory = true, bool clearRouteBindings = true}) =>
      GetInstance().reset(
          clearFactory: clearFactory, clearRouteBindings: clearRouteBindings);

  /// Delete class instance on [S] and clean memory
  Future<bool> delete<S>({String tag, String key}) async =>
      GetInstance().delete<S>(tag: tag, key: key);

  bool isRegistered<S>({String tag}) => GetInstance().isRegistered<S>(tag: tag);

  bool isPrepared<S>({String tag}) => GetInstance().isPrepared<S>(tag: tag);
}
