import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CompleteBalanceController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final balance = TextEditingController();

  Future<void> setBalance(int number) async {
    final uid = auth.currentUser!.uid;

    if (number < 5000) {
      Get.snackbar(
        "Failed",
        "Balance must be at least 5000",
         backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
      );
      return;
    }
    await firestore.collection("users").doc(uid).update({'balance': number});
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    balance.dispose();

    // TODO: implement dispose
    super.dispose();
  }
}
