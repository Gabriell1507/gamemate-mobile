import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamemate/widgets/login/custom_input.dart';
import 'package:gamemate/widgets/login/primary_button.dart';
import 'package:get/get.dart';
import 'package:gamemate/modules/auth/signup/controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(4, 15, 26, 1),
              Color.fromRGBO(0, 31, 63, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/gamemate_login_logo.svg',
                  width: 250,
                ),
                const SizedBox(height: 58),
                CustomInput(
                  hintText: 'Nome de usuário',
                  onChanged: (value) =>
                      controller.usernameController.text = value,
                ),
                Obx(() {
                  final error = controller.errorUsername.value;
                  return error.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        );
                }),
                const SizedBox(height: 12),
                CustomInput(
                  hintText: 'Apelido',
                  onChanged: (value) =>
                      controller.nicknameController.text = value,
                ),
                Obx(() {
                  final error = controller.errorNickname.value;
                  return error.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        );
                }),
                const SizedBox(height: 12),
                CustomInput(
                  hintText: 'Email',
                  onChanged: (value) => controller.emailController.text = value,
                ),
                Obx(() {
                  final error = controller.errorEmail.value;
                  return error.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        );
                }),
                const SizedBox(height: 12),
                Obx(() => CustomInput(
                      hintText: 'Senha',
                      obscureText: !controller.isPasswordVisible.value,
                      onChanged: (value) =>
                          controller.passwordController.text = value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white54,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),
                Obx(() {
                  final error = controller.errorPassword.value;
                  return error.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        );
                }),
                const SizedBox(height: 12),
                Obx(() => CustomInput(
                      hintText: 'Confirmar senha',
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      onChanged: (value) =>
                          controller.confirmPasswordController.text = value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white54,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    )),
                Obx(() {
                  final error = controller.errorConfirmPassword.value;
                  return error.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        );
                }),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Cadastrar',
                  onPressed: () {
                    final isValid = controller.validateAllOnSubmit();
                    if (isValid) {
                      controller.registerUser();
                      
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já possui uma conta? ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Text(
                        'Faça seu login',
                        style: TextStyle(
                          color: Color.fromRGBO(34, 132, 230, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
