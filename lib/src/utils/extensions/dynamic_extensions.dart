import '../../../utils.dart';
import '../regex/get_utils.dart';

extension GetDynamicUtils on dynamic {
  bool get isNull => GetUtils.isNull(this);

  bool get isNullOrBlank => GetUtils.isNullOrBlank(this);

  void printError(
          {String info = '', Function logFunction = GetUtils.printFunction}) =>
      logFunction('Error: ${this.runtimeType}', this, info, isError: true);

  void printInfo(
          {String info = '',
          Function printFunction = GetUtils.printFunction}) =>
      printFunction('Info: ${this.runtimeType}', this, info);
}
