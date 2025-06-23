import 'package:gamemate/modules/profile/controllers/profile_controller.dart';
import 'package:gamemate/modules/profile/data/providers/profile_provider.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_URL_DEV'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    Get.lazyPut<Dio>(() => dio);
    Get.lazyPut<ProfileProvider>(() => ProfileProvider(Get.find<Dio>()));
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileProvider>()));
  }
}
