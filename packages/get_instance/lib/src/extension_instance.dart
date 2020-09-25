import 'package:get_core/get_core.dart';

import 'get_instance.dart';

extension Inst on GetInterface {
  /// Creates a new Instance<S> lazily from the [<S>builder()] callback.
  ///
  /// The first time you call [Get.find()], the [builder()] callback will create
  /// the Instance and persisted as a Singleton (like you would use
  /// [Get.put()]).
  ///
  /// Using [Get.smartManagement] as [SmartManagement.keepFactory] has
  /// the same outcome
  /// as using [fenix:true] :
  /// The internal register of [builder()] will remain in memory to recreate
  /// the Instance if the Instance has been removed with [Get.delete()].
  /// Therefore, future calls to [Get.find()] will return the same Instance.
  ///
  /// If you need to make use of GetxController's life-cycle
  /// ([onInit(), onStart(), onClose()])
  /// [fenix] is a great choice to mix with [GetBuilder()] and [GetX()] widgets,
  /// and/or [GetMaterialApp] Navigation.
  ///
  /// You could use [Get.lazyPut(fenix:true)] in your app's [main()] instead of
  /// [Bindings()] for each [GetPage].
  /// And the memory management will be similar.
  ///
  /// Subsequent calls to [Get.lazyPut()] with the same parameters
  /// (<[S]> and optionally [tag] will **not** override the original).
  void lazyPut<S>(InstanceBuilderCallback<S> builder,
      {String tag, bool fenix = false}) {
    GetInstance().lazyPut<S>(builder, tag: tag, fenix: fenix);
  }

  /// async version of [Get.put()].
  /// Awaits for the resolution of the Future from [builder()] parameter and
  /// stores the Instance returned.
  Future<S> putAsync<S>(AsyncInstanceBuilderCallback<S> builder,
          {String tag, bool permanent = false}) async =>
      GetInstance().putAsync<S>(builder, tag: tag, permanent: permanent);

  /// Creates a new Class Instance [S] from the builder callback[S].
  /// Every time [find]<[S]>() is used, it calls the builder method to generate
  /// a new Instance [S].
  /// It also registers each [instance.onClose()] with the current
  /// Route [GetConfig.currentRoute] to keep the lifecycle active.
  /// Is important to know that the instances created are only stored per Route.
  /// So, if you call `Get.delete<T>()` the "instance factory" used in this
  /// method ([Get.create<T>()]) will be removed, but NOT the instances
  /// already created by it.
  /// Uses `tag` as the other methods.
  ///
  /// Example:
  ///
  /// ```create(() => Repl());
  /// Repl a = find();
  /// Repl b = find();
  /// print(a==b); (false)```
  void create<S>(InstanceBuilderCallback<S> builder,
          {String tag, bool permanent = true}) =>
      GetInstance().create<S>(builder, tag: tag, permanent: permanent);

  /// Finds a Instance of the required Class <[S]>(or [tag])
  /// In the case of using [Get.create()], it will generate an Instance
  /// each time you call [Get.find()].
  S find<S>({String tag}) => GetInstance().find<S>(tag: tag);

  /// Injects an [Instance<S>] in memory.
  ///
  /// No need to define the generic type <[S]> as it's inferred
  /// from the [dependency] parameter.
  ///
  /// - [dependency] The Instance to be injected.
  /// - [tag] optionally, use a [tag] as an "id" to create multiple records
  /// of the same Type<[S]> the [tag] does **not** conflict with the same tags
  /// used by other [dependencies] Types.
  /// - [permanent] keeps the Instance in memory and persist it,
  /// not following [Get.smartManagement]
  /// rules. Although, can be removed by [GetInstance.reset()]
  /// and [Get.delete()]
  /// - [builder] If defined, the [dependency] must be returned from here
  S put<S>(S dependency,
          {String tag,
          bool permanent = false,
          InstanceBuilderCallback<S> builder}) =>
      GetInstance()
          .put<S>(dependency, tag: tag, permanent: permanent, builder: builder);

  /// Clears all registered instances (and/or tags).
  /// Even the persistent ones.
  ///
  /// - [clearFactory] clears the callbacks registered by [Get.lazyPut()]
  /// - [clearRouteBindings] clears Instances associated with Routes when using
  ///   [GetMaterialApp].
  bool reset({bool clearFactory = true, bool clearRouteBindings = true}) =>
      GetInstance().reset(
          clearFactory: clearFactory, clearRouteBindings: clearRouteBindings);

  /// Deletes the Instance<[S]>, cleaning the memory and closes any open
  /// controllers ([DisposableInterface]).
  ///
  /// - [tag] Optional "tag" used to register the Instance
  /// - [force] Will delete an Instance even if marked as [permanent].
  Future<bool> delete<S>({String tag, bool force = false}) async =>
      GetInstance().delete<S>(tag: tag, force: force);

  /// Checks if a Class Instance<[S]> (or [tag]) is registered in memory.
  /// - [tag] optional, if you use a [tag] to register the Instance.
  bool isRegistered<S>({String tag}) => GetInstance().isRegistered<S>(tag: tag);

  /// Checks if an Instance<[S]> (or [tag]) returned from a factory builder
  /// [Get.lazyPut()], is registered in memory.
  /// - [tag] optional, if you use a [tag] to register the Instance.
  bool isPrepared<S>({String tag}) => GetInstance().isPrepared<S>(tag: tag);
}
