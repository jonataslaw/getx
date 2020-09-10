import '../../core/get_main.dart';

extension Trans on String {
  String get tr {
    // Returns the key if locale is null.
    if (Get.locale?.languageCode == null) return this;

    // Checks whether the language code and country code are present, and
    // whether the key is also present.
    if (Get.translations.containsKey(
            "${Get.locale.languageCode}_${Get.locale.countryCode}") &&
        Get.translations["${Get.locale.languageCode}_${Get.locale.countryCode}"]
            .containsKey(this)) {
      return Get.translations[
          "${Get.locale.languageCode}_${Get.locale.countryCode}"][this];

      // Checks if there is a callback language in the absence of the specific
      // country, and if it contains that key.
    } else if (Get.translations.containsKey(Get.locale.languageCode) &&
        Get.translations[Get.locale.languageCode].containsKey(this)) {
      return Get.translations[Get.locale.languageCode][this];
      // If there is no corresponding language or corresponding key, return
      // the key.
    } else if (Get.fallbackLocale != null) {
      final fallback = Get.fallbackLocale;
      final key = "${fallback.languageCode}_${fallback.countryCode}";

      if (Get.translations.containsKey(key) &&
          Get.translations[key].containsKey(this)) {
        return Get.translations[key][this];
      }
      if (Get.translations.containsKey(fallback.languageCode) &&
          Get.translations[fallback.languageCode].containsKey(this)) {
        return Get.translations[fallback.languageCode][this];
      }
      return this;
    } else {
      return this;
    }
  }

  String trArgs([List<String> args]) {
    var key = tr;
    if (args != null) {
      for (final arg in args) {
        key = key.replaceFirst(RegExp(r'%s'), arg.toString());
      }
    }
    return key;
  }
}
