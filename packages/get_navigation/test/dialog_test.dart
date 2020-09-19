import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_navigation/get_navigation.dart';
import 'utils/wrapper.dart';

void main() {
  testWidgets("Get.defaultDialog smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.defaultDialog(
        onConfirm: () => print("Ok"),
        middleText: "Dialog made in 3 lines of code");

    await tester.pumpAndSettle();

    expect(find.text("Ok"), findsOneWidget);
  });

  testWidgets("Get.dialog smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.dialog(YourDialogWidget());

    await tester.pumpAndSettle();

    expect(find.byType(YourDialogWidget), findsOneWidget);
  });

  testWidgets("Get.dialog close test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.dialog(YourDialogWidget());
    expect(Get.isDialogOpen, true);
    Get.back();
    expect(Get.isDialogOpen, false);
    await tester.pumpAndSettle();
  });
}

class YourDialogWidget extends StatelessWidget {
  const YourDialogWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
