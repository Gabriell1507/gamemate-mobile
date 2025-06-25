
import 'package:gamemate/modules/library/controllers/library_controller.dart';

import 'package:get/get.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LibraryController>(() => LibraryController());

  }
}