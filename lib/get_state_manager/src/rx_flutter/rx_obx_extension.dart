import 'package:flutter/material.dart';

import '../../../get.dart';

extension on Widget {
  // * wraps the Widget with Obx widget
  Obx get obx => Obx(() => this);
}
