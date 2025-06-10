import 'package:gamemate/modules/games/controllers/search_games_result_controller.dart';
import 'package:get/get.dart';

class SearchResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchResultsController>(() => SearchResultsController());
  }
}
