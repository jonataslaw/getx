import 'package:flutter/widgets.dart';

import '../../../instance_manager.dart';
import 'get_controllers.dart';

/// GetBindWidget can bind GetxController, and when the page is disposed,
/// it can automatically destroy the bound related GetXController
///
///
/// Sample:
///
/// class SampleController extends GetxController {
///   final String title = 'My Awesome View';
/// }
///
/// class SamplePage extends StatelessWidget {
///   final controller = SampleController();
///
///   @override
///   Widget build(BuildContext context) {
///     return GetBindWidget(
///       bind: controller,
///       child: Container(),
///     );
///   }
/// }
class GetBindWidget extends StatefulWidget {
  const GetBindWidget({
    Key? key,
    this.bind,
    this.tag,
    this.binds,
    this.tags,
    required this.child,
  })   : assert(
          binds == null || tags == null || binds.length == tags.length,
          'The binds and tags arrays length should be equal\n'
          'and the elements in the two arrays correspond one-to-one',
        ),
        super(key: key);

  final GetxController? bind;
  final String? tag;

  final List<GetxController>? binds;
  final List<String>? tags;

  final Widget child;

  @override
  _GetBindWidgetState createState() => _GetBindWidgetState();
}

class _GetBindWidgetState extends State<GetBindWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _closeGetXController();
    _closeGetXControllers();

    super.dispose();
  }

  ///Close GetxController bound to the current page
  void _closeGetXController() {
    if (widget.bind == null) {
      return;
    }

    var key = widget.bind.runtimeType.toString() + (widget.tag ?? '');
    GetInstance().delete(key: key);
  }

  ///Batch close GetxController bound to the current page
  void _closeGetXControllers() {
    if (widget.binds == null) {
      return;
    }

    for (var i = 0; i < widget.binds!.length; i++) {
      var type = widget.binds![i].runtimeType.toString();

      if (widget.tags == null) {
        GetInstance().delete(key: type);
      } else {
        var key = type + (widget.tags?[i] ?? '');
        GetInstance().delete(key: key);
      }
    }
  }
}
