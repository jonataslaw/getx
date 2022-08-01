import 'package:flutter/widgets.dart';

class Engine{
  static  WidgetsBinding get instance {
    return WidgetsFlutterBinding.ensureInitialized();
  }
}