import 'package:get/get.dart';

import '../domain/entity/cases_model.dart';

// ignore: one_member_abstracts
abstract class IHomeProvider {
  Future<Response<CasesModel>> getCases(String path);
}

class HomeProvider extends GetConnect implements IHomeProvider {
  @override
  void onInit() {
    httpClient.defaultDecoder =
        (val) => CasesModel.fromJson(val as Map<String, dynamic>);
    httpClient.baseUrl = 'https://api.covid19api.com';
    super.onInit();
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
