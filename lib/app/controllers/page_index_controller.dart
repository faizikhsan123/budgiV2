import 'package:budgi/app/routes/app_pages.dart';

import 'package:get/get.dart';

class PageIndexController extends GetxController {
  RxInt CurrentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }
  void changePage(int index) {
    switch (index) {
      case 0:
        CurrentIndex.value = index;
        Get.offAllNamed(Routes.HOME);
        break;

      case 1:
        CurrentIndex.value = index;
        Get.toNamed(Routes.TRANSAKSI);

        break;

      case 2:
        CurrentIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;

      default:
        CurrentIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }
  
}
