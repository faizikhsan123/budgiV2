import 'package:budgi/app/routes/app_pages.dart';

import 'package:get/get.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int index) {
    print('changePage called: $index, current: ${pageIndex.value}');
    // ...

    switch (index) {
      case 0:
        pageIndex.value = index;
        Get.offAllNamed(Routes.HOME);
        break;

      case 1:
        pageIndex.value = index;
        Get.offAllNamed(Routes.TRANSAKSI);

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

  @override
  void onInit() {
    super.onInit();
    // Reset ke 0 setiap kali controller diinisialisasi ulang
    pageIndex.value = 0;
  }
}
