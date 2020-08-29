import 'package:get_state/pages/home/domain/entity/cases_model.dart';

abstract class IHomeRepository {
  Future<CasesModel> getCases();
}
