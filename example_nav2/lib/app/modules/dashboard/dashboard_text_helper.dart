
import 'dart:ui';

import 'package:flutter/cupertino.dart';

Widget returnTitleText(String text) {
  return Container(margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0), child: FittedBox(fit: BoxFit.scaleDown, child: Text(text, style: TextStyle(height: 2, fontSize: 24), maxLines: 1, overflow: TextOverflow.ellipsis)));
}

Text returnItemDetailText(String text, Color color) {
  return Text(text, style: TextStyle(color: color, fontSize: 16.0));
}