import 'package:dio/dio.dart';
import 'package:get_state/home/models/home_model.dart';

class Api {
  /// To make your repository Global, you can use this:
  ///
  /// static Api get to => Get.put(Api());
  ///
  /// So you can access it with: Get.find<Api>().fetchData;
  /// You can dispose it with  Get.delete<Api>(Api());
  /// Only make the repository global if necessary, if you are going to use it on a single controller, there is no reason to make it global.
  Future<ApiModel> fetchData() async {
    try {
      final response = await Dio().get("https://api.covid19api.com/summary");
      return ApiModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
