// ignore: one_member_abstracts
import '../entity/country_model.dart';

abstract class IHomeRepository {
  Future<List<CountriesItem>> getCountries();

  Future<Country> getCountry(String path);
}
