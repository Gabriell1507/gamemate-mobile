import 'package:gamemate/modules/games_detail/controllers/game_detail_controller.dart';
import 'package:get/get.dart';


class GameDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameDetailsController>(() => GameDetailsController());
  }
}
