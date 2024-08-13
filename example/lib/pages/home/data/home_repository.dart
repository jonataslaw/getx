import '../domain/adapters/repository_adapter.dart';
import '../domain/entity/country_model.dart';
import 'home_api_provider.dart';

class HomeRepository implements IHomeRepository {
  HomeRepository({required this.provider});
  final IHomeProvider provider;

  @override
  Future<List<CountriesItem>> getCountries() async {
    final cases = await provider.getCountries();
    if (cases.status.hasError) {
      return Future.error(cases.statusText!);
    } else {
      return cases.body!;
    }
  }

  Future<Country> getCountry(String path) async {
    final country = await provider.getCountry(path);
    if (country.status.hasError) {
      return Future.error(country.statusText!);
    } else {
      return country.body!;
    }
  }
}
