import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:gamemate/routes/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  Get.put(AuthService());
  runApp(const GameMateApp());
}

class GameMateApp extends StatelessWidget {
  const GameMateApp({super.key});

@override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // ícones brancos
      statusBarBrightness: Brightness.light, // para iOS
    ),
    child: GetMaterialApp(
      title: 'GameMate',
      initialRoute: AppRoute.splash,
      getPages: AppRoute.pages,
      debugShowCheckedModeBanner: false,
    ),
  );
}
}
