import 'package:get/get.dart';

import '../controllers/complete_balance_controller.dart';

class CompleteBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteBalanceController>(
      () => CompleteBalanceController(),
    );
  }
}
