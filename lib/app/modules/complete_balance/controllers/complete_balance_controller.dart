import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CompleteBalanceController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final balance = TextEditingController();
  
  Future<void> setBalance(int number) async {                                                                                             
    final uid = auth.currentUser!.uid;
    await firestore.collection("users").doc(uid).update({
      'balance': number,
    });
    Get.offAllNamed(Routes.HOME);
  }
}
