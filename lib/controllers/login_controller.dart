import 'package:get/get.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var showError = false.obs;
  var obscurePassword = true.obs;

  void login() {
    if (email.value.isEmpty || password.value.isEmpty) {
      showError.value = true;
    } else {
      showError.value = false;

      print('sucesso');
    }
  }

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }
}