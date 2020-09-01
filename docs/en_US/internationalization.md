## Translations
Translations are kept as a simple key-value dictionary map.
To add custom translations, create a class and extend `Translations`.
```dart
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        }
      };
}
```

### Using translations
Just append `.tr` to the specified key and it will be translated, using the current value of `Get.locale` and `Get.fallbackLocale`.
```dart
Text('title'.tr);
```

## Locales
Pass parameters to `GetMaterialApp` to define the locale and translations.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en_US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en_US'), // specify the fallback locale in case an invalid locale is selected.  
    supportedLocales: <Locale>[Locale('en_US'), Locale('de_DE')] // specify the supported locales
);
```

### Change locale
Call `Get.updateLocale(locale)` to update the locale. Translations then automatically use the new locale.
```dart
var locale = Locale('en_US');
Get.updateLocale(locale);
```

### System locale
To read the system locale, you could use `Platform.localeName`.
```dart
return GetMaterialApp(
    locale: Locale(Platform.localeName),
);
```
