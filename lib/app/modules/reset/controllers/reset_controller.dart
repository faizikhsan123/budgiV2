import 'package:budgi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetController extends GetxController {
  final emailC = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isLoading = false.obs;

  Future<void> sendResetEmail() async {
    final email = emailC.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'email_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'error'.tr,
        'email_format_invalid'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email);

      Get.offAllNamed(Routes.LOGIN);

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'reset_success'.tr,
          'reset_success_msg'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2ECC71),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      });
    } on FirebaseAuthException catch (e) {
      final message = e.code == 'user-not-found'
          ? 'email_not_found'.tr
          : e.code == 'invalid-email'
              ? 'email_format_invalid'.tr
              : 'reset_failed'.tr;

      Get.snackbar(
        'error'.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }
}