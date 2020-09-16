import '../entity/cases_model.dart';

// ignore: one_member_abstracts
abstract class IHomeRepository {
  Future<CasesModel> getCases();
}
