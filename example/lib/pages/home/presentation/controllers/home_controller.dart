import 'package:get/get.dart';

import '../../domain/adapters/repository_adapter.dart';
import '../../domain/entity/cases_model.dart';

class HomeController extends StateController<CasesModel> {
  HomeController({required this.homeRepository});

  final IHomeRepository homeRepository;

  @override
  void onInit() {
    super.onInit();
    //Loading, Success, Error handle with 1 line of code
    futurize(() => homeRepository.getCases);
  }

  Country getCountryById(String id) {
    final index = int.tryParse(id);
    return index != null ? state.countries[index] : state.countries.first;
  }
}
