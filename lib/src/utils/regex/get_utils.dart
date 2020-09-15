import '../../../get.dart';

class GetUtils {
  /// Checks if data is null.
  static bool isNull(dynamic s) => s == null;

  /// In dart2js (in flutter v1.17) a var by default is undefined.
  /// *Use this only if you are in version <- 1.17*.
  /// So we assure the null type in json convertions to avoid the
  /// "value":value==null?null:value; someVar.nil will force the null type
  /// if the var is null or undefined.
  /// `nil` taken from ObjC just to have a shorter sintax.
  static dynamic nil(dynamic s) => s == null ? null : s;

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool isNullOrBlank(dynamic s) {
    if (isNull(s)) return true;

    if (s is String || s is List || s is Map || s is Set || s is Iterable) {
      return s.isEmpty as bool;
    } else {
      return s.toString() == 'null' || s.toString().trim().isEmpty;
    }
  }

  /// Checks if string is int or double.
  static bool isNum(String s) {
    if (isNull(s)) return false;
    return num.tryParse(s) is num ?? false;
  }

  /// Checks if string consist only numeric.
  /// Numeric only doesn't accepting "." which double data type have
  static bool isNumericOnly(String s) => hasMatch(s, r'^\d+$');

  /// Checks if string consist only Alphabet. (No Whitespace)
  static bool isAlphabetOnly(String s) => hasMatch(s, r'^[a-zA-Z]+$');

  /// Checks if string is boolean.
  static bool isBool(String s) {
    if (isNull(s)) return false;
    return (s == 'true' || s == 'false');
  }

  /// Checks if string is an video file.
  static bool isVideo(String filePath) {
    var ext = filePath.toLowerCase();

    return ext.endsWith(".mp4") ||
        ext.endsWith(".avi") ||
        ext.endsWith(".wmv") ||
        ext.endsWith(".rmvb") ||
        ext.endsWith(".mpg") ||
        ext.endsWith(".mpeg") ||
        ext.endsWith(".3gp");
  }

  /// Checks if string is an image file.
  static bool isImage(String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith(".jpg") ||
        ext.endsWith(".jpeg") ||
        ext.endsWith(".png") ||
        ext.endsWith(".gif") ||
        ext.endsWith(".bmp");
  }

  /// Checks if string is an audio file.
  static bool isAudio(String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith(".mp3") ||
        ext.endsWith(".wav") ||
        ext.endsWith(".wma") ||
        ext.endsWith(".amr") ||
        ext.endsWith(".ogg");
  }

  /// Checks if string is an powerpoint file.
  static bool isPPT(String filePath) {
    final ext = filePath.toLowerCase();
    return ext.endsWith(".ppt") || ext.endsWith(".pptx");
  }

  /// Checks if string is an word file.
  static bool isWord(String filePath) {
    final ext = filePath.toLowerCase();
    return ext.endsWith(".doc") || ext.endsWith(".docx");
  }

  /// Checks if string is an excel file.
  static bool isExcel(String filePath) {
    final ext = filePath.toLowerCase();
    return ext.endsWith(".xls") || ext.endsWith(".xlsx");
  }

  /// Checks if string is an apk file.
  static bool isAPK(String filePath) {
    return filePath.toLowerCase().endsWith(".apk");
  }

  /// Checks if string is an pdf file.
  static bool isPDF(String filePath) {
    return filePath.toLowerCase().endsWith(".pdf");
  }

  /// Checks if string is an txt file.
  static bool isTxt(String filePath) {
    return filePath.toLowerCase().endsWith(".txt");
  }

  /// Checks if string is an chm file.
  static bool isChm(String filePath) {
    return filePath.toLowerCase().endsWith(".chm");
  }

  /// Checks if string is a vector file.
  static bool isVector(String filePath) {
    return filePath.toLowerCase().endsWith(".svg");
  }

  /// Checks if string is an html file.
  static bool isHTML(String filePath) {
    return filePath.toLowerCase().endsWith(".html");
  }

  /// Checks if string is a valid username.
  static bool isUsername(String s) =>
      hasMatch(s, r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$');

  /// Checks if string is URL.
  static bool isURL(String s) => hasMatch(s,
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");

  /// Checks if string is email.
  static bool isEmail(String s) => hasMatch(s,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Checks if string is phone number.
  static bool isPhoneNumber(String s) => hasMatch(s,
      r'^(0|\+|(\+[0-9]{2,4}|\(\+?[0-9]{2,4}\)) ?)([0-9]*|\d{2,4}-\d{2,4}(-\d{2,4})?)$');

  /// Checks if string is DateTime (UTC or Iso8601).
  static bool isDateTime(String s) =>
      hasMatch(s, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$');

  /// Checks if string is MD5 hash.
  static bool isMD5(String s) => hasMatch(s, r'^[a-f0-9]{32}$');

  /// Checks if string is SHA1 hash.
  static bool isSHA1(String s) =>
      hasMatch(s, r'(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})');

  /// Checks if string is SHA256 hash.
  static bool isSHA256(String s) =>
      hasMatch(s, r'([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}');

  /// Checks if string is SSN (Social Security Number).
  static bool isSSN(String s) => hasMatch(s,
      r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$');

  /// Checks if string is binary.
  static bool isBinary(String s) => hasMatch(s, r'^[0-1]*$');

  /// Checks if string is IPv4.
  static bool isIPv4(String s) =>
      hasMatch(s, r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');

  /// Checks if string is IPv6.
  static bool isIPv6(String s) => hasMatch(s,
      r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$');

  /// Checks if string is hexadecimal.
  /// Example: HexColor => #12F
  static bool isHexadecimal(String s) =>
      hasMatch(s, r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  /// Checks if string is Palindrom.
  static bool isPalindrom(String s) {
    var isPalindrom = true;
    for (var i = 0; i < s.length; i++) {
      if (s[i] != s[s.length - i - 1]) {
        isPalindrom = false;
      }
    }
    return isPalindrom;
  }

  /// Checks if all data have same value.
  /// Example: 111111 -> true, wwwww -> true, [1,1,1,1] -> true
  static bool isOneAKind(dynamic s) {
    if ((s is String || s is List) && !isNullOrBlank(s)) {
      var first = s[0];
      var isOneAKind = true;
      var len = s.length as num;
      for (var i = 0; i < len; i++) {
        if (s[i] != first) isOneAKind = false;
      }
      return isOneAKind;
    }

    if (s is int) {
      var value = s.toString();
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
      hasMatch(s, r'^(?!^0+$)[a-zA-Z0-9]{6,9}$');

  /// Checks if string is Currency.
  static bool isCurrency(String s) => hasMatch(s,
      r'^(S?\$|\₩|Rp|\¥|\€|\₹|\₽|fr|R$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]+)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR))?$');

  /// Checks if length of data is LOWER than maxLength.
  static bool isLengthLowerThan(dynamic s, int maxLength) {
    if (isNull(s)) return (maxLength <= 0) ? true : false;
    switch (s.runtimeType as Type) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return (s.length as num) < maxLength;
      case int:
        return s.toString().length < maxLength;
      case double:
        return s.toString().replaceAll('.', '').length < maxLength;
      default:
        return false;
    }
  }

  /// Checks if length of data is GREATER than maxLength.
  static bool isLengthGreaterThan(dynamic s, int maxLength) {
    if (isNull(s)) return false;
    switch (s.runtimeType as Type) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return (s.length as num) > maxLength;
      case int:
        return s.toString().length > maxLength;
      case double:
        return s.toString().replaceAll('.', '').length > maxLength;
      default:
        return false;
    }
  }

  /// Checks if length of data is GREATER OR EQUAL to maxLength.
  static bool isLengthGreaterOrEqual(dynamic s, int maxLength) {
    if (isNull(s)) return false;
    switch (s.runtimeType as Type) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return (s.length as num) >= maxLength;
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
    switch (s.runtimeType as Type) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return (s.length as num) <= maxLength;
      case int:
        return s.toString().length <= maxLength;
      case double:
        return s.toString().replaceAll('.', '').length <= maxLength;
      default:
        return false;
    }
  }

  /// Checks if length of data is EQUAL to maxLength.
  static bool isLengthEqualTo(dynamic s, int maxLength) {
    if (isNull(s)) return false;
    switch (s.runtimeType as Type) {
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

  /// Checks if a contains b (Treating or interpreting upper- and lowercase
  /// letters as being the same).
  static bool isCaseInsensitiveContains(String a, String b) =>
      a.toLowerCase().contains(b.toLowerCase());

  /// Checks if a contains b or b contains a (Treating or
  /// interpreting upper- and lowercase letters as being the same).
  static bool isCaseInsensitiveContainsAny(String a, String b) {
    final lowA = a.toLowerCase();
    final lowB = b.toLowerCase();
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
    var digits = numbers.split('').map(int.parse).toList();

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
    var digits = numbers.split('').map(int.parse).toList();

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

    var lst = s.split(' ');
    var newStr = '';
    for (var s in lst) {
      newStr += capitalizeFirst(s);
    }
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
  /// If firstword only is true, then the example return is "12312"
  /// (first found numeric word)
  static String numericOnly(String s, {bool firstWordOnly = false}) {
    var numericOnlyStr = '';
    for (var i = 0; i < s.length; i++) {
      if (isNumericOnly(s[i])) numericOnlyStr += s[i];
      if (firstWordOnly && numericOnlyStr.isNotEmpty && s[i] == " ") break;
    }
    return numericOnlyStr;
  }

  static bool hasMatch(String value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  static void printFunction(String prefix, dynamic value, String info,
          {bool isError = false}) =>
      GetConfig.log('$prefix $value $info'.trim(), isError: isError);
}
