import 'package:get/get.dart';

import '../../domain/adapters/repository_adapter.dart';
import '../../domain/entity/country_model.dart';

class HomeController extends StateController<List<CountriesItem>> {
  HomeController({required this.homeRepository});

  final IHomeRepository homeRepository;

  @override
  void onInit() {
    super.onInit();
    change(GetStatus.success([]));
    change(GetStatus.loading());
    //Loading, Success, Error handle with 1 line of code
    try {
      futurize(homeRepository.getCountries);
    } catch (e) {
      print(e);
    }
  }

  Future<Country> getCountryByName(String name) async {
    final country = await homeRepository.getCountry(name);
    return country;
  }
}
