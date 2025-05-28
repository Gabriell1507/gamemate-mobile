
import 'package:gamemate/modules/auth/signup/controllers/signup_controller.dart';
import 'package:get/get.dart';


class SignupBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}