import '../get_utils/get_utils.dart';

extension GetDynamicUtils on dynamic {
  bool? get isBlank => GetUtils.isBlank(this);

  void printError(
          {final String info = '', final Function logFunction = GetUtils.printFunction}) =>
      // ignore: unnecessary_this
      logFunction('Error: ${this.runtimeType}', this, info, isError: true);

  void printInfo(
          {final String info = '',
          final Function printFunction = GetUtils.printFunction}) =>
      // ignore: unnecessary_this
      printFunction('Info: ${this.runtimeType}', this, info);
}
