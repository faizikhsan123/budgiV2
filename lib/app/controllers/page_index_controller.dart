import 'package:budgi/app/routes/app_pages.dart';
import 'package:get/get.dart';

class PageIndexController extends GetxController {
  RxInt CurrentIndex = 0.obs;
 
 void changePage(int index){
  switch (index) {
    case 0:
    CurrentIndex.value = index;
      Get.offAllNamed(Routes.HOME);
      break;
    case 1:
    CurrentIndex.value = index;
      print("scab");
      break;
    case 2:
    CurrentIndex.value = index;
      Get.offAllNamed(Routes.PROFILE);
      break;
    default:
    Get.offAllNamed(Routes.HOME);
  }
 }
}
