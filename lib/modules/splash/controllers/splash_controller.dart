import 'dart:async';
import 'package:gamemate/routes/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoute.login);  // redireciona para a rota de login após 3 segundos
    });
  }

  @override
  void onClose() {
    _timer?.cancel();  // cancela o timer se a splash for fechada antes do tempo
    super.onClose();
  }
}
