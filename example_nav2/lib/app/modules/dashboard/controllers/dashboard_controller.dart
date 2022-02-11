
import 'package:dart_lol/LeagueStuff/league_entry_dto.dart';
import 'package:dart_lol/dart_lol_api.dart';
import 'package:get/get.dart';

import '../../../../services/globals.dart';
import '../../our_controller.dart';

class DashboardController extends GetxController {

  final now = DateTime.now().obs;
  final challengerPlayers = <LeagueEntryDto>[].obs;

  @override
  Future<void> onReady() async {
    print('finished');
    getSomething();
    super.onReady();
  }

  Future<void> getSomething() async {
    final rankedChallengerPlayers = await league.getRankedQueueFromAPI(QueuesHelper.getValue(Queue.RANKED_SOLO_5X5), TiersHelper.getValue(Tier.CHALLENGER), DivisionsHelper.getValue(Division.I));
    print(rankedChallengerPlayers?[0]?.summonerName);
    final that = league.storage.getChallengerPlayers(DivisionsHelper.getValue(Division.I));
    challengerPlayers.addAll(that);
  }
}
