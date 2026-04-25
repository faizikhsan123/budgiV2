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
  RxString currentLang = 'id'.obs; // ← ganti jadi RxString biar bisa 5 bahasa

  void darkMode() {
    isDark.value = true;
    Get.changeThemeMode(ThemeMode.dark);
    box.write('isDark', true);
  }

  void lightMode() {
    isDark.value = false;
    Get.changeThemeMode(ThemeMode.light);
    box.write('isDark', false);
  }

  void _changeLang(String langCode, String countryCode) {
    currentLang.value = langCode;
    box.write('lang', langCode);
    Get.updateLocale(Locale(langCode, countryCode));
  }

  void bahasaindo()    => _changeLang('id', 'ID');
  void bahasainggris() => _changeLang('en', 'US'); // ← fix bug: tadi value nya salah
  void bahasaspanyol() => _changeLang('es', 'ES');
  void bahasamandarin() => _changeLang('zh', 'CN');

  @override
  void onInit() {
    super.onInit();
    final savedDark = box.read<bool>('isDark') ?? false;
    final savedLang = box.read<String>('lang') ?? 'id'; // ← baca string

    isDark.value = savedDark;
    currentLang.value = savedLang;

    Get.changeThemeMode(savedDark ? ThemeMode.dark : ThemeMode.light);

    // map langCode ke countryCode
    final localeMap = {
      'id': const Locale('id', 'ID'),
      'en': const Locale('en', 'US'),
      'es': const Locale('es', 'ES'),
      'ar': const Locale('ar', 'SA'),
      'zh': const Locale('zh', 'CN'),
    };
    Get.updateLocale(localeMap[savedLang] ?? const Locale('id', 'ID'));
  }
}