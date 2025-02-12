// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class CasesModel {
  CasesModel({
    required this.id,
    required this.message,
    required this.global,
    required this.countries,
    required this.date,
  });

  final String id;
  final String message;
  final Global global;
  final List<Country> countries;
  final DateTime date;

  factory CasesModel.fromRawJson(String str) =>
      CasesModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory CasesModel.fromJson(Map<String, dynamic> json) => CasesModel(
        id: json["ID"] as String,
        message: json["Message"] as String,
        global: Global.fromJson(json["Global"] as Map<String, dynamic>),
        countries: List<Country>.from((json["Countries"] as Iterable).map(
          (x) => Country.fromJson(x as Map<String, dynamic>),
        )),
        date: DateTime.parse(json["Date"] as String),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Message": message,
        "Global": global.toJson(),
        "Countries": List<dynamic>.from(countries.map((x) => x.toJson())),
        "Date": date.toIso8601String(),
      };
}

class Country {
  Country({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.slug,
    required this.newConfirmed,
    required this.totalConfirmed,
    required this.newDeaths,
    required this.totalDeaths,
    required this.newRecovered,
    required this.totalRecovered,
    required this.date,
    required this.premium,
  });

  final String id;
  final String country;
  final String countryCode;
  final String slug;
  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;
  final DateTime date;
  final Premium premium;

  factory Country.fromRawJson(String str) =>
      Country.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["ID"] as String,
        country: json["Country"] as String,
        countryCode: json["CountryCode"] as String,
        slug: json["Slug"] as String,
        newConfirmed: json["NewConfirmed"] as int,
        totalConfirmed: json["TotalConfirmed"] as int,
        newDeaths: json["NewDeaths"] as int,
        totalDeaths: json["TotalDeaths"] as int,
        newRecovered: json["NewRecovered"] as int,
        totalRecovered: json["TotalRecovered"] as int,
        date: DateTime.parse(json["Date"] as String),
        premium: Premium.fromJson(json["Premium"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Country": country,
        "CountryCode": countryCode,
        "Slug": slug,
        "NewConfirmed": newConfirmed,
        "TotalConfirmed": totalConfirmed,
        "NewDeaths": newDeaths,
        "TotalDeaths": totalDeaths,
        "NewRecovered": newRecovered,
        "TotalRecovered": totalRecovered,
        "Date": date.toIso8601String(),
        "Premium": premium.toJson(),
      };
}

class Premium {
  Premium();

  factory Premium.fromRawJson(String str) =>
      Premium.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Premium.fromJson(Map<String, dynamic> json) => Premium();

  Map<String, dynamic> toJson() => {};
}

class Global {
  Global({
    required this.newConfirmed,
    required this.totalConfirmed,
    required this.newDeaths,
    required this.totalDeaths,
    required this.newRecovered,
    required this.totalRecovered,
    required this.date,
  });

  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;
  final DateTime date;

  factory Global.fromRawJson(String str) =>
      Global.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Global.fromJson(Map<String, dynamic> json) => Global(
        newConfirmed: json["NewConfirmed"] as int,
        totalConfirmed: json["TotalConfirmed"] as int,
        newDeaths: json["NewDeaths"] as int,
        totalDeaths: json["TotalDeaths"] as int,
        newRecovered: json["NewRecovered"] as int,
        totalRecovered: json["TotalRecovered"] as int,
        date: DateTime.parse(json["Date"] as String),
      );

  Map<String, dynamic> toJson() => {
        "NewConfirmed": newConfirmed,
        "TotalConfirmed": totalConfirmed,
        "NewDeaths": newDeaths,
        "TotalDeaths": totalDeaths,
        "NewRecovered": newRecovered,
        "TotalRecovered": totalRecovered,
        "Date": date.toIso8601String(),
      };
}
