import 'package:firebase_auth/firebase_auth.dart';
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

 Future<void> submit() async {
  if (!GetUtils.isEmail(email.value)) {
    errorMessage.value = 'O email inserido é inválido';
    return;
  }

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.value);
    Get.back(); // fecha a modal de redefinição (dialog)
    Get.snackbar(
      'Sucesso',
      'Email de recuperação enviado com sucesso.',
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    errorMessage.value = 'Erro ao enviar o email: ${e.toString()}';
    Get.snackbar(
      'Erro',
      'Não foi possível enviar o email de recuperação.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}}
