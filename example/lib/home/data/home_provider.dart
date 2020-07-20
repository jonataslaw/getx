import 'package:dio/dio.dart';
import 'package:get_state/home/data/home_model.dart';

class HomeProvider {
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
