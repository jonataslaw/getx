import '../regex/get_utils.dart';

extension GetDynamicUtils on dynamic {
  bool get isNull => GetUtils.isNull(this);

  bool get isNullOrBlank => GetUtils.isNullOrBlank(this);
}
