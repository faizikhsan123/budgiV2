import 'package:get/get.dart';

import '../controllers/all_transaction_controller.dart';

class AllTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTransactionController>(
      () => AllTransactionController(),
    );
  }
}
