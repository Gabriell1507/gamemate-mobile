import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/login_binding.dart';
import 'views/login_view.dart';

void main() {
  runApp(const GameMateApp());
}

class GameMateApp extends StatelessWidget {
  const GameMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GameMate',
      initialBinding: LoginBinding(),
      home: LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
