import 'package:budgi/app/routes/app_pages.dart';

import 'package:get/get.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int index) {
    switch (index) {
      case 0:
        pageIndex.value = index;
        Get.offAllNamed(Routes.HOME);
        break;

      case 1:
        pageIndex.value = index;
        Get.toNamed(Routes.TRANSAKSI);

        break;

      case 2:
        pageIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;

      default:
        pageIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }
}
