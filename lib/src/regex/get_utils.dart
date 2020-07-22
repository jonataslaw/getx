import 'package:get/src/regex/regex.dart';

class GetUtils {
  /// Checks if data is null.
  static bool isNull(dynamic s) => s == null;

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool isNullOrBlank(dynamic s) {
    if (isNull(s)) return true;
    switch (s.runtimeType) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return s.isEmpty;
        break;
      default:
        return s.toString() == 'null' || s.toString().trim().isEmpty;
    }
  }

  /// Checks if string is int or double.
  static bool isNum(String s) {
    if (isNull(s)) return false;
    return num.tryParse(s) is num ?? false;
  }

  /// Checks if string consist only numeric.
  /// Numeric only doesnt accepting "." which double data type have
  static bool isNumericOnly(String s) =>
      RegexValidation.hasMatch(s, regex.numericOnly);

  /// Checks if string consist only Alphabet. (No Whitespace)
  static bool isAlphabetOnly(String s) =>
      RegexValidation.hasMatch(s, regex.alphabetOnly);

  /// Checks if string is boolean.
  static bool isBool(String s) {
    if (isNull(s)) return false;
    return (s == 'true' || s == 'false');
  }

  /// Checks if string is an vector file.
  static bool isVector(String s) => RegexValidation.hasMatch(s, regex.vector);

  /// Checks if string is an image file.
  static bool isImage(String s) => RegexValidation.hasMatch(s, regex.image);

  /// Checks if string is an audio file.
  static bool isAudio(String s) => RegexValidation.hasMatch(s, regex.audio);

  /// Checks if string is an video file.
  static bool isVideo(String s) => RegexValidation.hasMatch(s, regex.video);

  /// Checks if string is an txt file.
  static bool isTxt(String s) => RegexValidation.hasMatch(s, regex.txt);

  /// Checks if string is an Doc file.
  static bool isDocument(String s) => RegexValidation.hasMatch(s, regex.doc);

  /// Checks if string is an Excel file.
  static bool isExcel(String s) => RegexValidation.hasMatch(s, regex.excel);

  /// Checks if string is an PPT file.
  static bool isPPT(String s) => RegexValidation.hasMatch(s, regex.ppt);

  /// Checks if string is an APK file.
  static bool isAPK(String s) => RegexValidation.hasMatch(s, regex.apk);

  /// Checks if string is an video file.
  static bool isPDF(String s) => RegexValidation.hasMatch(s, regex.pdf);

  /// Checks if string is an HTML file.
  static bool isHTML(String s) => RegexValidation.hasMatch(s, regex.html);

  /// Checks if string is URL.
  static bool isURL(String s) => RegexValidation.hasMatch(s, regex.url);

  /// Checks if string is email.
  static bool isEmail(String s) => RegexValidation.hasMatch(s, regex.email);

  /// Checks if string is phone number.
  static bool isPhoneNumber(String s) =>
      RegexValidation.hasMatch(s, regex.phone);

  /// Checks if string is DateTime (UTC or Iso8601).
  static bool isDateTime(String s) =>
      RegexValidation.hasMatch(s, regex.basicDateTime);

  /// Checks if string is MD5 hash.
  static bool isMD5(String s) => RegexValidation.hasMatch(s, regex.md5);

  /// Checks if string is SHA1 hash.
  static bool isSHA1(String s) => RegexValidation.hasMatch(s, regex.sha1);

  /// Checks if string is SHA256 hash.
  static bool isSHA256(String s) => RegexValidation.hasMatch(s, regex.sha256);

  /// Checks if string is ISBN 10 or 13.
  static bool isISBN(String s) => RegexValidation.hasMatch(s, regex.isbn);

  /// Checks if string is SSN (Social Security Number).
  static bool isSSN(String s) => RegexValidation.hasMatch(s, regex.ssn);

  /// Checks if string is binary.
  static bool isBinary(String s) => RegexValidation.hasMatch(s, regex.binary);

  /// Checks if string is IPv4.
  static bool isIPv4(String s) => RegexValidation.hasMatch(s, regex.ipv4);

  /// Checks if string is IPv6.
  static bool isIPv6(String s) => RegexValidation.hasMatch(s, regex.ipv6);

  /// Checks if string is hexadecimal.
  /// Example: HexColor => #12F
  static bool isHexadecimal(String s) =>
      RegexValidation.hasMatch(s, regex.hexadecimal);

  /// Checks if string is Palindrom.
  static bool isPalindrom(String s) {
    bool isPalindrom = true;
    for (var i = 0; i < s.length; i++) {
      if (s[i] != s[s.length - i - 1]) isPalindrom = false;
    }
    return isPalindrom;
  }

  /// Checks if all data have same value.
  /// Example: 111111 -> true, wwwww -> true, [1,1,1,1] -> true
  static bool isOneAKind(dynamic s) {
    if ((s is String || s is List) && !isNullOrBlank(s)) {
      var first = s[0];
      var isOneAKind = true;
      for (var i = 0; i < s.length; i++) {
        if (s[i] != first) isOneAKind = false;
      }
      return isOneAKind;
    }
    if (s is int) {
      String value = s.toString();
      var first = value[0];
      var isOneAKind = true;
      for (var i = 0; i < value.length; i++) {
        if (value[i] != first) isOneAKind = false;
      }
      return isOneAKind;
    }
    return false;
  }

  /// Checks if string is Passport No.
  static bool isPassport(String s) =>
      RegexValidation.hasMatch(s, regex.passport);

  /// Checks if string is Currency.
  static bool isCurrency(String s) =>
      RegexValidation.hasMatch(s, regex.currency);

  /// Checks if length of data is LOWER than maxLength.
  static bool isLengthLowerThan(dynamic s, int maxLength) {
    if (isNull(s)) return (maxLength <= 0) ? true : false;
    switch (s.runtimeType) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return s.length < maxLength;
        break;
      case int:
        return s.toString().length < maxLength;
        break;
      case double:
        return s.toString().replaceAll('.', '').length < maxLength;
        break;
      default:
        return false;
    }
  }

  /// Checks if length of data is GREATER than maxLength.
  static bool isLengthGreaterThan(dynamic s, int maxLength) {
    if (isNull(s)) return false;
    switch (s.runtimeType) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return s.length > maxLength;
        break;
      case int:
        return s.toString().length > maxLength;
        break;
      case double:
        return s.toString().replaceAll('.', '').length > maxLength;
        break;
      default:
        return false;
    }
  }

  /// Checks if length of data is GREATER OR EQUAL to maxLength.
  static bool isLengthGreaterOrEqual(dynamic s, int maxLength) {
    if (isNull(s)) return false;
    switch (s.runtimeType) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return s.length >= maxLength;
        break;
      case int:
        return s.toString().length >= maxLength;
        break;
      case double:
        return s.toString().replaceAll('.', '').length >= maxLength;
        break;
      default:
        return false;
    }
  }

  /// Checks if length of data is LOWER OR EQUAL to maxLength.
  static bool isLengthLowerOrEqual(dynamic s, int maxLength) {
    if (isNull(s)) return false;
    switch (s.runtimeType) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return s.length <= maxLength;
        break;
      case int:
        return s.toString().length <= maxLength;
        break;
      case double:
        return s.toString().replaceAll('.', '').length <= maxLength;
      default:
        return false;
    }
  }

  /// Checks if length of data is EQUAL to maxLength.
  static bool isLengthEqualTo(dynamic s, int maxLength) {
    if (isNull(s)) return false;
    switch (s.runtimeType) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return s.length == maxLength;
        break;
      case int:
        return s.toString().length == maxLength;
        break;
      case double:
        return s.toString().replaceAll('.', '').length == maxLength;
        break;
      default:
        return false;
    }
  }

  /// Checks if length of data is BETWEEN minLength to maxLength.
  static bool isLengthBetween(dynamic s, int minLength, int maxLength) {
    if (isNull(s)) return false;
    return isLengthGreaterOrEqual(s, minLength) &&
        isLengthLowerOrEqual(s, maxLength);
  }

  /// Checks if a contains b (Treating or interpreting upper- and lowercase letters as being the same).
  static bool isCaseInsensitiveContains(String a, String b) =>
      a.toLowerCase().contains(b.toLowerCase());

  /// Checks if a contains b or b contains a (Treating or interpreting upper- and lowercase letters as being the same).
  static bool isCaseInsensitiveContainsAny(String a, String b) {
    String lowA = a.toLowerCase();
    String lowB = b.toLowerCase();
    return lowA.contains(lowB) || lowB.contains(lowA);
  }

  /// Checks if num a LOWER than num b.
  static bool isLowerThan(num a, num b) => a < b;

  /// Checks if num a GREATER than num b.
  static bool isGreaterThan(num a, num b) => a > b;

  /// Checks if num a EQUAL than num b.
  static bool isEqual(num a, num b) => a == b;

  //Check if num is a cnpj
  static bool isCnpj(String cnpj) {
    if (cnpj == null) return false;

    // Obter somente os números do CNPJ
    var numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CNPJ possui 14 dígitos
    if (numbers.length != 14) return false;

    // Testar se todos os dígitos do CNPJ são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return false;

    // Dividir dígitos
    List<int> digits =
        numbers.split('').map((String d) => int.parse(d)).toList();

    // Calcular o primeiro dígito verificador
    var calcDv1 = 0;
    var j = 0;
    for (var i in Iterable<int>.generate(12, (i) => i < 4 ? 5 - i : 13 - i)) {
      calcDv1 += digits[j++] * i;
    }
    calcDv1 %= 11;
    var dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Testar o primeiro dígito verificado
    if (digits[12] != dv1) return false;

    // Calcular o segundo dígito verificador
    var calcDv2 = 0;
    j = 0;
    for (var i in Iterable<int>.generate(13, (i) => i < 5 ? 6 - i : 14 - i)) {
      calcDv2 += digits[j++] * i;
    }
    calcDv2 %= 11;
    var dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Testar o segundo dígito verificador
    if (digits[13] != dv2) return false;

    return true;
  }

  /// Checks if the cpf is valid.
  static bool isCpf(String cpf) {
    if (cpf == null) return false;

    // get only the numbers
    var numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    // Test if the CPF has 11 digits
    if (numbers.length != 11) return false;
    // Test if all CPF digits are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return false;

    // split the digits
    List<int> digits =
        numbers.split('').map((String d) => int.parse(d)).toList();

    // Calculate the first verifier digit
    var calcDv1 = 0;
    for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
      calcDv1 += digits[10 - i] * i;
    }
    calcDv1 %= 11;
    var dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Tests the first verifier digit
    if (digits[9] != dv1) return false;

    // Calculate the second verifier digit
    var calcDv2 = 0;
    for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
      calcDv2 += digits[11 - i] * i;
    }
    calcDv2 %= 11;

    var dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Test the second verifier digit
    if (digits[10] != dv2) return false;

    return true;
  }

  /// Capitalize each word inside string
  /// Example: your name => Your Name, your name => Your name
  ///
  /// If First Only is `true`, the only letter get uppercase is the first letter
  static String capitalize(String s, {bool firstOnly = false}) {
    if (isNullOrBlank(s)) return null;
    if (firstOnly) return capitalizeFirst(s);

    List lst = s.split(' ');
    String newStr = '';
    for (var s in lst) newStr += capitalizeFirst(s);
    return newStr;
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  static String capitalizeFirst(String s) {
    if (isNullOrBlank(s)) return null;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Remove all whitespace inside string
  /// Example: your name => yourname
  static String removeAllWhitespace(String s) {
    if (isNullOrBlank(s)) return null;
    return s.replaceAll(' ', '');
  }

  /// Camelcase string
  /// Example: your name => yourName
  static String camelCase(String s) {
    if (isNullOrBlank(s)) return null;
    return s[0].toLowerCase() + removeAllWhitespace(capitalize(s)).substring(1);
  }

  /// Extract numeric value of string
  /// Example: OTP 12312 27/04/2020 => 1231227042020ß
  /// If firstword only is true, then the example return is "12312" (first found numeric word)
  static String numericOnly(String s, {bool firstWordOnly = false}) {
    String numericOnlyStr = '';
    for (var i = 0; i < s.length; i++) {
      if (isNumericOnly(s[i])) numericOnlyStr += s[i];
      if (firstWordOnly && numericOnlyStr.isNotEmpty && s[i] == " ") break;
    }
    return numericOnlyStr;
  }

  static Regex regex = Regex();
}

class RegexValidation {
  /// Returns whether the pattern has a match in the string [input].
  static bool hasMatch(String s, Pattern p) =>
      (s == null) ? false : RegExp(p).hasMatch(s);
}
