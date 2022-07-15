import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/src/extensions/date_time_extensions.dart';

void main() {
  test('var.isEqual(value)', () async {
    /// Date and time (GMT): Friday, July 15, 2022 6:24:54 PM
    var utcDate = DateTime.utc(2022, 7, 15, 18, 24, 54);
    expect(utcDate.unixTimeStamp == 1657909494, true);

    ///Date and time (your time zone): Friday, July 15, 2022 6:24:54 PM GMT+06:00
    var localDate = DateTime(2022, 7, 15, 18, 24, 54);
    expect(localDate.unixTimeStamp == 1657887894, true);
  });
}
