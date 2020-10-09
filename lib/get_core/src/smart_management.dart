/// GetX by default disposes unused controllers from memory,
/// Through different behaviors.
/// SmartManagement.full
/// [SmartManagement.full] is the default one. Dispose classes that are
/// not being used and were not set to be permanent. In the majority
/// of the cases you will want to keep this config untouched.
/// If you new to GetX then don't change this.
/// [SmartManagement.onlyBuilders] only controllers started in init:
/// or loaded into a Binding with Get.lazyPut() will be disposed. If you use
/// Get.put() or Get.putAsync() or any other approach, SmartManagement
/// will not have permissions to exclude this dependency. With the default
/// behavior, even widgets instantiated with "Get.put" will be removed,
/// unlike SmartManagement.onlyBuilders.
/// [SmartManagement.keepFactory]Just like SmartManagement.full,
/// it will remove it's dependencies when it's not being used anymore.
/// However, it will keep their factory, which means it will recreate
/// the dependency if you need that instance again.
enum SmartManagement {
  full,
  onlyBuilder,
  keepFactory,
}
