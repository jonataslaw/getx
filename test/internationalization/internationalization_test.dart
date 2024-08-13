import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../navigation/utils/wrapper.dart';

void main() {
  testWidgets("Get.defaultDialog smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    await tester.pumpAndSettle();

    expect('details'.tr, 'Details');
    expect('number_of_prizes'.tr, 'Number of prizes');
    expect('average_age_of_laureates'.tr, 'Average age of laureates');

    Get.updateLocale(const Locale('pt', 'BR'));

    await tester.pumpAndSettle();

    expect('details'.tr, 'Detalhes');
    expect('number_of_prizes'.tr, 'Número de prêmios');
    expect('average_age_of_laureates'.tr, 'Idade média dos laureados');

    Get.updateLocale(const Locale('en', 'EN'));

    await tester.pumpAndSettle();

    expect('details'.tr, 'Details');
    expect('number_of_prizes'.tr, 'Number of prizes');
    expect('average_age_of_laureates'.tr, 'Average age of laureates');
  });
}
