part of rx_types;

extension RxStringExt on Rx<String> {
  String operator +(String val) => _value + val;

  int compareTo(String other) {
    return value.compareTo(other);
  }

  /// Returns true if this string ends with [other]. For example:
  ///
  ///     'Dart'.endsWith('t'); // true
  bool endsWith(String other) {
    return value.endsWith(other);
  }

  /// Returns true if this string starts with a match of [pattern].
  bool startsWith(Pattern pattern, [int index = 0]) {
    return value.startsWith(pattern, index);
  }

  /// Returns the position of the first match of [pattern] in this string
  int indexOf(Pattern pattern, [int start = 0]) {
    return value.indexOf(pattern, start);
  }

  /// Returns the starting position of the last match [pattern] in this string,
  /// searching backward starting at [start], inclusive:
  int lastIndexOf(Pattern pattern, [int? start]) {
    return value.lastIndexOf(pattern, start);
  }

  /// Returns true if this string is empty.
  bool get isEmpty => value.isEmpty;

  /// Returns true if this string is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Returns the substring of this string that extends from [startIndex],
  /// inclusive, to [endIndex], exclusive
  String substring(int startIndex, [int? endIndex]) {
    return value.substring(startIndex, endIndex);
  }

  /// Returns the string without any leading and trailing whitespace.
  String trim() {
    return value.trim();
  }

  /// Returns the string without any leading whitespace.
  ///
  /// As [trim], but only removes leading whitespace.
  String trimLeft() {
    return value.trimLeft();
  }

  /// Returns the string without any trailing whitespace.
  ///
  /// As [trim], but only removes trailing whitespace.
  String trimRight() {
    return value.trimRight();
  }

  /// Pads this string on the left if it is shorter than [width].
  ///
  /// Return a new string that prepends [padding] onto this string
  /// one time for each position the length is less than [width].
  String padLeft(int width, [String padding = ' ']) {
    return value.padLeft(width, padding);
  }

  /// Pads this string on the right if it is shorter than [width].

  /// Return a new string that appends [padding] after this string
  /// one time for each position the length is less than [width].
  String padRight(int width, [String padding = ' ']) {
    return value.padRight(width, padding);
  }

  /// Returns true if this string contains a match of [other]:
  bool contains(Pattern other, [int startIndex = 0]) {
    return value.contains(other, startIndex);
  }

  /// Replaces all substrings that match [from] with [replace].
  String replaceAll(Pattern from, String replace) {
    return value.replaceAll(from, replace);
  }

  /// Splits the string at matches of [pattern] and returns a list
  /// of substrings.
  List<String> split(Pattern pattern) {
    return value.split(pattern);
  }

  /// Returns an unmodifiable list of the UTF-16 code units of this string.
  List<int> get codeUnits => value.codeUnits;

  /// Returns an [Iterable] of Unicode code-points of this string.
  ///
  /// If the string contains surrogate pairs, they are combined and returned
  /// as one integer by this iterator. Unmatched surrogate halves are treated
  /// like valid 16-bit code-units.
  Runes get runes => value.runes;

  /// Converts all characters in this string to lower case.
  /// If the string is already in all lower case, this method returns `this`.
  String toLowerCase() {
    return value.toLowerCase();
  }

  /// Converts all characters in this string to upper case.
  /// If the string is already in all upper case, this method returns `this`.
  String toUpperCase() {
    return value.toUpperCase();
  }

  Iterable<Match> allMatches(String string, [int start = 0]) {
    return value.allMatches(string, start);
  }

  Match? matchAsPrefix(String string, [int start = 0]) {
    return value.matchAsPrefix(string, start);
  }
}

extension RxnStringExt on Rx<String?> {
  String operator +(String val) => (_value ?? '') + val;

  int? compareTo(String other) {
    return value?.compareTo(other);
  }

  /// Returns true if this string ends with [other]. For example:
  ///
  ///     'Dart'.endsWith('t'); // true
  bool? endsWith(String other) {
    return value?.endsWith(other);
  }

  /// Returns true if this string starts with a match of [pattern].
  bool? startsWith(Pattern pattern, [int index = 0]) {
    return value?.startsWith(pattern, index);
  }

  /// Returns the position of the first match of [pattern] in this string
  int? indexOf(Pattern pattern, [int start = 0]) {
    return value?.indexOf(pattern, start);
  }

  /// Returns the starting position of the last match [pattern] in this string,
  /// searching backward starting at [start], inclusive:
  int? lastIndexOf(Pattern pattern, [int? start]) {
    return value?.lastIndexOf(pattern, start);
  }

  /// Returns true if this string is empty.
  bool? get isEmpty => value?.isEmpty;

  /// Returns true if this string is not empty.
  bool? get isNotEmpty => value?.isNotEmpty;

  /// Returns the substring of this string that extends from [startIndex],
  /// inclusive, to [endIndex], exclusive
  String? substring(int startIndex, [int? endIndex]) {
    return value?.substring(startIndex, endIndex);
  }

  /// Returns the string without any leading and trailing whitespace.
  String? trim() {
    return value?.trim();
  }

  /// Returns the string without any leading whitespace.
  ///
  /// As [trim], but only removes leading whitespace.
  String? trimLeft() {
    return value?.trimLeft();
  }

  /// Returns the string without any trailing whitespace.
  ///
  /// As [trim], but only removes trailing whitespace.
  String? trimRight() {
    return value?.trimRight();
  }

  /// Pads this string on the left if it is shorter than [width].
  ///
  /// Return a new string that prepends [padding] onto this string
  /// one time for each position the length is less than [width].
  String? padLeft(int width, [String padding = ' ']) {
    return value?.padLeft(width, padding);
  }

  /// Pads this string on the right if it is shorter than [width].

  /// Return a new string that appends [padding] after this string
  /// one time for each position the length is less than [width].
  String? padRight(int width, [String padding = ' ']) {
    return value?.padRight(width, padding);
  }

  /// Returns true if this string contains a match of [other]:
  bool? contains(Pattern other, [int startIndex = 0]) {
    return value?.contains(other, startIndex);
  }

  /// Replaces all substrings that match [from] with [replace].
  String? replaceAll(Pattern from, String replace) {
    return value?.replaceAll(from, replace);
  }

  /// Splits the string at matches of [pattern] and returns a list
  /// of substrings.
  List<String>? split(Pattern pattern) {
    return value?.split(pattern);
  }

  /// Returns an unmodifiable list of the UTF-16 code units of this string.
  List<int>? get codeUnits => value?.codeUnits;

  /// Returns an [Iterable] of Unicode code-points of this string.
  ///
  /// If the string contains surrogate pairs, they are combined and returned
  /// as one integer by this iterator. Unmatched surrogate halves are treated
  /// like valid 16-bit code-units.
  Runes? get runes => value?.runes;

  /// Converts all characters in this string to lower case.
  /// If the string is already in all lower case, this method returns `this`.
  String? toLowerCase() {
    return value?.toLowerCase();
  }

  /// Converts all characters in this string to upper case.
  /// If the string is already in all upper case, this method returns `this`.
  String? toUpperCase() {
    return value?.toUpperCase();
  }

  Iterable<Match>? allMatches(String string, [int start = 0]) {
    return value?.allMatches(string, start);
  }

  Match? matchAsPrefix(String string, [int start = 0]) {
    return value?.matchAsPrefix(string, start);
  }
}

/// Rx class for `String` Type.
class RxString extends Rx<String> implements Comparable<String>, Pattern {
  RxString(String initial) : super(initial);

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return value.allMatches(string, start);
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return value.matchAsPrefix(string, start);
  }

  @override
  int compareTo(String other) {
    return value.compareTo(other);
  }
}

/// Rx class for `String` Type.
class RxnString extends Rx<String?> implements Comparable<String>, Pattern {
  RxnString([String? initial]) : super(initial);

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return value!.allMatches(string, start);
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return value!.matchAsPrefix(string, start);
  }

  @override
  int compareTo(String other) {
    return value!.compareTo(other);
  }
}
