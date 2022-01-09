import '../get_utils/get_utils.dart';

extension GetStringUtils on String {
  /// Discover if the String is a valid number
  bool get isNum => GetUtils.isNum(this);

  /// Discover if the String is numeric only
  bool get isNumericOnly => GetUtils.isNumericOnly(this);

  String numericOnly({bool firstWordOnly = false}) =>
      GetUtils.numericOnly(this, firstWordOnly: firstWordOnly);

  /// Discover if the String is alphanumeric only
  bool get isAlphabetOnly => GetUtils.isAlphabetOnly(this);

  /// Discover if the String is a boolean
  bool get isBool => GetUtils.isBool(this);

  /// Discover if the String is a vector
  bool get isVectorFileName => GetUtils.isVector(this);

  /// Discover if the String is a ImageFileName
  bool get isImageFileName => GetUtils.isImage(this);

  /// Discover if the String is a AudioFileName
  bool get isAudioFileName => GetUtils.isAudio(this);

  /// Discover if the String is a VideoFileName
  bool get isVideoFileName => GetUtils.isVideo(this);

  /// Discover if the String is a TxtFileName
  bool get isTxtFileName => GetUtils.isTxt(this);

  /// Discover if the String is a Document Word
  bool get isDocumentFileName => GetUtils.isWord(this);

  /// Discover if the String is a Document Excel
  bool get isExcelFileName => GetUtils.isExcel(this);

  /// Discover if the String is a Document Powerpoint
  bool get isPPTFileName => GetUtils.isPPT(this);

  /// Discover if the String is a APK File
  bool get isAPKFileName => GetUtils.isAPK(this);

  /// Discover if the String is a PDF file
  bool get isPDFFileName => GetUtils.isPDF(this);

  /// Discover if the String is a HTML file
  bool get isHTMLFileName => GetUtils.isHTML(this);

  /// Discover if the String is a URL file
  bool get isURL => GetUtils.isURL(this);

  /// Discover if the String is a Email
  bool get isEmail => GetUtils.isEmail(this);

  /// Discover if the String is a Phone Number
  bool get isPhoneNumber => GetUtils.isPhoneNumber(this);

  /// Discover if the String is a DateTime
  bool get isDateTime => GetUtils.isDateTime(this);

  /// Discover if the String is a MD5 Hash
  bool get isMD5 => GetUtils.isMD5(this);

  /// Discover if the String is a SHA1 Hash
  bool get isSHA1 => GetUtils.isSHA1(this);

  /// Discover if the String is a SHA256 Hash
  bool get isSHA256 => GetUtils.isSHA256(this);

  /// Discover if the String is a bynary value
  bool get isBinary => GetUtils.isBinary(this);

  /// Discover if the String is a ipv4
  bool get isIPv4 => GetUtils.isIPv4(this);

  bool get isIPv6 => GetUtils.isIPv6(this);

  /// Discover if the String is a Hexadecimal
  bool get isHexadecimal => GetUtils.isHexadecimal(this);

  /// Discover if the String is a palindrom
  bool get isPalindrom => GetUtils.isPalindrom(this);

  /// Discover if the String is a passport number
  bool get isPassport => GetUtils.isPassport(this);

  /// Discover if the String is a currency
  bool get isCurrency => GetUtils.isCurrency(this);

  /// Discover if the String is a CPF number
  bool get isCpf => GetUtils.isCpf(this);

  /// Discover if the String is a CNPJ number
  bool get isCnpj => GetUtils.isCnpj(this);

  /// Discover if the String is a case insensitive
  bool isCaseInsensitiveContains(String b) =>
      GetUtils.isCaseInsensitiveContains(this, b);

  /// Discover if the String is a case sensitive and contains any value
  bool isCaseInsensitiveContainsAny(String b) =>
      GetUtils.isCaseInsensitiveContainsAny(this, b);

  /// capitalize the String
  String? get capitalize => GetUtils.capitalize(this);

  /// Capitalize the first letter of the String
  String? get capitalizeFirst => GetUtils.capitalizeFirst(this);

  /// remove all whitespace from the String
  String get removeAllWhitespace => GetUtils.removeAllWhitespace(this);

  /// converter the String
  String? get camelCase => GetUtils.camelCase(this);

  /// Discover if the String is a valid URL
  String? get paramCase => GetUtils.paramCase(this);

  /// add segments to the String
  String createPath([Iterable? segments]) {
    final path = startsWith('/') ? this : '/$this';
    return GetUtils.createPath(path, segments);
  }
}
