import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/modules/profile/data/providers/profile_provider.dart';
import 'package:gamemate/modules/games/controllers/games_controller.dart';

class GamesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio());

    Get.lazyPut<GamesController>(() => GamesController());
    Get.lazyPut<ProfileProvider>(() => ProfileProvider(Get.find<Dio>()));
    Get.lazyPut<ProfileController>(
        () => ProfileController(Get.find<ProfileProvider>()));
  }
}
