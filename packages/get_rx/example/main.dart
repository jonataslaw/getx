import 'package:get_rx/get_rx.dart';

void main() {
  var count = 0.obs;
  ever(count, print);
  count++;
  count++;
  count++;
  count++;
  count++;
  count++;
}
