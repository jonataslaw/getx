import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../navigation/utils/wrapper.dart';

void main() {
  testWidgets("Get.defaultDialog smoke test", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));
    final BuildContext context = tester.element(find.byType(Container));

    var mediaQuery = MediaQuery.of(context);
    expect(mediaQuery, context.mediaQuery);
    var mediaQuerySize = mediaQuery.size;
    expect(mediaQuerySize, context.mediaQuerySize);
    var theme = Theme.of(context);
    expect(theme, context.theme);
    var textTheme = theme.textTheme;
    expect(textTheme, context.textTheme);
    var devicePixelRatio = mediaQuery.devicePixelRatio;
    expect(devicePixelRatio, context.devicePixelRatio);
    var height = mediaQuerySize.height;
    expect(height, context.height);
    final heightTransformer =
        (mediaQuerySize.height - ((mediaQuerySize.height / 100) * 0)) / 1;
    expect(heightTransformer, context.heightTransformer());
    var iconColor = theme.iconTheme.color;
    expect(iconColor, context.iconColor);
    var isDarkMode = (theme.brightness == Brightness.dark);
    expect(isDarkMode, context.isDarkMode);
    var orientation = mediaQuery.orientation;
    expect(orientation, context.orientation);
    var isLandscape = orientation == Orientation.landscape;
    expect(isLandscape, context.isLandscape);
    var mediaQueryShortestSide = mediaQuerySize.shortestSide;
    expect(mediaQueryShortestSide, context.mediaQueryShortestSide);
    var width = mediaQuerySize.width;
    expect(width, context.width);

    var isLargeTabletOrWider = (width >= 720);
    expect(isLargeTabletOrWider, context.isLargeTabletOrWider);
    var isPhoneOrLess = (width < 600);
    expect(isPhoneOrLess, context.isPhoneOrLess);
    var isPortrait = orientation == Orientation.portrait;
    expect(isPortrait, context.isPortrait);
    var isSmallTabletOrWider = (width >= 600);
    expect(isSmallTabletOrWider, context.isSmallTabletOrWider);
    var isTablet = isSmallTabletOrWider || isLargeTabletOrWider;
    expect(isTablet, context.isSmallTabletOrWider);
    var mediaQueryPadding = mediaQuery.padding;
    expect(mediaQueryPadding, context.mediaQueryPadding);
    var mediaQueryViewInsets = mediaQuery.viewInsets;
    expect(mediaQueryViewInsets, context.mediaQueryViewInsets);
    var mediaQueryViewPadding = mediaQuery.viewPadding;
    expect(mediaQueryViewPadding, context.mediaQueryViewPadding);
    var widthTransformer =
        (mediaQuerySize.width - ((mediaQuerySize.width / 100) * 0)) / 1;
    expect(widthTransformer, context.widthTransformer());
    var ratio = heightTransformer / widthTransformer;
    expect(ratio, context.ratio());

    var showNavbar = (width > 800);
    expect(showNavbar, context.showNavbar);
    var textScaleFactor = mediaQuery.textScaleFactor;
    expect(textScaleFactor, context.textScaleFactor);
  });
}
