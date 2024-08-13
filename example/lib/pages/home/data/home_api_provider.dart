import 'package:get/get.dart';

import '../../../shared/constants/endpoints.dart';
import '../domain/entity/country_model.dart';

// ignore: one_member_abstracts
abstract class IHomeProvider {
  Future<Response<List<CountriesItem>>> getCountries();

  Future<Response<Country>> getCountry(String path);
}

class HomeProvider extends GetConnect implements IHomeProvider {
  @override
  void onInit() {
    httpClient.baseUrl = API_URL;

    super.onInit();
  }

  @override
  Future<Response<List<CountriesItem>>> getCountries() {
    return get(
      '/countries',
      decoder: (data) =>
          (data as List).map((item) => CountriesItem.fromJson(item)).toList(),
    );
  }

  Future<Response<Country>> getCountry(String path) async {
    return get('/country/$path', decoder: (data) => Country.fromJson(data));
  }
}
