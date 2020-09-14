import 'dart:developer';

import '../../../utils.dart';
import '../regex/get_utils.dart';

extension GetDynamicUtils on dynamic {
  /// It's This is overloading the IDE's options. Only the most useful and
  /// popular options will stay here.

  bool get isNull => GetUtils.isNull(this);

  bool get isNullOrBlank => GetUtils.isNullOrBlank(this);
  
  void logError({String info = ''}) =>
      GetUtils.log('Error: ${this.runtimeType}', this, info);

  void logInfo({String info = ''}) =>
      GetUtils.log('Info: ${this.runtimeType}', this, info);
}
