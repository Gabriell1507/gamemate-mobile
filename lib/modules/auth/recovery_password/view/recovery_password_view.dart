import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gamemate/modules/auth/recovery_password/controllers/recovery_password_controller.dart';
import 'package:gamemate/widgets/login/custom_input.dart';
import 'package:gamemate/widgets/login/primary_button.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Fecha o dialog ao clicar fora
      onTap: () => Get.back(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fundo com blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
              child: Container(color: Colors.transparent),
            ),
            // Diálogo centralizado
            Center(
              child: GestureDetector(
                // Previne fechar ao clicar dentro da modal
                onTap: () {},
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(24),
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(4, 15, 26, 1),
                          Color.fromRGBO(0, 31, 63, 1)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Recuperação',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'digite o email da sua conta',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => controller.errorMessage.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()),
                        CustomInput(
                          hintText: 'Email',
                          onChanged: controller.onEmailChanged,
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          text: 'Enviar',
                          onPressed: controller.submit,
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          text: 'Cancelar',
                          onPressed: () {
                            Get.back(); 
                          },
                          color: const Color.fromRGBO(242, 48, 48, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
