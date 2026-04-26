import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final RxBool isloading = false.obs;
  final RxBool ishidepass = true.obs;
  final RxBool ishidepassreentry = true.obs;

  late final TextEditingController nameC;
  late final TextEditingController emailC;
  late final TextEditingController passC;
  late final TextEditingController passReC;

  @override
  void onInit() {
    nameC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    passReC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    passReC.dispose();
    super.onClose();
  }

  void _clearFields() {
    nameC.clear();
    emailC.clear();
    passC.clear();
    passReC.clear();
  }

  void _showError(String messageKey) {
    Get.snackbar(
      'failed'.tr,
      messageKey.tr,
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
    );
  }

  Future<void> jalankanRegis() async {
    if (nameC.text.trim().isEmpty ||
        emailC.text.trim().isEmpty ||
        passC.text.trim().isEmpty ||
        passReC.text.trim().isEmpty) {
      _showError('fields_required');
      return;
    }

    if (nameC.text.trim().length < 3) {
      _showError('name_min');
      return;
    }

    if (!GetUtils.isEmail(emailC.text.trim())) {
      _showError('email_invalid');
      return;
    }

    if (passC.text.length < 6) {
      _showError('pass_min');
      return;
    }

    if (passC.text != passReC.text) {
      _showError('pass_not_match');
      return;
    }

    await _regis(emailC.text.trim(), passC.text.trim());
  }

  Future<void> _regis(String email, String pass) async {
    isloading.value = true;
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final uid = userCredential.user!.uid;

      await Future.wait([
        firestore.collection("users").doc(uid).set({
          "name": nameC.text.trim(),
          "email": email,
          "provider": "Form Pendaftaran",
          "photo_url": "",
          "created_at": Timestamp.now(),
          "updated_at": Timestamp.now(),
        }),
        userCredential.user!.sendEmailVerification(),
      ]);

      _clearFields();

      Get.snackbar(
        'regis_success'.tr,
        'regis_success_msg'.tr,
        backgroundColor: const Color(0xFF2ECC71),
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'regis_failed'.tr,
        'regis_failed_msg'.tr,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isloading.value = false;
    }
  }
}