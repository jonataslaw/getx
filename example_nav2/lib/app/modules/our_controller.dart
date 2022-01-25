import 'package:dart_lol/LeagueStuff/responses/league_response.dart';
import 'package:dart_lol/ddragon_storage.dart';
import 'package:dart_lol/helper/UrlHelper.dart';
import 'package:get/get.dart';

class OurController extends GetxController {

  DDragonStorage dDragonStorage = DDragonStorage();
  UrlHelper urlHelper = UrlHelper();

  void checkError(LeagueResponse leagueResponse) {
    print("Checking error with default dialog");
    Get.defaultDialog(title: "${leagueResponse.responseCode}");
  }
}
