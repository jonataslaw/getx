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

  test('daysInMonth test', () {
    var jan = DateTime(2022, 01, 16);
    expect(jan.daysInMonth == 31, true);

    var feb = DateTime(2022, 02, 16);
    expect(feb.daysInMonth == 28, true);

    var leapYearFeb = DateTime(2020, 02, 16);
    expect(leapYearFeb.daysInMonth == 29, true);

    var mar = DateTime(2022, 03, 16);
    expect(mar.daysInMonth == 31, true);

    var apr = DateTime(2022, 04, 16);
    expect(apr.daysInMonth == 30, true);

    var may = DateTime(2022, 05, 16);
    expect(may.daysInMonth == 31, true);

    var jun = DateTime(2022, 06, 16);
    expect(jun.daysInMonth == 30, true);

    var jul = DateTime(2022, 07, 16);
    expect(jul.daysInMonth == 31, true);

    var aug = DateTime(2022, 08, 16);
    expect(aug.daysInMonth == 31, true);

    var sep = DateTime(2022, 09, 16);
    expect(sep.daysInMonth == 30, true);

    var oct = DateTime(2022, 10, 16);
    expect(oct.daysInMonth == 31, true);

    var nov = DateTime(2022, 11, 16);
    expect(nov.daysInMonth == 30, true);

    var dec = DateTime(2022, 12, 16);
    expect(dec.daysInMonth == 31, true);
  });
}
