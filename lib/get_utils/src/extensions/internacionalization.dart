import 'dart:ui';
import '../../../get_core/get_core.dart';

extension Trans on String? {
  String? get tr {
    // Returns the key if locale is null.
    if (Get.locale?.languageCode == null) return this;

    // Checks whether the language code and country code are present, and
    // whether the key is also present.
    if (Get.translations.containsKey(
            "${Get.locale!.languageCode}_${Get.locale!.countryCode}") &&
        Get.translations[
                "${Get.locale!.languageCode}_${Get.locale!.countryCode}"]!
            .containsKey(this)) {
      return Get.translations[
          "${Get.locale!.languageCode}_${Get.locale!.countryCode}"]![this!];

      // Checks if there is a callback language in the absence of the specific
      // country, and if it contains that key.
    } else if (Get.translations.containsKey(Get.locale!.languageCode) &&
        Get.translations[Get.locale!.languageCode]!.containsKey(this)) {
      return Get.translations[Get.locale!.languageCode]![this!];
      // If there is no corresponding language or corresponding key, return
      // the key.
    } else if (Get.fallbackLocale != null) {
      final fallback = Get.fallbackLocale!;
      final key = "${fallback.languageCode}_${fallback.countryCode}";

      if (Get.translations.containsKey(key) &&
          Get.translations[key]!.containsKey(this)) {
        return Get.translations[key]![this!];
      }
      if (Get.translations.containsKey(fallback.languageCode) &&
          Get.translations[fallback.languageCode]!.containsKey(this)) {
        return Get.translations[fallback.languageCode]![this!];
      }
      return this;
    } else {
      return this;
    }
  }

  String? trArgs([List<String> args = const []]) {
    var key = tr;
    if (args.isNotEmpty) {
      for (final arg in args) {
        key = key!.replaceFirst(RegExp(r'%s'), arg.toString());
      }
    }
    return key;
  }

  String? trPlural([String? pluralKey, int? i, List<String> args = const []]) {
    return i == 1 ? pluralKey.trArgs(args) : trArgs(args);
  }

  String? trParams([Map<String, String> params = const {}]) {
    var trans = tr;
    if (params.isNotEmpty) {
      params.forEach((key, value) {
        trans = trans!.replaceAll('@$key', value);
      });
    }
    return trans;
  }

  String? trPluralParams(
      [String? pluralKey, int? i, Map<String, String> params = const {}]) {
    return i == 1 ? pluralKey.trParams(params) : trParams(params);
  }
}

class _IntlHost {
  Locale? locale;

  Locale? fallbackLocale;

  Map<String, Map<String, String>> translations = {};
}

extension LocalesIntl on GetInterface {
  static final _intlHost = _IntlHost();

  Locale? get locale => _intlHost.locale;

  Locale? get fallbackLocale => _intlHost.fallbackLocale;

  set locale(Locale? newLocale) => _intlHost.locale = newLocale;

  set fallbackLocale(Locale? newLocale) => _intlHost.fallbackLocale = newLocale;

  Map<String, Map<String, String>> get translations => _intlHost.translations;

  void addTranslations(Map<String, Map<String, String>> tr) {
    translations.addAll(tr);
  }

  void appendTranslations(Map<String, Map<String, String>> tr) {
    tr.forEach((key, map) {
      if (translations.containsKey(key)) {
        translations[key]!.addAll(map);
      } else {
        translations[key] = map;
      }
    });
  }
}
