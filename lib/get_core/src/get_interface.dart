import 'package:flutter/widgets.dart';
import '../../get_navigation/src/nav2/get_router_delegate.dart';
import '../../get_navigation/src/routes/get_route.dart';

import 'log.dart';
import 'smart_management.dart';

/// GetInterface allows any auxiliary package to be merged into the "Get"
/// class through extensions
abstract class GetInterface {
  SmartManagement smartManagement = SmartManagement.full;
  RouterDelegate? routerDelegate;
  String? reference;
  bool isLogEnable = true;
  LogWriterCallback log = defaultLogWriterCallback;
}
