import 'dart:ui';

import '../../../get_core/get_core.dart';

/// A private class used for managing internationalization (i18n) settings and translations.
class _IntlHost {
  /// The current locale being used for translations.
  Locale? locale;

  /// The fallback locale to be used if translations are not available in the current locale.
  Locale? fallbackLocale;

  /// A map containing translations for different locales.
  Map<String, Map<String, String>> translations =
      <String, Map<String, String>>{};
}

/// An extension on [GetInterface] providing internationalization (i18n) capabilities.
extension LocalesIntlExt on GetInterface {
  static final _IntlHost _intlHost = _IntlHost();

  /// Gets the current locale being used for translations.
  Locale? get locale => _intlHost.locale;

  /// Gets the fallback locale to be used if translations are not available in the current locale.
  Locale? get fallbackLocale => _intlHost.fallbackLocale;

  /// Sets the current locale to be used for translations.
  set locale(Locale? newLocale) => _intlHost.locale = newLocale;

  /// Sets the fallback locale to be used if translations are not available in the current locale.
  set fallbackLocale(Locale? newLocale) => _intlHost.fallbackLocale = newLocale;

  /// Gets the map containing translations for different locales.
  Map<String, Map<String, String>> get translations => _intlHost.translations;

  /// Adds translations to the internationalization host.
  ///
  /// The [tr] parameter is a map containing translations for different locales.
  void addTranslations(Map<String, Map<String, String>> tr) {
    translations.addAll(tr);
  }

  /// Clears all translations from the internationalization host.
  void clearTranslations() {
    translations.clear();
  }

  /// Appends translations to existing translations in the internationalization host.
  ///
  /// The [tr] parameter is a map containing translations for different locales.
  void appendTranslations(Map<String, Map<String, String>> tr) {
    tr.forEach((String key, Map<String, String> map) {
      if (translations.containsKey(key)) {
        translations[key]!.addAll(map);
      } else {
        translations[key] = map;
      }
    });
  }
}

/// An extension on [String] providing internationalization (i18n) capabilities.
extension TransExt on String {
  // Checks whether the language code and country code are present, and
  // whether the key is also present.
  bool get _fullLocaleAndKey {
    return Get.translations.containsKey(
            '${Get.locale!.languageCode}_${Get.locale!.countryCode}') &&
        Get.translations[
                '${Get.locale!.languageCode}_${Get.locale!.countryCode}']!
            .containsKey(this);
  }

  // Checks if there is a callback language in the absence of the specific
  // country, and if it contains that key.
  Map<String, String>? get _getSimilarLanguageTranslation {
    final Map<String, Map<String, String>> translationsWithNoCountry =
        Get.translations.map((String key, Map<String, String> value) =>
            MapEntry<String, Map<String, String>>(key.split('_').first, value));
    final bool containsKey = translationsWithNoCountry
        .containsKey(Get.locale!.languageCode.split('_').first);

    if (!containsKey) {
      return null;
    }

    return translationsWithNoCountry[Get.locale!.languageCode.split('_').first];
  }

  /// Localizes the string based on the current locale.
  ///
  /// This method looks for translations based on the current locale, fallback locale,
  /// and similar languages. It returns the localized string or the original string
  /// if no translation is found.
  ///
  /// Returns:
  /// - The localized string if a translation is found.
  /// - The original string if no translation is found or the locale is null.
  ///
  /// Example usage:
  /// ```dart
  /// final greeting = 'hello'.tr;
  /// `
  String get tr {
    // print('language');
    // print(Get.locale!.languageCode);
    // print('contains');
    // print(Get.translations.containsKey(Get.locale!.languageCode));
    // print(Get.translations.keys);
    // Returns the key if locale is null.
    if (Get.locale?.languageCode == null) {
      return this;
    }

    if (_fullLocaleAndKey) {
      return Get.translations[
          '${Get.locale!.languageCode}_${Get.locale!.countryCode}']![this]!;
    }
    final Map<String, String>? similarTranslation =
        _getSimilarLanguageTranslation;
    if (similarTranslation != null && similarTranslation.containsKey(this)) {
      return similarTranslation[this]!;
      // If there is no corresponding language or corresponding key, return
      // the key.
    } else if (Get.fallbackLocale != null) {
      final Locale fallback = Get.fallbackLocale!;
      final String key = '${fallback.languageCode}_${fallback.countryCode}';

      if (Get.translations.containsKey(key) &&
          Get.translations[key]!.containsKey(this)) {
        return Get.translations[key]![this]!;
      }
      if (Get.translations.containsKey(fallback.languageCode) &&
          Get.translations[fallback.languageCode]!.containsKey(this)) {
        return Get.translations[fallback.languageCode]![this]!;
      }
      return this;
    } else {
      return this;
    }
  }

  /// Localizes the string with arguments based on the current locale.
  ///
  /// This method is used to localize a string with placeholders for dynamic values.
  /// It replaces placeholders in the localized string with the provided arguments.
  ///
  /// Returns:
  /// - The localized string with replaced placeholders.
  ///
  /// Example usage:
  /// ```dart
  /// final greeting = 'Hello, %s!'.trArgs(['John']);
  ///
  String trArgs([List<String> args = const <String>[]]) {
    String key = tr;
    if (args.isNotEmpty) {
      for (final String arg in args) {
        key = key.replaceFirst(RegExp(r'%s'), arg);
      }
    }
    return key;
  }

  /// Localizes the string based on pluralization rules.
  ///
  /// This method is used to localize a string based on the count [i] and arguments.
  /// It selects the appropriate translation for the pluralization rule of the count.
  ///
  /// Returns:
  /// - The localized string for the specified pluralization rule and arguments.
  ///
  /// Example usage:
  /// ```dart
  /// final apples = 'apple'.trPlural('apples', 3, ['3']);
  /// // Uses 'apples' translation for plural count 3.
  /// ```
  String trPlural(
      [String? pluralKey, int? i, List<String> args = const <String>[]]) {
    return i == 1 ? trArgs(args) : pluralKey!.trArgs(args);
  }

  /// Localizes the string with parameter replacement based on the current locale.
  ///
  /// This method is used to localize a string with parameter placeholders in the format '@paramName'.
  /// It replaces parameter placeholders in the localized string with the provided values.
  ///
  /// Returns:
  /// - The localized string with replaced parameter placeholders.
  ///
  /// Example usage:
  /// ```dart
  /// final message = 'Hello, @name!'.trParams({'name': 'John'});
  /// ```
  String trParams([Map<String, String> params = const <String, String>{}]) {
    String trans = tr;
    if (params.isNotEmpty) {
      params.forEach((String key, String value) {
        trans = trans.replaceAll('@$key', value);
      });
    }
    return trans;
  }

  /// Localizes the string based on pluralization rules with parameter replacement.
  ///
  /// This method is used to localize a string based on the count [i], parameters, and pluralization rules.
  /// It selects the appropriate translation for the pluralization rule of the count and replaces parameter placeholders.
  ///
  /// Returns:
  /// - The localized string for the specified pluralization rule, parameters, and count.
  ///
  /// Example usage:
  /// ```dart
  /// final message = 'There is @count apple'.trPluralParams('There are @count apples', 3, {'count': '3'});
  /// // Uses 'There are @count apples' translation for plural count 3 and replaces '@count' with '3'.
  /// ```
  String trPluralParams(
      [String? pluralKey,
      int? i,
      Map<String, String> params = const <String, String>{}]) {
    return i == 1 ? trParams(params) : pluralKey!.trParams(params);
  }
}
