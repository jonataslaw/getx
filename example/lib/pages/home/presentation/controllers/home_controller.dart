import 'package:get/get.dart';

import '../../domain/adapters/repository_adapter.dart';
import '../../domain/entity/country_model.dart';

class HomeController extends StateController<List<CountriesItem>> {
  HomeController({required this.homeRepository});

  final IHomeRepository homeRepository;

  @override
  void onInit() {
    super.onInit();
    futurize(homeRepository.getCountries);
  }

  Future<Country> getCountryByName(String name) async {
    final country = await homeRepository.getCountry(name);
    return country;
  }
}
