import '../get.dart';

extension GetResetExt on GetInterface {
  void reset({bool clearRouteBindings = true}) {
    GetInstance().resetInstance(clearRouteBindings: clearRouteBindings);
    Get.clearRouteTree();
    Get.clearTranslations();
    Get.resetRootNavigator();
  }
}
