import 'log.dart';
import 'smart_management.dart';

/// GetInterface allows any auxiliary package to be merged into the "Get"
/// class through extensions
abstract class GetInterface {
  SmartManagement smartManagement = SmartManagement.full;
  String reference;
  bool isLogEnable = true;
  LogWriterCallback log = defaultLogWriterCallback;
}
