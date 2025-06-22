import 'package:flutter/material.dart';
import 'package:gamemate/modules/auth/signin/bindings/login_binding.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // para ficar centralizado verticalmente
            children: [
              const Text(
                'Biblioteca',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                          onPressed: () => Get.offNamed('/login'),
                          child: const Text('Sair'),
                        ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
