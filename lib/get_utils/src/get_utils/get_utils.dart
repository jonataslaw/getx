import '../../../get_core/get_core.dart';

/// Returns whether a dynamic value PROBABLY
/// has the isEmpty getter/method by checking
/// standard dart types that contains it.
///
/// This is here to for the 'DRY'
bool? _isEmpty(final dynamic value) {
  if (value is String) {
    return value.toString().trim().isEmpty;
  }
  if (value is Iterable || value is Map) {
    return value.isEmpty as bool?;
  }
  return false;
}

/// Returns whether a dynamic value PROBABLY
/// has the length getter/method by checking
/// standard dart types that contains it.
///
/// This is here to for the 'DRY'
bool _hasLength(final dynamic value) {
  return value is Iterable || value is String || value is Map;
}

/// Obtains a length of a dynamic value
/// by previously validating it's type
///
/// Note: if [value] is double/int
/// it will be taking the .toString
/// length of the given value.
///
/// Note 2: **this may return null!**
///
/// Note 3: null [value] returns null.
int? _obtainDynamicLength(final dynamic value) {
  if (value == null) {
    // ignore: avoid_returning_null
    return null;
  }

  if (_hasLength(value)) {
    return value.length as int?;
  }

  if (value is int) {
    return value.toString().length;
  }

  if (value is double) {
    return value.toString().replaceAll('.', '').length;
  }

  // ignore: avoid_returning_null
  return null;
}

class GetUtils {
  GetUtils._();

  /// Checks if data is null.
  static bool isNull(final dynamic value) => value == null;

  /// In dart2js (in flutter v1.17) a var by default is undefined.
  /// *Use this only if you are in version <- 1.17*.
  /// So we assure the null type in json conversions to avoid the
  /// "value":value==null?null:value; someVar.nil will force the null type
  /// if the var is null or undefined.
  /// `nil` taken from ObjC just to have a shorter syntax.
  static dynamic nil(final dynamic s) => s;

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool? isNullOrBlank(final dynamic value) {
    if (isNull(value)) {
      return true;
    }

    // Pretty sure that isNullOrBlank should't be validating
    // iterables... but I'm going to keep this for compatibility.
    return _isEmpty(value);
  }

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool? isBlank(final dynamic value) {
    return _isEmpty(value);
  }

  /// Checks if string is int or double.
  static bool isNum(final String value) {
    if (isNull(value)) {
      return false;
    }

    return num.tryParse(value) is num;
  }

  /// Checks if string consist only numeric.
  /// Numeric only doesn't accepting "." which double data type have
  static bool isNumericOnly(final String s) => hasMatch(s, r'^\d+$');

  /// Checks if string consist only Alphabet. (No Whitespace)
  static bool isAlphabetOnly(final String s) => hasMatch(s, r'^[a-zA-Z]+$');

  /// Checks if string contains at least one Capital Letter
  static bool hasCapitalLetter(final String s) => hasMatch(s, r'[A-Z]');

  /// Checks if string is boolean.
  static bool isBool(final String value) {
    if (isNull(value)) {
      return false;
    }

    return value == 'true' || value == 'false';
  }

  /// Checks if string is an video file.
  static bool isVideo(final String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith('.mp4') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.wmv') ||
        ext.endsWith('.rmvb') ||
        ext.endsWith('.mpg') ||
        ext.endsWith('.mpeg') ||
        ext.endsWith('.3gp');
  }

  /// Checks if string is an image file.
  static bool isImage(final String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith('.jpg') ||
        ext.endsWith('.jpeg') ||
        ext.endsWith('.png') ||
        ext.endsWith('.gif') ||
        ext.endsWith('.bmp');
  }

  /// Checks if string is an audio file.
  static bool isAudio(final String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith('.mp3') ||
        ext.endsWith('.wav') ||
        ext.endsWith('.wma') ||
        ext.endsWith('.amr') ||
        ext.endsWith('.ogg');
  }

  /// Checks if string is an powerpoint file.
  static bool isPPT(final String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith('.ppt') || ext.endsWith('.pptx');
  }

  /// Checks if string is an word file.
  static bool isWord(final String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith('.doc') || ext.endsWith('.docx');
  }

  /// Checks if string is an excel file.
  static bool isExcel(final String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith('.xls') || ext.endsWith('.xlsx');
  }

  /// Checks if string is an apk file.
  static bool isAPK(final String filePath) {
    return filePath.toLowerCase().endsWith('.apk');
  }

  /// Checks if string is an pdf file.
  static bool isPDF(final String filePath) {
    return filePath.toLowerCase().endsWith('.pdf');
  }

  /// Checks if string is an txt file.
  static bool isTxt(final String filePath) {
    return filePath.toLowerCase().endsWith('.txt');
  }

  /// Checks if string is an chm file.
  static bool isChm(final String filePath) {
    return filePath.toLowerCase().endsWith('.chm');
  }

  /// Checks if string is a vector file.
  static bool isVector(final String filePath) {
    return filePath.toLowerCase().endsWith('.svg');
  }

  /// Checks if string is an html file.
  static bool isHTML(final String filePath) {
    return filePath.toLowerCase().endsWith('.html');
  }

  /// Checks if string is a valid username.
  static bool isUsername(final String s) =>
      hasMatch(s, r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$');

  /// Checks if string is URL.
  static bool isURL(final String s) => hasMatch(s,
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,7}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");

  /// Checks if string is email.
  static bool isEmail(final String s) => hasMatch(s,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Checks if string is phone number.
  static bool isPhoneNumber(final String s) {
    if (s.length > 16 || s.length < 9) return false;
    return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  /// Checks if string is DateTime (UTC or Iso8601).
  static bool isDateTime(final String s) =>
      hasMatch(s, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$');

  /// Checks if string is MD5 hash.
  static bool isMD5(final String s) => hasMatch(s, r'^[a-f0-9]{32}$');

  /// Checks if string is SHA1 hash.
  static bool isSHA1(final String s) =>
      hasMatch(s, r'(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})');

  /// Checks if string is SHA256 hash.
  static bool isSHA256(final String s) =>
      hasMatch(s, r'([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}');

  /// Checks if string is SSN (Social Security Number).
  static bool isSSN(final String s) => hasMatch(s,
      r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$');

  /// Checks if string is binary.
  static bool isBinary(final String s) => hasMatch(s, r'^[0-1]+$');

  /// Checks if string is IPv4.
  static bool isIPv4(final String s) =>
      hasMatch(s, r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');

  /// Checks if string is IPv6.
  static bool isIPv6(final String s) => hasMatch(s,
      r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$');

  /// Checks if string is hexadecimal.
  /// Example: HexColor => #12F
  static bool isHexadecimal(final String s) =>
      hasMatch(s, r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  /// Checks if string is Palindrome.
  static bool isPalindrome(final String string) {
    final cleanString = string
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'[^0-9a-zA-Z]+'), '');

    for (var i = 0; i < cleanString.length; i++) {
      if (cleanString[i] != cleanString[cleanString.length - i - 1]) {
        return false;
      }
    }

    return true;
  }

  /// Checks if all data have same value.
  /// Example: 111111 -> true, wwwww -> true, 1,1,1,1 -> true
  static bool isOneAKind(final dynamic value) {
    if ((value is String || value is List) && !isNullOrBlank(value)!) {
      final first = value[0];
      final len = value.length as num;

      for (var i = 0; i < len; i++) {
        if (value[i] != first) {
          return false;
        }
      }

      return true;
    }

    if (value is int) {
      final stringValue = value.toString();
      final first = stringValue[0];

      for (var i = 0; i < stringValue.length; i++) {
        if (stringValue[i] != first) {
          return false;
        }
      }

      return true;
    }

    return false;
  }

  /// Checks if string is Passport No.
  static bool isPassport(final String s) =>
      hasMatch(s, r'^(?!^0+$)[a-zA-Z0-9]{6,9}$');

  /// Checks if string is Currency.
  static bool isCurrency(final String s) => hasMatch(s,
      r'^(S?\$|\₩|Rp|\¥|\€|\₹|\₽|fr|R\$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]+)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR))?$');

  /// Checks if length of data is GREATER than maxLength.
  static bool isLengthGreaterThan(final dynamic value, final int maxLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length > maxLength;
  }

  /// Checks if length of data is GREATER OR EQUAL to maxLength.
  static bool isLengthGreaterOrEqual(final dynamic value, final int maxLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length >= maxLength;
  }

  /// Checks if length of data is LESS than maxLength.
  static bool isLengthLessThan(final dynamic value, final int maxLength) {
    final length = _obtainDynamicLength(value);
    if (length == null) {
      return false;
    }

    return length < maxLength;
  }

  /// Checks if length of data is LESS OR EQUAL to maxLength.
  static bool isLengthLessOrEqual(final dynamic value, final int maxLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length <= maxLength;
  }

  /// Checks if length of data is EQUAL to maxLength.
  static bool isLengthEqualTo(final dynamic value, final int otherLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length == otherLength;
  }

  /// Checks if length of data is BETWEEN minLength to maxLength.
  static bool isLengthBetween(final dynamic value, final int minLength, final int maxLength) {
    if (isNull(value)) {
      return false;
    }

    return isLengthGreaterOrEqual(value, minLength) &&
        isLengthLessOrEqual(value, maxLength);
  }

  /// Checks if a contains b (Treating or interpreting upper- and lowercase
  /// letters as being the same).
  static bool isCaseInsensitiveContains(final String a, final String b) {
    return a.toLowerCase().contains(b.toLowerCase());
  }

  /// Checks if a contains b or b contains a (Treating or
  /// interpreting upper- and lowercase letters as being the same).
  static bool isCaseInsensitiveContainsAny(final String a, final String b) {
    final lowA = a.toLowerCase();
    final lowB = b.toLowerCase();

    return lowA.contains(lowB) || lowB.contains(lowA);
  }

  /// Checks if num a LOWER than num b.
  static bool isLowerThan(final num a, final num b) => a < b;

  /// Checks if num a GREATER than num b.
  static bool isGreaterThan(final num a, final num b) => a > b;

  /// Checks if num a EQUAL than num b.
  static bool isEqual(final num a, final num b) => a == b;

  // Checks if num is a cnpj
  static bool isCnpj(final String cnpj) {
    // Get only the numbers from the CNPJ
    final numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Test if the CNPJ has 14 digits
    if (numbers.length != 14) {
      return false;
    }

    // Test if all digits of the CNPJ are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // Divide digits
    final digits = numbers.split('').map(int.parse).toList();

    // Calculate the first check digit
    var calcDv1 = 0;
    var j = 0;
    for (final i in Iterable<int>.generate(12, (final i) => i < 4 ? 5 - i : 13 - i)) {
      calcDv1 += digits[j++] * i;
    }
    calcDv1 %= 11;
    final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Test the first check digit
    if (digits[12] != dv1) {
      return false;
    }

    // Calculate the second check digit
    var calcDv2 = 0;
    j = 0;
    for (final i in Iterable<int>.generate(13, (final i) => i < 5 ? 6 - i : 14 - i)) {
      calcDv2 += digits[j++] * i;
    }
    calcDv2 %= 11;
    final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Test the second check digit
    if (digits[13] != dv2) {
      return false;
    }

    return true;
  }

  /// Checks if the cpf is valid.
  static bool isCpf(final String cpf) {
    // if (cpf == null) {
    //   return false;
    // }

    // get only the numbers
    final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    // Test if the CPF has 11 digits
    if (numbers.length != 11) {
      return false;
    }
    // Test if all CPF digits are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // split the digits
    final digits = numbers.split('').map(int.parse).toList();

    // Calculate the first verifier digit
    var calcDv1 = 0;
    for (final i in Iterable<int>.generate(9, (final i) => 10 - i)) {
      calcDv1 += digits[10 - i] * i;
    }
    calcDv1 %= 11;

    final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Tests the first verifier digit
    if (digits[9] != dv1) {
      return false;
    }

    // Calculate the second verifier digit
    var calcDv2 = 0;
    for (final i in Iterable<int>.generate(10, (final i) => 11 - i)) {
      calcDv2 += digits[11 - i] * i;
    }
    calcDv2 %= 11;

    final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Test the second verifier digit
    if (digits[10] != dv2) {
      return false;
    }

    return true;
  }

  /// Capitalize each word inside string
  /// Example: your name => Your Name, your name => Your name
  static String capitalize(final String value) {
    if (isBlank(value)!) return value;
    return value.split(' ').map(capitalizeFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  static String capitalizeFirst(final String s) {
    if (isBlank(s)!) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Remove all whitespace inside string
  /// Example: your name => yourname
  static String removeAllWhitespace(final String value) {
    return value.replaceAll(' ', '');
  }

  /// camelCase string
  /// Example: your name => yourName
  static String? camelCase(final String value) {
    if (isNullOrBlank(value)!) {
      return null;
    }

    final separatedWords =
        value.split(RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^%-\s_]+'));
    var newString = '';

    for (final word in separatedWords) {
      newString += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    return newString[0].toLowerCase() + newString.substring(1);
  }

  /// credits to "ReCase" package.
  static final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
  static final _symbolSet = {' ', '.', '/', '_', r'\', '-'};
  static List<String> _groupIntoWords(final String text) {
    final sb = StringBuffer();
    final words = <String>[];
    final isAllCaps = text.toUpperCase() == text;

    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      final nextChar = i + 1 == text.length ? null : text[i + 1];
      if (_symbolSet.contains(char)) {
        continue;
      }
      sb.write(char);
      final isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolSet.contains(nextChar);
      if (isEndOfWord) {
        words.add('$sb');
        sb.clear();
      }
    }
    return words;
  }

  /// snake_case
  static String? snakeCase(final String? text, {final String separator = '_'}) {
    if (isNullOrBlank(text)!) {
      return null;
    }
    return _groupIntoWords(text!)
        .map((final word) => word.toLowerCase())
        .join(separator);
  }

  /// param-case
  static String? paramCase(final String? text) => snakeCase(text, separator: '-');

  /// Extract numeric value of string
  /// Example: OTP 12312 27/04/2020 => 1231227042020ß
  /// If firstWordOnly is true, then the example return is "12312"
  /// (first found numeric word)
  static String numericOnly(final String s, {final bool firstWordOnly = false}) {
    var numericOnlyStr = '';

    for (var i = 0; i < s.length; i++) {
      if (isNumericOnly(s[i])) {
        numericOnlyStr += s[i];
      }
      if (firstWordOnly && numericOnlyStr.isNotEmpty && s[i] == ' ') {
        break;
      }
    }

    return numericOnlyStr;
  }

  /// Capitalize only the first letter of each word in a string
  /// Example: getx will make it easy  => Getx Will Make It Easy
  /// Example 2 : this is an example text => This Is An Example Text
  static String capitalizeAllWordsFirstLetter(final String s) {
    final String lowerCasedString = s.toLowerCase();
    final String stringWithoutExtraSpaces = lowerCasedString.trim();

    if (stringWithoutExtraSpaces.isEmpty) {
      return '';
    }
    if (stringWithoutExtraSpaces.length == 1) {
      return stringWithoutExtraSpaces.toUpperCase();
    }

    final List<String> stringWordsList = stringWithoutExtraSpaces.split(' ');
    final List<String> capitalizedWordsFirstLetter = stringWordsList
        .map(
          (final word) {
            if (word.trim().isEmpty) return '';
            return word.trim();
          },
        )
        .where(
          (final word) => word != '',
        )
        .map(
          (final word) {
            if (word.startsWith(RegExp(r'[\n\t\r]'))) {
              return word;
            }
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          },
        )
        .toList();
    final String finalResult = capitalizedWordsFirstLetter.join(' ');
    return finalResult;
  }

  static bool hasMatch(final String? value, final String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  static String createPath(final String path, [final Iterable? segments]) {
    if (segments == null || segments.isEmpty) {
      return path;
    }
    final list = segments.map((final e) => '/$e');
    return path + list.join();
  }

  static void printFunction(
    final String prefix,
    final dynamic value,
    final String info, {
    final bool isError = false,
  }) {
    Get.log('$prefix $value $info'.trim(), isError: isError);
  }
}

typedef PrintFunctionCallback = void Function(
  String prefix,
  dynamic value,
  String info, {
  bool? isError,
});
