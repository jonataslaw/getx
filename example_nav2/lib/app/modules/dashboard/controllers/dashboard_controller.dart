
import 'package:dart_lol/LeagueStuff/league_entry_dto.dart';
import 'package:dart_lol/LeagueStuff/match.dart';
import 'package:dart_lol/dart_lol_api.dart';
import 'package:example_nav2/app/helpers/matches_helper.dart';
import 'package:get/get.dart';

import '../../../../services/globals.dart';
import '../../our_controller.dart';

class DashboardController extends OurController {

  final now = DateTime.now().obs;
  RxString userProfileImage = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ezreal_1.jpg".obs;
  final challengerPlayers = <LeagueEntryDto>[].obs;
  final challengerPlayersFiltered = <LeagueEntryDto>[].obs;

  var rankedPlayerFilterText = "nadaa".obs;

  RxString queuesDropdownValue = QueuesHelper.getValue(Queue.RANKED_SOLO_5X5).obs;
  List <String> queuesItems = [
    '${QueuesHelper.getValue(Queue.RANKED_SOLO_5X5)}',
    '${QueuesHelper.getValue(Queue.RANKED_FLEX_SR)}',
  ];

  RxString tiersDropdownValue = TiersHelper.getValue(Tier.CHALLENGER).obs;
  List <String> tiersItems = [
    '${TiersHelper.getValue(Tier.CHALLENGER)}',
    '${TiersHelper.getValue(Tier.GRANDMASTER)}',
    '${TiersHelper.getValue(Tier.MASTER)}',
    '${TiersHelper.getValue(Tier.DIAMOND)}',
    '${TiersHelper.getValue(Tier.PLATINUM)}',
    '${TiersHelper.getValue(Tier.GOLD)}',
    '${TiersHelper.getValue(Tier.SILVER)}',
    '${TiersHelper.getValue(Tier.BRONZE)}',
    '${TiersHelper.getValue(Tier.IRON)}',
  ];

  RxString divisionsDropdownValue = DivisionsHelper.getValue(Division.I).obs;
  List <String> divisionsItems = [
    '${DivisionsHelper.getValue(Division.I)}',
    '${DivisionsHelper.getValue(Division.II)}',
    '${DivisionsHelper.getValue(Division.III)}',
    '${DivisionsHelper.getValue(Division.IV)}',
  ];

  @override
  Future<void> onReady() async {
    getChallengerPlayers();
    super.onReady();
  }

  Future<void> getChallengerPlayers() async {
    final rankedChallengerPlayers = await league.getRankedQueueFromAPI(QueuesHelper.getValue(Queue.RANKED_SOLO_5X5), TiersHelper.getValue(Tier.CHALLENGER), DivisionsHelper.getValue(Division.I));
    print(rankedChallengerPlayers?[0]?.summonerName);

    final that = league.storage.getChallengerPlayers(DivisionsHelper.getValue(Division.I));
    challengerPlayers.addAll(that);
    challengerPlayersFiltered.addAll(that);
  }

  Future<Map<String, int>> getMatchesForRankedSummoner(int index) async {
    print("getting match stuff for this user ${challengerPlayers[index].summonerName}");
    final rankedPlayer = challengerPlayers[index];
    final s = await getSummoner(false, rankedPlayer.summonerName??"");
    final matchHistories = await getMatchHistories(false, s?.puuid??"", fallbackAPI: true);
    print("match histories size: ${matchHistories?.length}");
    final myMathces = <Match>[];
    matchHistories?.take(5).forEach((element) async {
      print("getting match $element");
      final m = await getMatch(element);
      myMathces.add(m?.match??Match());
    });
    print("We have ${myMathces.length} matches");
    return await LeagueHelper().findMostPlayedChampions(s?.puuid??"", myMathces);
  }

  void filterChallengerPlayers(String text) {
    challengerPlayersFiltered.clear();
    challengerPlayersFiltered.addAll(challengerPlayers.where((p0) => p0.summonerName?.contains(text)==true).toList());
  }
}
