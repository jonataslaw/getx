import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:example_nav2/main.dart' as app;
import 'package:example_nav2/app/routes/app_pages.dart';
import 'package:example_nav2/services/auth_service.dart';
import 'package:example_nav2/app/modules/profile/views/profile_view.dart';

Future<void> settleRoute(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

void main() {
  tearDown(Get.reset);

  testWidgets('nested example redirects protected routes and logs in',
      (tester) async {
    app.main();
    await settleRoute(tester);
    expect(find.text('DashboardView is working'), findsOneWidget);
    expect(AuthService.to.isLoggedInValue, isFalse);

    Get.toNamed(Routes.profile);
    await settleRoute(tester);
    expect(find.text('Do LOGIN !!'), findsOneWidget);

    await tester.tap(find.text('Do LOGIN !!'));
    await settleRoute(tester);
    expect(AuthService.to.isLoggedInValue, isTrue);
    expect(find.text('Do LOGIN !!'), findsNothing);
    expect(find.byType(ProfileView), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    expect(Get.isRegistered<AuthService>(), isFalse);
  });
}
