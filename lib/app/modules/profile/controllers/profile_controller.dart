import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("users").doc(uid).snapshots();
  }

  RxBool isDark = false.obs;

  void darkMode() {
    isDark.value = true;
    Get.changeThemeMode(ThemeMode.dark);
    print("dada");
  }

  void lightMode() {
    isDark.value = false;
    Get.changeThemeMode(ThemeMode.light);
    print("dadad");
  }
}
