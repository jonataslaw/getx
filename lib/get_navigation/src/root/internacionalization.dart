const List<String> rtlLanguages = <String>[
  'ar', // Arabic
  'fa', // Farsi
  'he', // Hebrew
  'ps', // Pashto
  'ur',
];

abstract class Translations {
  const Translations();
  Map<String, Map<String, String>> get keys;
}
