import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:gamemate/routes/routes.dart';
import 'package:get/get.dart';
 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthService());
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
