import "package:intl/intl.dart";

class MyNumberFormatter {
  String returnThousandsWithComma(dynamic str) {
    final nf = NumberFormat("#,##0", "en_US");
    return nf.format(str);
  }
}