import 'package:get_state/home/data/home_provider.dart';
import 'package:get_state/home/data/home_model.dart';

class HomeRepository {
  HomeRepository(this.homeProvider);
  final HomeProvider homeProvider;

  Future<ApiModel> getData() async {
    return homeProvider.fetchData();
  }
}
