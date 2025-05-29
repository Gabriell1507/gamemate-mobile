import 'package:flutter/material.dart';
import 'package:gamemate/modules/auth/signup/models/user_model.dart';
import 'package:get/get.dart';


class SignupController extends GetxController {
  final usernameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final errorUsername = ''.obs;
  final errorNickname = ''.obs;
  final errorEmail = ''.obs;
  final errorPassword = ''.obs;
  final errorConfirmPassword = ''.obs;

  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  @override
  void onInit() {
    super.onInit();

    usernameController.addListener(() {
      _validateUsername(usernameController.text.trim());
    });

    nicknameController.addListener(() {
      _validateNickname(nicknameController.text.trim());
    });

    emailController.addListener(() {
      _validateEmail(emailController.text.trim());
    });

    passwordController.addListener(() {
      _validatePassword(passwordController.text);
      _validateConfirmPassword(confirmPasswordController.text);
    });

    confirmPasswordController.addListener(() {
      _validateConfirmPassword(confirmPasswordController.text);
    });
  }

  void _validateUsername(String username) {
    if (username.isEmpty) {
      errorUsername.value = 'Preencha o nome de usuário';
    } else {
      errorUsername.value = '';
    }
  }

  void _validateNickname(String nickname) {
    if (nickname.isEmpty) {
      errorNickname.value = 'Preencha o apelido';
    } else {
      
      errorNickname.value = '';
    }
  }

  void _validateEmail(String email) {
    if (email.isEmpty) {
      errorEmail.value = 'Preencha o email';
    } else if (!_emailRegex.hasMatch(email)) {
      errorEmail.value = 'Email inválido';
    } else {
      errorEmail.value = '';
    }
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      errorPassword.value = 'Preencha a senha';
    } else {
      final pwdErrors = _validatePasswordRules(password);
      if (pwdErrors.isNotEmpty) {
        errorPassword.value = 'Senha inválida:\n- ${pwdErrors.join('\n- ')}';
      } else {
        errorPassword.value = '';
      }
    }
  }

  void _validateConfirmPassword(String confirmPassword) {
    final password = passwordController.text;
    if (confirmPassword.isEmpty) {
      errorConfirmPassword.value = 'Confirme a senha';
    } else if (password != confirmPassword) {
      errorConfirmPassword.value = 'As duas senhas não estão idênticas';
    } else {
      errorConfirmPassword.value = '';
    }
  }

  List<String> _validatePasswordRules(String pwd) {
    final rules = <Map<String, dynamic>>[
      {'regex': r'^[A-Z]', 'msg': 'começar com letra maiúscula'},
      {'regex': r'[a-z]', 'msg': 'conter letra minúscula'},
      {'regex': r'\d', 'msg': 'conter número'},
      {'regex': r'[!@#\$&*~]', 'msg': 'conter caractere especial'},
      {'check': () => pwd.length >= 6, 'msg': 'ter no mínimo 6 caracteres'},
    ];

    final errors = <String>[];

    for (var rule in rules) {
      if (rule.containsKey('regex')) {
        if (!RegExp(rule['regex']).hasMatch(pwd)) {
          errors.add(rule['msg']);
        }
      } else if (rule.containsKey('check')) {
        if (!rule['check']()) {
          errors.add(rule['msg']);
        }
      }
    }

    return errors;
  }

  Future<void> validateFields() async {
    // Essa validação pode ficar para o momento do submit (clicar botão),
    // já que a validação em tempo real já está ativa.
  }

  void registerUser() {
    final newUser = UserModel(
      username: usernameController.text.trim(),
      nickname: nicknameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    print('Usuário registrado: ${newUser.toJson()}');

    usernameController.clear();
    nicknameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    errorUsername.value = '';
    errorNickname.value = '';
    errorEmail.value = '';
    errorPassword.value = '';
    errorConfirmPassword.value = '';
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

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool validateAllOnSubmit() {
  bool hasError = false;

  if (usernameController.text.trim().isEmpty) {
    errorUsername.value = 'Preencha o nome de usuário';
    hasError = true;
  }
  if (nicknameController.text.trim().isEmpty) {
    errorNickname.value = 'Preencha o apelido';
    hasError = true;
  }
  if (emailController.text.trim().isEmpty) {
    errorEmail.value = 'Preencha o email';
    hasError = true;
  } else if (!_emailRegex.hasMatch(emailController.text.trim())) {
    errorEmail.value = 'Email inválido';
    hasError = true;
  }
  if (passwordController.text.isEmpty) {
    errorPassword.value = 'Preencha a senha';
    hasError = true;
  } else {
    final pwdErrors = _validatePasswordRules(passwordController.text);
    if (pwdErrors.isNotEmpty) {
      errorPassword.value = 'Senha inválida:\n- ${pwdErrors.join('\n- ')}';
      hasError = true;
    }
  }
  if (confirmPasswordController.text.isEmpty) {
    errorConfirmPassword.value = 'Confirme a senha';
    hasError = true;
  } else if (passwordController.text != confirmPasswordController.text) {
    errorConfirmPassword.value = 'As duas senhas não estão idênticas';
    hasError = true;
  }

  return !hasError;
}

}
