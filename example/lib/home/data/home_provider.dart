import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'home_model.dart';

abstract class IHomeProvider {
  Future<ApiModel> get();
  Future<ApiModel> post(Map<String, dynamic> data);
  Future<ApiModel> put(Map<String, dynamic> data);
  Future<ApiModel> delete(int id);
}

class HomeProvider implements IHomeProvider {
  final Dio dio;

  HomeProvider({@required this.dio});

  Future<ApiModel> get() async {
    try {
      final response = await dio.get("https://api.covid19api.com/summary");
      return ApiModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<ApiModel> post(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<ApiModel> put(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<ApiModel> delete(int id) {
    throw UnimplementedError();
  }
}
