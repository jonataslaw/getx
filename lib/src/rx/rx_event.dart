// import '../../get.dart';

// class Reaction extends Rx {
//   dynamic Function() listener;
//   void Function(dynamic) callback;

//   Reaction(this.listener, this.callback) : super() {
//     subject.stream.listen((_) {
//       callback(_);
//     });

//     var previousObserver = Get.obs;
//     Get.obs = this;
//     listener();
//     Get.obs = previousObserver;
//   }

//   void dispose() {
//     close();
//   }
// }

// class When extends Rx {
//   dynamic Function() listener;
//   void Function(dynamic) callback;

//   When(this.listener, this.callback) : super() {
//     subject.stream.listen((_) {
//       callback(_);
//       dispose();
//     });

//     var previousObserver = Get.obs;
//     Get.obs = this;
//     listener();
//     Get.obs = previousObserver;
//   }

//   void dispose() {
//     close();
//   }
// }
