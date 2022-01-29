library my_prj.globals;

import 'package:dart_lol/dart_lol_db.dart';
import 'package:get_it/get_it.dart';

import '../auth/secrets.dart';

bool isLoggedIn = false;

final league = LeagueDB(apiToken: '$myRiotAPIKey', server: "NA1");

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;
