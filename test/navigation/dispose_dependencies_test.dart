import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'utils/wrapper.dart';

void main() {
  testWidgets("Test dispose dependencies with unnamed routes", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    expect(Get.isRegistered<Controller2>(), false);
    expect(Get.isRegistered<Controller>(), false);

    Get.to(First());

    await tester.pumpAndSettle();

    expect(find.byType(First), findsOneWidget);

    expect(Get.isRegistered<Controller>(), true);

    Get.to(Second());

    await tester.pumpAndSettle();

    expect(find.byType(Second), findsOneWidget);

    expect(Get.isRegistered<Controller>(), true);
    expect(Get.isRegistered<Controller2>(), true);

    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(First), findsOneWidget);

    expect(Get.isRegistered<Controller>(), true);
    expect(Get.isRegistered<Controller2>(), false);

    Get.back();

    await tester.pumpAndSettle();

    expect(Get.isRegistered<Controller>(), false);
    expect(Get.isRegistered<Controller2>(), false);
  });
}

class Controller extends GetxController {}

class Controller2 extends GetxController {}

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(Controller());
    return Center(
      child: Text("first"),
    );
  }
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(Controller2());
    return Center(
      child: Text("second"),
    );
  }
}
