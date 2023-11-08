import '../../get.dart';

//Converts a double value to a percentage
extension PercentSized on double {
  // height: 50.0.hp = 50%
  double get hp => (Get.height * (this / 100));
  // width: 30.0.hp = 30%
  double get wp => (Get.width * (this / 100));
  
  // split width in landscape (2 half)
  double get swp => this *  (isLandscape ? (Get.width * 0.5) : Get.width) / 100;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  double get sp => this * ((isLandscape ? Get.height : Get.width) / fontSizeDividedRation) / 100;

  // define what a ratio that I will divided font
  int get fontSizeDividedRation => Get.context!.isPhone ? 3 : 5;

  // if landscape
  bool get isLandscape => Get.context!.isLandscape;
}
