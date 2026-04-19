import 'package:budgi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetController extends GetxController {
  final emailC = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  Future<void> sendResetEmail() async {
    final email = emailC.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
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
          'Berhasil',
          'Link reset password sudah dikirim ke email',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      });
    } on FirebaseAuthException catch (e) {
      String message = 'Gagal mengirim reset password';

      if (e.code == 'user-not-found') {
        message = 'Email tidak terdaftar';
      } else if (e.code == 'invalid-email') {
        message = 'Format email salah';
      }

      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
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
