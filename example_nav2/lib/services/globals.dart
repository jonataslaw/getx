library my_prj.globals;

import 'package:dart_lol/dart_lol_db.dart';

import '../auth/secrets.dart';

bool isLoggedIn = false;

final league = LeagueDB(apiToken: '$myRiotAPIKey', server: "NA1");
