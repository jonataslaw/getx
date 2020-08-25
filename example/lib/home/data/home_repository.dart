import 'home_model.dart';
import 'home_provider.dart';

class HomeRepository {
  HomeRepository({this.homeProvider});
  final HomeProvider homeProvider;

  Future<ApiModel> getData() async {
    return homeProvider.get();
  }
}
