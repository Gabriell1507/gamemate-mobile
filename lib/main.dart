import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamemate/core/services/auth_service.dart';
import 'package:gamemate/routes/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  Get.put(AuthService());
  runApp(
    DevicePreview(
      enabled: !const bool.fromEnvironment('dart.vm.product'),
      builder: (context) => const GameMateApp(),
    ),
  );
}

class GameMateApp extends StatelessWidget {
  const GameMateApp({super.key});

@override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, 
      statusBarBrightness: Brightness.light,
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
