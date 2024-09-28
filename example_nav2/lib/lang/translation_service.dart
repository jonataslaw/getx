import 'dart:ui';

import 'package:example_nav2/lang/languages/en_US.dart';
import 'package:example_nav2/lang/languages/es_ES.dart';
import 'package:example_nav2/lang/languages/pt_BR.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';


class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');
  @override
  Map<String, Map<String, dynamic>> get keys => {
        'en_US': enUs,
        'pt_BR': ptBr,
        'es_ES': esEs,
      };
}
