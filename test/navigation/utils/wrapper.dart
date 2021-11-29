import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatelessWidget {
  final Widget? child;
  final List<GetPage>? namedRoutes;
  final String? initialRoute;
  final Transition? defaultTransition;

  const Wrapper({
    Key? key,
    this.child,
    this.namedRoutes,
    this.initialRoute,
    this.defaultTransition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: defaultTransition,
      initialRoute: initialRoute,
      translations: WrapperTranslations(),
      locale: WrapperTranslations.locale,
      getPages: namedRoutes,
      home: Scaffold(
        body: child,
      ),
    );
  }
}

class WrapperNamed extends StatelessWidget {
  final Widget? child;
  final List<GetPage>? namedRoutes;
  final String? initialRoute;
  final Transition? defaultTransition;

  const WrapperNamed({
    Key? key,
    this.child,
    this.namedRoutes,
    this.initialRoute,
    this.defaultTransition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: defaultTransition,
      initialRoute: initialRoute,
      getPages: namedRoutes,
    );
  }
}

class WrapperTranslations extends Translations {
  static final fallbackLocale = Locale('en', 'US');
  static Locale? get locale => Locale('en', 'US');
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'covid': 'Corona Virus',
          'total_confirmed': 'Total Confirmed',
          'total_deaths': 'Total Deaths',
        },
        'pt_BR': {
          'covid': 'Corona Vírus',
          'total_confirmed': 'Total confirmado',
          'total_deaths': 'Total de mortes',
        },
      };
}
