import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CompleteBalanceController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final balance = TextEditingController();

  /// ===============================
  /// 💰 SET BALANCE + SELESAI ONBOARDING
  /// ===============================
  Future<void> setBalance(int number) async {
    try {
      final uid = auth.currentUser!.uid;

      if (number < 5000)  {
        await Get.snackbar(
          "Error",
          "Minimal saldo 5000",
        );
        return;
      }

      await firestore.collection("users").doc(uid).set({
        "balance": number,
        "isOnboardingComplete": true,
        "updated_at": Timestamp.now(),
      }, SetOptions(merge: true)); // 🔥 penting!

      /// 🔥 pindah ke home
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print("ERROR SET BALANCE: $e");

      Get.snackbar(
        "Error",
        "Gagal menyimpan saldo",
      );
    }
  }

  @override
  void dispose() {
    balance.dispose();
    super.dispose();
  }
}