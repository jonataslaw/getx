import 'package:dio/dio.dart';

import '../domain/adapters/repository_adapter.dart';
import '../domain/entity/cases_model.dart';

class HomeRepository implements IHomeRepository {
  HomeRepository({this.dio});

  final Dio dio;

  @override
  Future<CasesModel> getCases() async {
    try {
      final response = await dio.get("https://api.covid19api.com/summary");
      return CasesModel.fromJson(response.data as Map<String, dynamic>);
    } on Exception catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }
}
