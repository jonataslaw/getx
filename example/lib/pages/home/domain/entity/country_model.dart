// Models
class Country {
  final String name;
  final String countryCode;
  final int numberOfPrizes;
  final double averageAgeOfLaureates;

  const Country({
    required this.name,
    required this.countryCode,
    required this.numberOfPrizes,
    required this.averageAgeOfLaureates,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['Country'],
      countryCode: json['CountryCode'],
      numberOfPrizes: json['Number of prizes'],
      averageAgeOfLaureates: json['Average age of laureates'].toDouble(),
    );
  }
}

class CountriesItem {
  final String country;
  final String countryCode;

  const CountriesItem({
    required this.country,
    required this.countryCode,
  });

  factory CountriesItem.fromJson(Map<String, dynamic> json) {
    return CountriesItem(
      country: json['Country'],
      countryCode: json['CountryCode'],
    );
  }
}
