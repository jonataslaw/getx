// import 'dart:async';
// import 'package:flutter/widgets.dart';
// import 'package:get/src/get_main.dart';
// import 'rx_impl.dart';
// import 'rx_interface.dart';

// class ListViewX<T extends RxController> extends StatefulWidget {
//   final Widget Function(T, int) builder;
//   final bool global;
//   final ListX Function(T) list;
//   final bool autoRemove;
//   final void Function(State state) initState, dispose, didChangeDependencies;
//   final T init;
//   final int itemCount;
//   ListViewX({
//     this.builder,
//     this.global = true,
//     this.autoRemove = true,
//     this.initState,
//     @required this.list,
//     this.itemCount,
//     this.dispose,
//     this.didChangeDependencies,
//     this.init,
//   });
//   _ListViewXState<T> createState() => _ListViewXState<T>();
// }

// class _ListViewXState<T extends RxController> extends State<ListViewX<T>> {
//   RxInterface _observer;
//   StreamSubscription _listenSubscription;
//   T controller;

//   _ListViewXState() {
//     _observer = ListX();
//   }

//   @override
//   void initState() {
//     if (widget.global) {
//       if (Get.isRegistred<T>()) {
//         controller = Get.find<T>();
//       } else {
//         controller = widget.init;
//         Get.put<T>(controller);
//       }
//     } else {
//       controller = widget.init;
//     }
//     if (widget.initState != null) widget.initState(this);
//     try {
//       controller?.onInit();
//     } catch (e) {
//       if (Get.isLogEnable) print("Failure on call onInit");
//     }

//     _listenSubscription = widget.list.call(controller).listen((data) {
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller?.onClose();
//     _listenSubscription?.cancel();
//     _observer?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _observer.close();
//     final observer = Get.obs;
//     Get.obs = this._observer;
//     final result = ListView.builder(
//         itemCount: widget.itemCount ?? widget.list.call(controller).length,
//         itemBuilder: (context, index) {
//           return widget.builder(controller, index);
//         });
//     Get.obs = observer;
//     return result;
//   }
// }
