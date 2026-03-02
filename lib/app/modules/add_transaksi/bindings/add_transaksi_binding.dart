import 'package:get/get.dart';

import '../controllers/add_transaksi_controller.dart';

class AddTransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTransaksiController>(
      () => AddTransaksiController(),
    );
  }
}
