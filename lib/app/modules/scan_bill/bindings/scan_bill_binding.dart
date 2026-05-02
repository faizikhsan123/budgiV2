import 'package:get/get.dart';

import '../controllers/scan_bill_controller.dart';

class ScanBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanBillController>(
      () => ScanBillController(),
    );
  }
}
