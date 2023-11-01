import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../navigation/utils/wrapper.dart';

void main() {
  testWidgets('Get.defaultDialog smoke test', (final tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(Container));

    final mediaQuery = MediaQuery.of(context);
    expect(mediaQuery, context.mediaQuery);
    final mediaQuerySize = mediaQuery.size;
    expect(mediaQuerySize, context.mediaQuerySize);
    final theme = Theme.of(context);
    expect(theme, context.theme);
    final textTheme = theme.textTheme;
    expect(textTheme, context.textTheme);
    final devicePixelRatio = mediaQuery.devicePixelRatio;
    expect(devicePixelRatio, context.devicePixelRatio);
    final height = mediaQuerySize.height;
    expect(height, context.height);
    final heightTransformer =
        (mediaQuerySize.height - ((mediaQuerySize.height / 100) * 0)) / 1;
    expect(heightTransformer, context.heightTransformer());
    final iconColor = theme.iconTheme.color;
    expect(iconColor, context.iconColor);
    final isDarkMode = (theme.brightness == Brightness.dark);
    expect(isDarkMode, context.isDarkMode);
    final orientation = mediaQuery.orientation;
    expect(orientation, context.orientation);
    final isLandscape = orientation == Orientation.landscape;
    expect(isLandscape, context.isLandscape);
    final mediaQueryShortestSide = mediaQuerySize.shortestSide;
    expect(mediaQueryShortestSide, context.mediaQueryShortestSide);
    final width = mediaQuerySize.width;
    expect(width, context.width);

    final isLargeTabletOrWider = width >= 720;
    expect(isLargeTabletOrWider, context.isLargeTabletOrWider);
    final isPhoneOrLess = width < 600;
    expect(isPhoneOrLess, context.isPhoneOrLess);
    final isPortrait = orientation == Orientation.portrait;
    expect(isPortrait, context.isPortrait);
    final isSmallTabletOrWider = width >= 600;
    expect(isSmallTabletOrWider, context.isSmallTabletOrWider);
    final isTablet = isSmallTabletOrWider || isLargeTabletOrWider;
    expect(isTablet, context.isSmallTabletOrWider);
    final mediaQueryPadding = mediaQuery.padding;
    expect(mediaQueryPadding, context.mediaQueryPadding);
    final mediaQueryViewInsets = mediaQuery.viewInsets;
    expect(mediaQueryViewInsets, context.mediaQueryViewInsets);
    final mediaQueryViewPadding = mediaQuery.viewPadding;
    expect(mediaQueryViewPadding, context.mediaQueryViewPadding);
    final widthTransformer =
        (mediaQuerySize.width - ((mediaQuerySize.width / 100) * 0)) / 1;
    expect(widthTransformer, context.widthTransformer());
    final ratio = heightTransformer / widthTransformer;
    expect(ratio, context.ratio());

    final showNavbar = width > 800;
    expect(showNavbar, context.showNavbar);
    final textScaleFactor = mediaQuery.textScaleFactor;
    expect(textScaleFactor, context.textScaleFactor);
  });
}
