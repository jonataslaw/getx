import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('timestamp test', () async {
    /// Date and time (GMT): Friday, July 15, 2022 6:24:54 PM
    var utcDate = DateTime.utc(2022, 7, 15, 18, 24, 54);
    expect(utcDate.unixTimeStamp == 1657909494, true);

    ///Date and time (your time zone): Friday, July 15, 2022 6:24:54 PM GMT+06:00
    var localDate = DateTime(2022, 7, 15, 18, 24, 54);
    expect(localDate.unixTimeStamp == 1657887894, true);
  });

  test('from unix timestamp test', () {
    var now = DateTime(2022, 07, 18) + 1.days;
    expect(now.weekday == 2, true);
    expect(now.unixTimeStamp.fromUnixTimeStamp == now, true);
  });
}
