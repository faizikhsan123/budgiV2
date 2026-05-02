import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';

class CompleteBalanceController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final rupiah = Rupiah();

  final balance = TextEditingController();

  Future<void> setBalance(int number) async {
    if (number < 5000) {
      Get.snackbar(
        'failed'.tr,
        'balance_min'.tr,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final uid = auth.currentUser!.uid;
    await firestore.collection("users").doc(uid).update({'balance': number});
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    balance.dispose();
    super.onClose();
  }
}
