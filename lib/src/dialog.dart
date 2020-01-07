import 'package:flutter/material.dart';
import 'package:get/src/routes.dart';

class DialogGet extends StatelessWidget {
  final Widget child;
  final color;
  final double opacity;

  const DialogGet({Key key, this.child, this.color, this.opacity = 0.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        color: (color == null)
            ? Theme.of(context).accentColor.withOpacity(opacity)
            : color,
        child: GestureDetector(onTap: () => null, child: child),
      ),
    );
  }
}

class DefaultDialogGet extends StatelessWidget {
  final color;
  final double opacity;
  final String title;
  final Widget content;
  final Widget cancel;
  final Widget confirm;

  const DefaultDialogGet(
      {Key key,
      this.color,
      this.opacity = 0.5,
      this.title,
      this.content,
      this.cancel,
      this.confirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        color: (color == null)
            ? Theme.of(context).accentColor.withOpacity(opacity)
            : color,
        child: GestureDetector(
          onTap: () => null,
          child: AlertDialog(
            title: Text(title, textAlign: TextAlign.center),
            content: content,
            actions: <Widget>[cancel, confirm],
          ),
        ),
      ),
    );
  }
}
