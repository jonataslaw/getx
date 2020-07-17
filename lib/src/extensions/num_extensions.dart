import '../../utils.dart';

extension GetNumUtils on num {
  bool isLowerThan(num b) => GetUtils.isLowerThan(this, b);
  bool isGreaterThan(num b) => GetUtils.isGreaterThan(this, b);
  bool isEqual(num b) => GetUtils.isEqual(this, b);
}
