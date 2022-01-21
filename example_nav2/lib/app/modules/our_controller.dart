import 'package:dart_lol/LeagueStuff/responses/league_response.dart';
import 'package:get/get.dart';

class OurController extends GetxController {
  void checkError(LeagueResponse leagueResponse) {
    print("Checking error with default dialog");
    Get.defaultDialog(title: "${leagueResponse.responseCode}");
  }
}
