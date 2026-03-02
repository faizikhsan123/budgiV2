import 'package:get/get.dart';

import '../controllers/regis_controller.dart';

class RegisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisController>(
      () => RegisController(),
    );
  }
}
