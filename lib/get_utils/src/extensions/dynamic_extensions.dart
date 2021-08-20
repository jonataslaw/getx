import '../get_utils/get_utils.dart';

extension GetDynamicUtils on dynamic {
  @Deprecated('isNull is deprecated and cannot be used, use "==" operator')
  bool get isNull => GetUtils.isNull(this);

  bool? get isBlank => GetUtils.isBlank(this);

  @Deprecated(
      'isNullOrBlank is deprecated and cannot be used, use "isBlank" instead')
  bool? get isNullOrBlank => GetUtils.isNullOrBlank(this);

  void printError(
          {String info = '', Function logFunction = GetUtils.printFunction}) =>
      // ignore: unnecessary_this
      logFunction('Error: ${this.runtimeType}', this, info, isError: true);

  void printInfo(
          {String info = '',
          Function printFunction = GetUtils.printFunction}) =>
      // ignore: unnecessary_this
      printFunction('Info: ${this.runtimeType}', this, info);
}
