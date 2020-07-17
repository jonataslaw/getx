import '../../utils.dart';

extension GetDynamicUtils on dynamic {
  bool get isNull => GetUtils.isNull(this);
  bool get isNullOrBlank => GetUtils.isNullOrBlank(this);
  bool get isOneAKind => GetUtils.isOneAKind(this);
  bool isLengthLowerThan(int maxLength) =>
      GetUtils.isLengthLowerThan(this, maxLength);
  bool isLengthGreaterThan(int maxLength) =>
      GetUtils.isLengthGreaterThan(this, maxLength);
  bool isLengthGreaterOrEqual(int maxLength) =>
      GetUtils.isLengthGreaterOrEqual(this, maxLength);
  bool isLengthLowerOrEqual(int maxLength) =>
      GetUtils.isLengthLowerOrEqual(this, maxLength);
  bool isLengthEqualTo(int maxLength) =>
      GetUtils.isLengthEqualTo(this, maxLength);
  bool isLengthBetween(int minLength, int maxLength) =>
      GetUtils.isLengthBetween(this, minLength, maxLength);
}
