import 'package:get/get.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var showError = false.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var obscurePassword = true.obs;

  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  final RegExp _passwordRegex = RegExp(r'^[A-Z](?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{5,}$');


  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  void setEmail(String value) {
    email.value = value;
    validateEmail();
  }

  void setPassword(String value) {
    password.value = value;
    validatePassword();
  }

  bool validateEmail() {
    if (!_emailRegex.hasMatch(email.value)) {
      emailError.value = 'Email inválido';
      return false;
    } else {
      emailError.value = '';
      return true;  
    }
  }

  bool validatePassword() {
  final pwd = password.value;

  final rules = <Map<String, dynamic>>[
    {'regex': r'^[A-Z]', 'msg': 'começar com letra maiúscula'},
    {'regex': r'[a-z]', 'msg': 'conter letra minúscula'},
    {'regex': r'\d', 'msg': 'conter número'},
    {'regex': r'[!@#\$&*~]', 'msg': 'conter caractere especial'},
    {'check': () => pwd.length >= 6, 'msg': 'ter no mínimo 6 caracteres'},
  ];

  final errors = <String>[];

  for (var rule in rules) {
    !rule.containsKey('regex')
        ? (rule['check']() ? null : errors.add(rule['msg']))
        : (RegExp(rule['regex']).hasMatch(pwd) ? null : errors.add(rule['msg']));
  }

  passwordError.value =
      errors.isNotEmpty ? 'A senha deve ${errors.join(', ')}.' : '';
  return errors.isEmpty;
}


  void login() {
    final validEmail = validateEmail();
    final validPassword = validatePassword();

    if (!validEmail || !validPassword) {
      showError.value = true;
      return;
    } else {
      showError.value = false;


    }
  }




}