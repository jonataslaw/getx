import '../../get.dart';

//Converts a double value to a percentage
extension PercentSized on double {
  // height: 50.0.hp = 50%
  double get hp => (Get.height * (this / 100));
  // width: 30.0.hp = 30%
  double get wp => (Get.width * (this / 100));
}
