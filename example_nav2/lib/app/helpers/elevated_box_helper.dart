import 'package:flutter/material.dart';

Widget returnElevatedBoxRoundedCorners(Widget widget, Color backgroundColor) {
  return IntrinsicHeight(
      child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Card(
              elevation: 8,
              color: backgroundColor,
              shadowColor: Colors.blue,
              child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),),),
                  margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0), child: widget))));
}