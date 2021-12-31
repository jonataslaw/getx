import '../../../get_instance/src/lifecycle.dart';

/// Unlike GetxController, which serves to control events on each of its pages,
/// GetxService is not automatically disposed (nor can be removed with
/// Get.delete()).
/// It is ideal for situations where, once started, that service will
/// remain in memory, such as Auth control for example. Only way to remove
/// it is Get.reset().
abstract class GetxService with GetLifeCycleMixin, GetxServiceMixin {}

// abstract class DisposableInterface with GetLifeCycleMixin {}
