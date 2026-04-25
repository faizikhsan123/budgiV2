import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
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
    box.write('isDark', true);
    print("dada");
  }

  void lightMode() {
    isDark.value = false;
    Get.changeThemeMode(ThemeMode.light);
    box.write('isDark', false);
    print("dadad");
  }

  @override
  void onInit() {
    super.onInit();
    // Load saved theme saat controller pertama kali dibuat
    final savedDark = box.read<bool>('isDark') ?? false;
    isDark.value = savedDark;
    Get.changeThemeMode(savedDark ? ThemeMode.dark : ThemeMode.light);
  }
}
