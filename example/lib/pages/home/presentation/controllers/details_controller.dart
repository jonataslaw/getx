import 'package:get/get.dart';

import '../../domain/adapters/repository_adapter.dart';
import '../../domain/entity/country_model.dart';

class DetailsController extends StateController<Country> {
  DetailsController({required this.homeRepository});

  final IHomeRepository homeRepository;
  late CountriesItem? country;

  @override
  void onInit() {
    super.onInit();
    country = Get.arguments;
    final countryName = country?.country;
    if (countryName == null) {
      change(GetStatus.error('Country not found'));
    } else {
      //Loading, Success, Error handle with 1 line of code
      futurize(() => homeRepository.getCountry(countryName));
    }
  }
}
