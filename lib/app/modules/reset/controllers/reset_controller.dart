import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ResetController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final email = TextEditingController();

  void resetPassword(String email) async {
    email = email.trim();
    if (email.isEmpty) {
      Get.snackbar(
        "Failed",
        "Email is required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Failed",
        "Invalid email format",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await auth.sendPasswordResetEmail(email: email);
    Get.snackbar(
      "Success",
      "Password reset email sent to $email",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.offAllNamed(Routes.LOGIN);
  }
}
