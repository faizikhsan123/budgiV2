import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxBool isloading = false.obs;
  RxBool ishidepass = true.obs;
  RxBool ishidepassreentry = true.obs;

  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController passC;
  late TextEditingController passReC;


  Future<void> jalankanRegis() async {
    if (nameC.text.trim().isEmpty ||
        emailC.text.trim().isEmpty ||
        passC.text.trim().isEmpty ||
        passReC.text.trim().isEmpty 
        ) {
      Get.snackbar(
        "Failed",
        "All fields are required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (nameC.text.length < 3) {
      Get.snackbar(
        "Failed",
        "Name must be at least 3 characters",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

   

    if (!GetUtils.isEmail(emailC.text.trim())) {
      Get.snackbar(
        "Failed",
        "Email is not valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passC.text.length < 6) {
      Get.snackbar(
        "Failed",
        "Password must be at least 6 characters",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passC.text != passReC.text) {
      Get.snackbar(
        "Failed",
        "Password does not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _regis(emailC.text.trim(), passC.text.trim());
  }

  Future<void> _regis(String email, String pass) async {
    isloading.value = true;

    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: pass);

      final uid = userCredential.user!.uid;

      await firestore.collection("users").doc(uid).set({
        "name": nameC.text.trim(),
        "email": email,
        "provider": "Form Pendaftaran",
        "photo_url": "",
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
      });

      nameC.clear();
      emailC.clear();
      passC.clear();
      passReC.clear();

      await userCredential.user!.sendEmailVerification();

      await Get.snackbar(
        "Registration successful",
        "Please check your folder spam  email to verify your account",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        "Failed",
        "Please check your internet connection",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isloading.value = false;
    }
  }

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
}
