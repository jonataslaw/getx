import 'package:flutter/foundation.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/src/extension_instance.dart';

final _registrations = <Object, _BindingRegistration>{};

/// Retains a registration until its last widget scope releases it.
///
/// An owning scope requests cleanup according to its current [autoRemove]
/// policy when released. The last borrower can opt out of that cleanup.
/// [expectedRegistration] prevents an old scope from owning a replacement.
VoidCallback? retainBindingRegistration<T>({
  String? tag,
  required bool Function() autoRemove,
  required bool Function() ownsRegistration,
  Object? expectedRegistration,
}) {
  final id = Get.getInstanceInfo<T>(tag: tag).registrationId;
  if (id == null) return null;
  final registration = _registrations.putIfAbsent(id, _BindingRegistration.new);
  registration.references++;
  final canOwn =
      expectedRegistration == null || identical(expectedRegistration, id);
  var released = false;
  return () {
    if (released) return;
    released = true;
    final remove = autoRemove();
    registration.cleanupRequested |= canOwn && ownsRegistration() && remove;
    if (--registration.references != 0) return;
    _registrations.remove(id);
    if (registration.cleanupRequested &&
        remove &&
        identical(Get.getInstanceInfo<T>(tag: tag).registrationId, id)) {
      Get.delete<T>(tag: tag);
    }
  };
}

class _BindingRegistration {
  int references = 0;
  bool cleanupRequested = false;
}
