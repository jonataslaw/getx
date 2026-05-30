const List<String> rtlLanguages = <String>[
  'ar', // Arabic
  'fa', // Farsi
  'he', // Hebrew
  'ps', // Pashto
  'ur',
];

abstract class Translations {
  Map<String, Map<String, String>> get keys;
}
