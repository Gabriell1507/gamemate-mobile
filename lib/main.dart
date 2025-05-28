import 'package:flutter/material.dart';
import 'package:gamemate/routes/routes.dart';
import 'package:get/get.dart';


void main() {
  runApp(const GameMateApp());
}

class GameMateApp extends StatelessWidget {
  const GameMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GameMate',
      initialRoute: AppRoute.splash,
      getPages: AppRoute.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
