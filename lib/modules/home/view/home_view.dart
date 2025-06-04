import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamemate/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
 HomeView({super.key});

  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                SvgPicture.asset(
                  'assets/gamemate_login_logo.svg', 
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                // Botão para sair
                ElevatedButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Sair",
                      middleText: "Tem certeza que deseja sair?",
                      textConfirm: "Sim",
                      textCancel: "Cancelar",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back(); 
                        Get.offAllNamed('/login'); 
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sair',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
