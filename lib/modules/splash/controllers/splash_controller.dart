import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamemate/routes/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(seconds: 3), _checkAuth);
  }

  void _checkAuth() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Usuário autenticado, vai para Home
      Get.offNamed(AppRoute.home);
    } else {
      // Usuário não autenticado, vai para Login
      Get.offNamed(AppRoute.login);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
