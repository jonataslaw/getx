import '../get.dart';

extension GetResetExt on GetInterface {
  void reset({final bool clearRouteBindings = true}) {
    Get.resetInstance(clearRouteBindings: clearRouteBindings);
    // Get.clearRouteTree();
    Get.clearTranslations();
    // Get.resetRootNavigator();
  }
}
