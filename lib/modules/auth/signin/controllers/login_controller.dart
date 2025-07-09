import 'package:flutter/material.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:gamemate/modules/auth/signup/models/user_model.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var email = ''.obs;
  var password = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var showError = false.obs;
  var obscurePassword = true.obs;

  void setEmail(String value) {
    email.value = value;
    emailError.value = GetUtils.isEmail(value) ? '' : 'Email inválido';
  }

  void setPassword(String value) {
    password.value = value;
    passwordError.value =
        value.length >= 6 ? '' : 'Senha deve ter ao menos 6 caracteres';
  }

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> loginWithEmail() async {
    showError.value = true;

    if (email.value.isEmpty) emailError.value = 'Email é obrigatório';
    if (password.value.isEmpty) passwordError.value = 'Senha é obrigatória';

    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) return;

    try {
      isLoading.value = true;
      User? user = await _authService.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );

      if (user != null) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString().replaceAll('Exception:', '').trim());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _authService.signInWithGoogle();
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        UserModel userModel = UserModel(
          uid: firebaseUser.uid,
          username: firebaseUser.displayName ?? '',
          nickname: '',
          email: firebaseUser.email ?? '',
          password: '',
        );

        await _authService.signupWithGoogle(
          user: firebaseUser,
          userModel: userModel,
        );

        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString().replaceAll('Exception:', '').trim());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
