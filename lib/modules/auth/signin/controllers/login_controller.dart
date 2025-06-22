import 'package:flutter/material.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:gamemate/modules/auth/signup/models/user_model.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;

  // Controllers para TextFields, pode manter se preferir
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Variáveis reativas para campos de texto (usadas no onChanged da view)
  var email = ''.obs;
  var password = ''.obs;

  // Variáveis para controlar erros e exibição dos mesmos
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var showError = false.obs;

  // Controle da visibilidade da senha
  var obscurePassword = true.obs;

  void setEmail(String value) {
    email.value = value;
    // Validação simples do email
    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Email inválido';
    } else {
      emailError.value = '';
    }
  }

  void setPassword(String value) {
    password.value = value;
    // Validação simples: senha deve ter pelo menos 6 caracteres
    if (value.length < 6) {
      passwordError.value = 'Senha deve ter ao menos 6 caracteres';
    } else {
      passwordError.value = '';
    }
  }

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> loginWithEmail() async {
    // Forçar exibição dos erros na view
    showError.value = true;

    // Validar antes de continuar
    if (email.value.isEmpty || password.value.isEmpty) {
      if (email.value.isEmpty) emailError.value = 'Email é obrigatório';
      if (password.value.isEmpty) passwordError.value = 'Senha é obrigatória';
      return;
    }

    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      // Tem erro de validação, não tenta login
      return;
    }

    try {
      isLoading.value = true;

      User? user = await _authService.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );

      if (user != null) {
        Get.snackbar('Sucesso', 'Login realizado com sucesso');
        Get.toNamed('/home');

      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
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

        Get.snackbar('Sucesso', 'Login com Google realizado');
        Get.toNamed('/home'); // Navegue para a tela principal
        // Navegue para tela principal
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
      print('Erro ao fazer login com Google: $e');
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
