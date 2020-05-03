import 'package:get/get.dart';
import 'package:get_state/home/models/home_model.dart';
import 'package:get_state/home/repositorys/home_repository.dart';

class Controller extends GetController {
  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.fetchDataFromApi();
  /// with no static method: Get.find<Controller>().fetchDataFromApi();
  /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other does.
  static Controller get to => Get.find();

  ApiModel data;

  void fetchDataFromApi() async {
    Api api = Api();
    final response = await api.fetchData();
    if (response == null) {
      Get.snackbar("Erro", "Não foi possível conectar ao servidor");
    } else {
      data = response;
      update(this);
    }
  }
}

/// The first way works perfectly, but if you want to follow good practices,
/// you can make the data private and access it through a Get.
///
///
// class Controllers extends GetController {
//   /// You do not need that. I recommend using it just for ease of syntax.
//   /// with static method: Controller.to.fetchDataFromApi();
//   /// with no static method: Get.find<Controller>().fetchDataFromApi();
//   /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other does.
//   static Controller get to => Get.find();

//   ApiModel _data;
//   ApiModel get data => _data;

//   void fetchDataFromApi() async {
//     Api api = Api();
//     final response = await api.fetchData();
//     if (response == null) {
//       Get.snackbar("Erro", "Não foi possível conectar ao servidor");
//     } else {
//       _data = response;
//       update(this);
//     }
//   }
// }
