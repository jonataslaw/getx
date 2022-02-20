
import 'dart:ui';

import 'package:flutter/cupertino.dart';

Text returnTitleText(String text) {
  return Text(text, style: TextStyle(height: 2, fontSize: 24),);
}

Text returnItemDetailText(String text, Color color) {
  return Text(text, style: TextStyle(color: color, fontSize: 12.0));
}