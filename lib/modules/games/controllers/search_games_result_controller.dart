import 'package:get/get.dart';
import '../../games/data/models/games_model.dart';

class SearchResultsController extends GetxController {
  final RxList<IGDBGame> searchResults = <IGDBGame>[].obs;
  final RxString query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final results = args['results'];
      final searchQuery = args['query'];

      if (results is List<IGDBGame>) {
        searchResults.assignAll(results);
      }
      if (searchQuery is String) {
        query.value = searchQuery;
      }
    }
  }
}
