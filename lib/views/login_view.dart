import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                SvgPicture.asset(
                  'assets/gamemate_login_logo.svg',
                  width: 260,
                ),
                const SizedBox(height: 16),
                Obx(() => controller.showError.value
                    ? const Text("X Email ou senha inválidos", style: TextStyle(color: Colors.red))
                    : const SizedBox.shrink()),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (val) => controller.email.value = val,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(0, 31, 63, 1),
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(34, 132, 230, 1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(34, 132, 230, 1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => TextField(
                  onChanged: (val) => controller.password.value = val,
                  obscureText: controller.obscurePassword.value,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white54,
                      ),
                      onPressed: controller.toggleObscure,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(0, 31, 63, 1),
                    hintText: "Senha",
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(34, 132, 230, 1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(34, 132, 230, 1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Esqueceu sua senha? Clique aqui", style: TextStyle(color: Colors.white54)),
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: const Text("Entrar"),
                ),
                const SizedBox(height: 12),
                const Text("ou", style: TextStyle(color: Colors.white54)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, color: Colors.black),
                  label: const Text("Entrar com o google", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(45),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(34, 132, 230, 1),
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: const Text("Cadastrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
