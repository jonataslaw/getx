import 'package:get_demo/pages/home/domain/entity/cases_model.dart';

abstract class IHomeRepository {
  Future<CasesModel> getCases();
}
