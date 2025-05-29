import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final RxString email = ''.obs;
  final RxString errorMessage = ''.obs;

  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  void onEmailChanged(String value) {
    email.value = value.trim();

    
    if (email.value.isEmpty) {
      errorMessage.value = 'O email não pode estar vazio.';
    } else if (!_emailRegex.hasMatch(email.value)) {
      errorMessage.value = 'Formato de email inválido.';
    } else {
      errorMessage.value = '';
    }
  }

  void submit() {
   
    if (!GetUtils.isEmail(email.value)) {
      errorMessage.value = 'O email inserido é inválido';
    } else {
     
      Get.back();
    }
  }

  void cancel() {
    Get.back();
  }
}
