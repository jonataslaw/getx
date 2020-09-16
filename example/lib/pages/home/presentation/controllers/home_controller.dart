import 'package:get/get.dart';

import '../../domain/adapters/repository_adapter.dart';
import '../../domain/entity/cases_model.dart';

enum Status { loading, success, error }

class HomeController extends GetxController {
  HomeController({this.homeRepository});

  /// inject repo abstraction dependency
  final IHomeRepository homeRepository;

  /// create a reactive status from request with initial value = loading
  final status = Status.loading.obs;

  /// create a reactive CasesModel. CasesModel().obs has same result
  final cases = Rx<CasesModel>();

  /// When the controller is initialized, make the http request
  @override
  void onInit() => fetchDataFromApi();

  /// fetch cases from Api
  Future<void> fetchDataFromApi() async {
    /// When the repository returns the value, change the status to success,
    /// and fill in "cases"
    return homeRepository.getCases().then(
      (data) {
        cases(data);
        status(Status.success);
      },

      /// In case of error, print the error and change the status
      /// to Status.error
      onError: (err) {
        print("$err");
        return status(Status.error);
      },
    );
  }
}
