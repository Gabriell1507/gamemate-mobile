import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamemate/modules/auth/signin/controllers/login_controller.dart';
import 'package:gamemate/widgets/login/custom_input.dart';
import 'package:gamemate/widgets/login/primary_button.dart';
import 'package:gamemate/widgets/login/social_button.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(4, 15, 26, 1),
              Color.fromRGBO(0, 31, 63, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset('assets/gamemate_login_logo.svg', width: 250),
                const SizedBox(height: 58),
                
                CustomInput(
                  hintText: "Email",
                  onChanged: controller.setEmail,
                ),
                Obx(() => controller.showError.value &&
                        controller.emailError.value.isNotEmpty
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.emailError.value,
                          style: const TextStyle(color: Colors.red),
                        ))
                    : const SizedBox.shrink()),
                const SizedBox(height: 12),
                Obx(() => CustomInput(
                      hintText: "Senha",
                      onChanged: controller.setPassword,
                      obscureText: controller.obscurePassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: controller.toggleObscure,
                      ),
                    )),
                // Obx(() => controller.showError.value &&
                //         controller.passwordError.value.isNotEmpty
                //     ? Align(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           controller.passwordError.value,
                //           style: TextStyle(color: Colors.red),
                //         ),
                //       )
                //     : SizedBox.shrink()),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Esqueceu sua senha? Clique aqui",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                PrimaryButton(
                  text: "Entrar",
                  onPressed: controller.login,
                ),
                const SizedBox(height: 12),
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Color.fromRGBO(34, 132, 230, 1),
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      "ou",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color.fromRGBO(34, 132, 230, 1),
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SocialButton(
                  text: "Entrar com Google",
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: "Cadastrar",
                  onPressed: () {
                    Get.toNamed('/register');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
