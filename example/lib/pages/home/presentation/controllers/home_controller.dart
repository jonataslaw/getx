import 'package:get/get.dart';

import '../../domain/adapters/repository_adapter.dart';
import '../../domain/entity/cases_model.dart';

class HomeController extends GetxController with StatusMixin<CasesModel> {
  HomeController({this.homeRepository});

  /// inject repo abstraction dependency
  final IHomeRepository homeRepository;

  /// When the controller is initialized, make the http request
  @override
  void onInit() {
    super.onInit();
    // show loading on start, data on success
    // and error message on error with 0 boilerplate
    homeRepository.getCases().then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }
}
