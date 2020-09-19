part of 'rx_impl.dart';

/// Base Rx class for all num Rx's.
class _BaseRxNum<T extends num> extends _RxImpl<T> {
  /// Addition operator. */

  /// Multiplication operator.
  num operator *(num other) => value * other;

  /// Euclidean modulo operator.
  ///
  /// Returns the remainder of the Euclidean division. The Euclidean division of
  /// two integers `a` and `b` yields two integers `q` and `r` such that
  /// `a == b * q + r` and `0 <= r < b.abs()`.
  ///
  /// The Euclidean division is only defined for integers, but can be easily
  /// extended to work with doubles. In that case `r` may have a non-integer
  /// value, but it still verifies `0 <= r < |b|`.
  ///
  /// The sign of the returned value `r` is always positive.
  ///
  /// See [remainder] for the remainder of the truncating division.
  num operator %(num other) => value % other;

  /// Division operator.
  double operator /(num other) => value / other;

  /// Truncating division operator.
  ///
  /// If either operand is a [double] then the result of the truncating division
  /// `a ~/ b` is equivalent to `(a / b).truncate().toInt()`.
  ///
  /// If both operands are [int]s then `a ~/ b` performs the truncating
  /// integer division.
  int operator ~/(num other) => value ~/ other;

  /// Negate operator.
  num operator -() => -value;

  /// Returns the remainder of the truncating division of `this` by [other].
  ///
  /// The result `r` of this operation satisfies:
  /// `this == (this ~/ other) * other + r`.
  /// As a consequence the remainder `r` has the same sign as the divider
  /// `this`.
  num remainder(num other) => value.remainder(other);

  /// Relational less than operator.
  bool operator <(num other) => value < other;

  /// Relational less than or equal operator.
  bool operator <=(num other) => value <= other;

  /// Relational greater than operator.
  bool operator >(num other) => value > other;

  /// Relational greater than or equal operator.
  bool operator >=(num other) => value >= other;

  /// True if the number is the double Not-a-Number value; otherwise, false.
  bool get isNaN => value.isNaN;

  /// True if the number is negative; otherwise, false.
  ///
  /// Negative numbers are those less than zero, and the double `-0.0`.
  bool get isNegative => value.isNegative;

  /// True if the number is positive infinity or negative infinity; otherwise,
  /// false.
  bool get isInfinite => value.isInfinite;

  /// True if the number is finite; otherwise, false.
  ///
  /// The only non-finite numbers are NaN, positive infinity, and
  /// negative infinity.
  bool get isFinite => value.isFinite;

  /// Returns the absolute value of this [num].
  num abs() => value.abs();

  /// Returns minus one, zero or plus one depending on the sign and
  /// numerical value of the number.
  ///
  /// Returns minus one if the number is less than zero,
  /// plus one if the number is greater than zero,
  /// and zero if the number is equal to zero.
  ///
  /// Returns NaN if the number is the double NaN value.
  ///
  /// Returns a number of the same type as this number.
  /// For doubles, `-0.0.sign == -0.0`.
  /// The result satisfies:
  ///
  ///     n == n.sign * n.abs()
  ///
  /// for all numbers `n` (except NaN, because NaN isn't `==` to itself).
  num get sign => value.sign;

  /// Returns the integer closest to `this`.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int round() => value.round();

  /// Returns the greatest integer no greater than `this`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int floor() => value.floor();

  /// Returns the least integer no smaller than `this`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int ceil() => value.ceil();

  /// Returns the integer obtained by discarding any fractional
  /// digits from `this`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int truncate() => value.truncate();

  /// Returns the double integer value closest to `this`.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).roundToDouble() == 4` and `(-3.5).roundToDouble() == -4`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is a
  /// non-finite double value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`,
  /// and `-0.0` is therefore considered closer to negative numbers than `0.0`.
  /// This means that for a value, `d` in the range `-0.5 < d < 0.0`,
  /// the result is `-0.0`.
  ///
  /// The result is always a double.
  /// If this is a numerically large integer, the result may be an infinite
  /// double.
  double roundToDouble() => value.roundToDouble();

  /// Returns the greatest double integer value no greater than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is a
  /// non-finite double value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `0.0 < d < 1.0` will return `0.0`.
  ///
  /// The result is always a double.
  /// If this is a numerically large integer, the result may be an infinite
  /// double.
  double floorToDouble() => value.floorToDouble();

  /// Returns the least double integer value no smaller than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is a
  /// non-finite double value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`.
  ///
  /// The result is always a double.
  /// If this is a numerically large integer, the result may be an infinite
  /// double.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns the double integer value obtained by discarding any fractional
  /// digits from the double value of `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is a
  /// non-finite double value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`, and
  /// in the range `0.0 < d < 1.0` it will return 0.0.
  ///
  /// The result is always a double.
  /// If this is a numerically large integer, the result may be an infinite
  /// double.
  double truncateToDouble() => value.truncateToDouble();

  /// Returns this [num] clamped to be in the range [lowerLimit]-[upperLimit].
  ///
  /// The comparison is done using [compareTo] and therefore takes `-0.0` into
  /// account. This also implies that [double.nan] is treated as the maximal
  /// double value.
  ///
  /// The arguments [lowerLimit] and [upperLimit] must form a valid range where
  /// `lowerLimit.compareTo(upperLimit) <= 0`.
  num clamp(num lowerLimit, num upperLimit) =>
      value.clamp(lowerLimit, upperLimit);

  /// Truncates this [num] to an integer and returns the result as an [int]. */
  int toInt() => value.toInt();

  /// Return this [num] as a [double].
  ///
  /// If the number is not representable as a [double], an
  /// approximation is returned. For numerically large integers, the
  /// approximation may be infinite.
  double toDouble() => value.toDouble();

  /// Returns a decimal-point string-representation of `this`.
  ///
  /// Converts `this` to a [double] before computing the string representation.
  ///
  /// If the absolute value of `this` is greater or equal to `10^21` then this
  /// methods returns an exponential representation computed by
  /// `this.toStringAsExponential()`. Otherwise the result
  /// is the closest string representation with exactly [fractionDigits] digits
  /// after the decimal point. If [fractionDigits] equals 0 then the decimal
  /// point is omitted.
  ///
  /// The parameter [fractionDigits] must be an integer satisfying:
  /// `0 <= fractionDigits <= 20`.
  ///
  /// Examples:
  ///
  ///     1.toStringAsFixed(3);  // 1.000
  ///     (4321.12345678).toStringAsFixed(3);  // 4321.123
  ///     (4321.12345678).toStringAsFixed(5);  // 4321.12346
  ///     123456789012345.toStringAsFixed(3);  // 123456789012345.000
  ///     10000000000000000.toStringAsFixed(4); // 10000000000000000.0000
  ///     5.25.toStringAsFixed(0); // 5
  String toStringAsFixed(int fractionDigits) =>
      value.toStringAsFixed(fractionDigits);

  /// Returns an exponential string-representation of `this`.
  ///
  /// Converts `this` to a [double] before computing the string representation.
  ///
  /// If [fractionDigits] is given then it must be an integer satisfying:
  /// `0 <= fractionDigits <= 20`. In this case the string contains exactly
  /// [fractionDigits] after the decimal point. Otherwise, without the
  /// parameter, the returned string uses the shortest number of digits that
  /// accurately represent [this].
  ///
  /// If [fractionDigits] equals 0 then the decimal point is omitted.
  /// Examples:
  ///
  ///     1.toStringAsExponential();       // 1e+0
  ///     1.toStringAsExponential(3);      // 1.000e+0
  ///     123456.toStringAsExponential();  // 1.23456e+5
  ///     123456.toStringAsExponential(3); // 1.235e+5
  ///     123.toStringAsExponential(0);    // 1e+2
  String toStringAsExponential([int fractionDigits]) =>
      value.toStringAsExponential(fractionDigits);

  /// Converts `this` to a double and returns a string representation with
  /// exactly [precision] significant digits.
  ///
  /// The parameter [precision] must be an integer satisfying:
  /// `1 <= precision <= 21`.
  ///
  /// Examples:
  ///
  ///     1.toStringAsPrecision(2);       // 1.0
  ///     1e15.toStringAsPrecision(3);    // 1.00e+15
  ///     1234567.toStringAsPrecision(3); // 1.23e+6
  ///     1234567.toStringAsPrecision(9); // 1234567.00
  ///     12345678901234567890.toStringAsPrecision(20); // 12345678901234567168
  ///     12345678901234567890.toStringAsPrecision(14); // 1.2345678901235e+19
  ///     0.00000012345.toStringAsPrecision(15); // 1.23450000000000e-7
  ///     0.0000012345.toStringAsPrecision(15);  // 0.00000123450000000000
  String toStringAsPrecision(int precision) =>
      value.toStringAsPrecision(precision);
}

class RxNum extends _BaseRxNum<num> {
  num operator +(num other) {
    value += other;
    return value;
  }

  /// Subtraction operator.
  num operator -(num other) {
    value -= other;
    return value;
  }
}

class RxDouble extends _BaseRxNum<double> {
  RxDouble([double initial]) {
    value = initial;
  }

  /// Addition operator.
  RxDouble operator +(num other) {
    value += other;
    return this;
  }

  /// Subtraction operator.
  RxDouble operator -(num other) {
    value -= other;
    return this;
  }

  /// Multiplication operator.
  double operator *(num other) => value * other;

  double operator %(num other) => value % other;

  /// Division operator.
  double operator /(num other) => value / other;

  /// Truncating division operator.
  ///
  /// The result of the truncating division `a ~/ b` is equivalent to
  /// `(a / b).truncate()`.
  int operator ~/(num other) => value ~/ other;

  /// Negate operator. */
  double operator -() => -value;

  /// Returns the absolute value of this [double].
  double abs() => value.abs();

  /// Returns the sign of the double's numerical value.
  ///
  /// Returns -1.0 if the value is less than zero,
  /// +1.0 if the value is greater than zero,
  /// and the value itself if it is -0.0, 0.0 or NaN.
  double get sign => value.sign;

  /// Returns the integer closest to `this`.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int round() => value.round();

  /// Returns the greatest integer no greater than `this`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int floor() => value.floor();

  /// Returns the least integer no smaller than `this`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int ceil() => value.ceil();

  /// Returns the integer obtained by discarding any fractional
  /// digits from `this`.
  ///
  /// If `this` is not finite (`NaN` or infinity), throws an [UnsupportedError].
  int truncate() => value.truncate();

  /// Returns the integer double value closest to `this`.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).roundToDouble() == 4` and `(-3.5).roundToDouble() == -4`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is
  /// not a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`,
  /// and `-0.0` is therefore considered closer to negative numbers than `0.0`.
  /// This means that for a value, `d` in the range `-0.5 < d < 0.0`,
  /// the result is `-0.0`.
  double roundToDouble() => value.roundToDouble();

  /// Returns the greatest integer double value no greater than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is
  /// not a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `0.0 < d < 1.0` will return `0.0`.
  double floorToDouble() => value.floorToDouble();

  /// Returns the least integer double value no smaller than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is
  /// not a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns the integer double value obtained by discarding any fractional
  /// digits from `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is
  /// not a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`, and
  /// in the range `0.0 < d < 1.0` it will return 0.0.
  double truncateToDouble() => value.truncateToDouble();
}

class RxInt extends _BaseRxNum<int> {
  RxInt([int initial]) {
    value = initial;
  }

  /// Addition operator.
  RxInt operator +(int other) {
    value += other;
    return this;
  }

  /// Subtraction operator.
  RxInt operator -(int other) {
    value -= other;
    return this;
  }

  /// Bit-wise and operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with only the bits set that are set in
  /// both `this` and [other]
  ///
  /// If both operands are negative, the result is negative, otherwise
  /// the result is non-negative.
  int operator &(int other) => value & other;

  /// Bit-wise or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in either
  /// of `this` and [other]
  ///
  /// If both operands are non-negative, the result is non-negative,
  /// otherwise the result is negative.
  int operator |(int other) => value | other;

  /// Bit-wise exclusive-or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in one,
  /// but not both, of `this` and [other]
  ///
  /// If the operands have the same sign, the result is non-negative,
  /// otherwise the result is negative.
  int operator ^(int other) => value ^ other;

  /// The bit-wise negate operator.
  ///
  /// Treating `this` as a sufficiently large two's component integer,
  /// the result is a number with the opposite bits set.
  ///
  /// This maps any integer `x` to `-x - 1`.
  int operator ~() => ~value;

  /// Shift the bits of this integer to the left by [shiftAmount].
  ///
  /// Shifting to the left makes the number larger, effectively multiplying
  /// the number by `pow(2, shiftIndex)`.
  ///
  /// There is no limit on the size of the result. It may be relevant to
  /// limit intermediate values by using the "and" operator with a suitable
  /// mask.
  ///
  /// It is an error if [shiftAmount] is negative.
  int operator <<(int shiftAmount) => value << shiftAmount;

  /// Shift the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  ///`pow(2, shiftIndex)`.
  ///
  /// It is an error if [shiftAmount] is negative.
  int operator >>(int shiftAmount) => value >> shiftAmount;

  /// Returns this integer to the power of [exponent] modulo [modulus].
  ///
  /// The [exponent] must be non-negative and [modulus] must be
  /// positive.
  int modPow(int exponent, int modulus) => value.modPow(exponent, modulus);

  /// Returns the modular multiplicative inverse of this integer
  /// modulo [modulus].
  ///
  /// The [modulus] must be positive.
  ///
  /// It is an error if no modular inverse exists.
  int modInverse(int modulus) => value.modInverse(modulus);

  /// Returns the greatest common divisor of this integer and [other].
  ///
  /// If either number is non-zero, the result is the numerically greatest
  /// integer dividing both `this` and `other`.
  ///
  /// The greatest common divisor is independent of the order,
  /// so `x.gcd(y)` is  always the same as `y.gcd(x)`.
  ///
  /// For any integer `x`, `x.gcd(x)` is `x.abs()`.
  ///
  /// If both `this` and `other` is zero, the result is also zero.
  int gcd(int other) => value.gcd(other);

  /// Returns true if and only if this integer is even.
  bool get isEven => value.isEven;

  /// Returns true if and only if this integer is odd.
  bool get isOdd => value.isOdd;

  /// Returns the minimum number of bits required to store this integer.
  ///
  /// The number of bits excludes the sign bit, which gives the natural length
  /// for non-negative (unsigned) values.  Negative values are complemented to
  /// return the bit position of the first bit that differs from the sign bit.
  ///
  /// To find the number of bits needed to store the value as a signed value,
  /// add one, i.e. use `x.bitLength + 1`.
  /// ```
  /// x.bitLength == (-x-1).bitLength
  ///
  /// 3.bitLength == 2;     // 00000011
  /// 2.bitLength == 2;     // 00000010
  /// 1.bitLength == 1;     // 00000001
  /// 0.bitLength == 0;     // 00000000
  /// (-1).bitLength == 0;  // 11111111
  /// (-2).bitLength == 1;  // 11111110
  /// (-3).bitLength == 2;  // 11111101
  /// (-4).bitLength == 2;  // 11111100
  /// ```
  int get bitLength => value.bitLength;

  /// Returns the least significant [width] bits of this integer as a
  /// non-negative number (i.e. unsigned representation).  The returned value
  /// has zeros in all bit positions higher than [width].
  /// ```
  /// (-1).toUnsigned(5) == 31   // 11111111  ->  00011111
  /// ```
  /// This operation can be used to simulate arithmetic from low level
  /// languages.
  /// For example, to increment an 8 bit quantity:
  /// ```
  /// q = (q + 1).toUnsigned(8);
  /// ```
  /// `q` will count from `0` up to `255` and then wrap around to `0`.
  ///
  /// If the input fits in [width] bits without truncation, the result is the
  /// same as the input.  The minimum width needed to avoid truncation of `x` is
  /// given by `x.bitLength`, i.e.
  /// ```
  /// x == x.toUnsigned(x.bitLength);
  /// ```
  int toUnsigned(int width) => value.toUnsigned(width);

  /// Returns the least significant [width] bits of this integer, extending the
  /// highest retained bit to the sign.  This is the same as truncating the
  /// value to fit in [width] bits using an signed 2-s complement
  /// representation.
  /// The returned value has the same bit value in all positions higher than
  /// [width].
  ///
  /// ```
  ///                                V--sign bit-V
  /// 16.toSigned(5) == -16   //  00010000 -> 11110000
  /// 239.toSigned(5) == 15   //  11101111 -> 00001111
  ///                                ^           ^
  /// ```
  /// This operation can be used to simulate arithmetic from low level
  /// languages.
  /// For example, to increment an 8 bit signed quantity:
  /// ```
  /// q = (q + 1).toSigned(8);
  /// ```
  /// `q` will count from `0` up to `127`, wrap to `-128` and count back up to
  /// `127`.
  ///
  /// If the input value fits in [width] bits without truncation, the result is
  /// the same as the input.  The minimum width needed to avoid truncation
  /// of `x` is `x.bitLength + 1`, i.e.
  /// ```
  /// x == x.toSigned(x.bitLength + 1);
  /// ```
  int toSigned(int width) => value.toSigned(width);

  /// Return the negative value of this integer.
  ///
  /// The result of negating an integer always has the opposite sign, except
  /// for zero, which is its own negation.
  int operator -() => -value;

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `x`, the result is the same as `x < 0 ? -x : x`.
  int abs() => value.abs();

  /// Returns the sign of this integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and
  /// +1 for values greater than zero.
  int get sign => value.sign;

  /// Returns `this`.
  int round() => value.round();

  /// Returns `this`.
  int floor() => value.floor();

  /// Returns `this`.
  int ceil() => value.ceil();

  /// Returns `this`.
  int truncate() => value.truncate();

  /// Returns `this.toDouble()`.
  double roundToDouble() => value.roundToDouble();

  /// Returns `this.toDouble()`.
  double floorToDouble() => value.floorToDouble();

  /// Returns `this.toDouble()`.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns `this.toDouble()`.
  double truncateToDouble() => value.truncateToDouble();
}
