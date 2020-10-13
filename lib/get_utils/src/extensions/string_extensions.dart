import '../get_utils/get_utils.dart';

extension GetStringUtils on String {
  bool get isNum => GetUtils.isNum(this);

  bool get isNumericOnly => GetUtils.isNumericOnly(this);

  bool get isAlphabetOnly => GetUtils.isAlphabetOnly(this);

  bool get isBool => GetUtils.isBool(this);

  bool get isVectorFileName => GetUtils.isVector(this);

  bool get isImageFileName => GetUtils.isImage(this);

  bool get isAudioFileName => GetUtils.isAudio(this);

  bool get isVideoFileName => GetUtils.isVideo(this);

  bool get isTxtFileName => GetUtils.isTxt(this);

  bool get isDocumentFileName => GetUtils.isWord(this);

  bool get isExcelFileName => GetUtils.isExcel(this);

  bool get isPPTFileName => GetUtils.isPPT(this);

  bool get isAPKFileName => GetUtils.isAPK(this);

  bool get isPDFFileName => GetUtils.isPDF(this);

  bool get isHTMLFileName => GetUtils.isHTML(this);

  bool get isURL => GetUtils.isURL(this);

  bool get isEmail => GetUtils.isEmail(this);

  bool get isPhoneNumber => GetUtils.isPhoneNumber(this);

  bool get isDateTime => GetUtils.isDateTime(this);

  bool get isMD5 => GetUtils.isMD5(this);

  bool get isSHA1 => GetUtils.isSHA1(this);

  bool get isSHA256 => GetUtils.isSHA256(this);

  bool get isBinary => GetUtils.isBinary(this);

  bool get isIPv4 => GetUtils.isIPv4(this);

  bool get isIPv6 => GetUtils.isIPv6(this);

  bool get isHexadecimal => GetUtils.isHexadecimal(this);

  bool get isPalindrom => GetUtils.isPalindrom(this);

  bool get isPassport => GetUtils.isPassport(this);

  bool get isCurrency => GetUtils.isCurrency(this);

  bool get isCpf => GetUtils.isCpf(this);

  bool get isCnpj => GetUtils.isCnpj(this);

  bool isCaseInsensitiveContains(String b) =>
      GetUtils.isCaseInsensitiveContains(this, b);

  bool isCaseInsensitiveContainsAny(String b) =>
      GetUtils.isCaseInsensitiveContainsAny(this, b);

  String get capitalize => GetUtils.capitalize(this);

  String get capitalizeFirst => GetUtils.capitalizeFirst(this);

  String get removeAllWhitespace => GetUtils.removeAllWhitespace(this);

  String get camelCase => GetUtils.camelCase(this);

  String numericOnly({bool firstWordOnly = false}) =>
      GetUtils.numericOnly(this, firstWordOnly: firstWordOnly);
}
