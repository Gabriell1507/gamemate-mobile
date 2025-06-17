import 'package:gamemate/modules/games_detail/controllers/game_detail_controller.dart';
import 'package:get/get.dart';

class GameDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameDetailController>(() => GameDetailController(Get.arguments));
  }
}
