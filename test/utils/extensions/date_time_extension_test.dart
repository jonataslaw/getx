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
  test('isToday, wasYesterDay,willTomorrow', () {
    var now = DateTime.now();
    var day = now + 1.days;

    // print((day - 1.days).isToday);
    // print((day).willTomorrow);
    // print((day - 2.days).wasYesterday);
    expect((day - 1.days).isToday, true);
    expect((day - 2.days).wasYesterday, true);
    expect(day.willTomorrow, true);
  });

  test('weekDayName test', () {
    var now = DateTime(2022, 07, 16);
    print(now.weekDayName);
    print(now.weekday);
    expect(now.weekDayName == 'Sat', true);
    now = now + 1.days;
    expect(now.weekDayName == 'Sun', true);
    now = now + 1.days;
    expect(now.weekDayName == 'Mon', true);
    now = now + 1.days;
    expect(now.weekDayName == 'Tue', true);
    now = now + 1.days;
    expect(now.weekDayName == 'Wed', true);
    now = now + 1.days;
    expect(now.weekDayName == 'Thu', true);
    now = now + 1.days;
    expect(now.weekDayName == 'Fri', true);
  });
}
