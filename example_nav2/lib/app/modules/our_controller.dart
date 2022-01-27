import 'package:dart_lol/LeagueStuff/responses/league_response.dart';
import 'package:dart_lol/ddragon_storage.dart';
import 'package:dart_lol/helper/UrlHelper.dart';
import 'package:get/get.dart';

import '../../services/globals.dart';

class OurController extends GetxController {

  DDragonStorage dDragonStorage = league.dDragonStorage;
  UrlHelper urlHelper = league.urlHelper;

  @override
  void onReady() {
    super.onReady();
  }

  void checkError(LeagueResponse leagueResponse) {
    print("Checking error with default dialog");
    Get.defaultDialog(title: "${leagueResponse.responseCode}");
  }
}
