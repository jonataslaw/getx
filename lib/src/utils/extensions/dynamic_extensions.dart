import '../regex/get_utils.dart';

extension GetDynamicUtils on dynamic {
  /// It's This is overloading the IDE's options. Only the most useful and popular options will stay here.

  /// In dart2js (in flutter v1.17) a var by default is undefined.
  /// *Use this only if you are in version <- 1.17*.
  /// So we assure the null type in json convertions to avoid the "value":value==null?null:value;
  /// someVar.nil will force the null type if the var is null or undefined.
  /// `nil` taken from ObjC just to have a shorter sintax.
  dynamic get nil => GetUtils.nil(this);
  bool get isNull => GetUtils.isNull(this);
  bool get isNullOrBlank => GetUtils.isNullOrBlank(this);

  // bool get isOneAKind => GetUtils.isOneAKind(this);
  // bool isLengthLowerThan(int maxLength) =>
  //     GetUtils.isLengthLowerThan(this, maxLength);
  // bool isLengthGreaterThan(int maxLength) =>
  //     GetUtils.isLengthGreaterThan(this, maxLength);
  // bool isLengthGreaterOrEqual(int maxLength) =>
  //     GetUtils.isLengthGreaterOrEqual(this, maxLength);
  // bool isLengthLowerOrEqual(int maxLength) =>
  //     GetUtils.isLengthLowerOrEqual(this, maxLength);
  // bool isLengthEqualTo(int maxLength) =>
  //     GetUtils.isLengthEqualTo(this, maxLength);
  // bool isLengthBetween(int minLength, int maxLength) =>
  //     GetUtils.isLengthBetween(this, minLength, maxLength);
}
