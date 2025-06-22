import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:gamemate/modules/auth/signup/models/user_model.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  RxBool isLoadingGoogle = false.obs;
  RxBool isLoading = false.obs;

  TextEditingController usernameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Campos para controlar visibilidade da senha
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // Campos para armazenar mensagens de erro de validação
  RxString errorUsername = ''.obs;
  RxString errorNickname = ''.obs;
  RxString errorEmail = ''.obs;
  RxString errorPassword = ''.obs;
  RxString errorConfirmPassword = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validação simples dos campos
  bool validateAllOnSubmit() {
    bool valid = true;

    errorUsername.value = '';
    errorNickname.value = '';
    errorEmail.value = '';
    errorPassword.value = '';
    errorConfirmPassword.value = '';

    if (usernameController.text.trim().isEmpty) {
      errorUsername.value = 'Por favor, insira o nome de usuário';
      valid = false;
    }

    if (nicknameController.text.trim().isEmpty) {
      errorNickname.value = 'Por favor, insira o apelido';
      valid = false;
    }

    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      errorEmail.value = 'Por favor, insira um e-mail válido';
      valid = false;
    }

    if (passwordController.text.length < 6) {
      errorPassword.value = 'Senha deve ter ao menos 6 caracteres';
      valid = false;
    }

    if (confirmPasswordController.text != passwordController.text) {
      errorConfirmPassword.value = 'As senhas não coincidem';
      valid = false;
    }

    return valid;
  }

  Future<void> registerUser() async {
    try {
      isLoading.value = true;

      final newUser = UserModel(
        uid: '', // vazio no cadastro inicial
        username: usernameController.text.trim(),
        nickname: nicknameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _authService.signupWithEmail(
        email: newUser.email,
        password: newUser.password,
        userModel: newUser,
      );

      Get.snackbar('Sucesso', 'Cadastro realizado com sucesso');
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
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
}




  @override
  void onClose() {
    usernameController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
}
