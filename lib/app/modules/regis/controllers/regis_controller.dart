import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RegisController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxBool isloading = false.obs;
  RxString nilaiTanggal = "".obs;
  RxBool ishidepass = true.obs;
  RxBool ishidepassreentry = true.obs;

  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController passC;
  late TextEditingController passReC;
  late PhoneNumber phoneC;
  late DateRangePickerController dateC;

  // ─── Validasi semua field, lalu panggil regis() ──────────────────────────────
  Future<void> jalankanRegis() async {
    // Cek field kosong
    if (nameC.text.trim().isEmpty ||
        emailC.text.trim().isEmpty ||
        passC.text.trim().isEmpty ||
        passReC.text.trim().isEmpty ||
        phoneC.phoneNumber == null ||
        nilaiTanggal.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek email valid
    if (!GetUtils.isEmail(emailC.text.trim())) {
      Get.snackbar(
        "Error",
        "Email tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek password minimal 6 karakter
    if (passC.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password minimal 6 karakter",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek password sama
    if (passC.text != passReC.text) {
      Get.snackbar(
        "Error",
        "Password tidak sama",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek nomor telepon valid
    if (phoneC.phoneNumber!.length < 13) {
      Get.snackbar(
        "Error",
        "Nomor telepon tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek email sudah dipakai — ini async, tapi belum perlu loading
    // karena masih tahap validasi
    final QuerySnapshot snapshot = await firestore
        .collection("users")
        .where("email", isEqualTo: emailC.text.trim())
        .get();

    if (snapshot.docs.isNotEmpty) {
      Get.snackbar(
        "Error",
        "Email sudah digunakan",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Semua validasi lolos — baru jalankan registrasi
    await _regis(emailC.text.trim(), passC.text.trim());
  }

  // ─── Proses registrasi — loading hanya di sini ───────────────────────────────
  Future<void> _regis(String email, String pass) async {
    isloading.value = true; // ✅ loading dimulai saat proses beneran

    try {
      await auth.signOut();

      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final String uid = userCredential.user!.uid;

      await firestore.collection("users").doc(uid).set({
        "name": nameC.text.trim(),
        "email": emailC.text.trim(),
        "phone": phoneC.phoneNumber,
        "tanggal_lahir": nilaiTanggal.value,
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
        "photo_url": null,
        "provider": "password",
         "balance": 0,
      });

      // Bersihkan form
      nameC.clear();
      emailC.clear();
      passC.clear();
      passReC.clear();
      nilaiTanggal.value = "";

      Get.snackbar(
        'Success',
        'Registrasi berhasil',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.toNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isloading.value = false; // ✅ selalu reset, sukses maupun error
    }
  }

  // ─── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    nameC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    passReC = TextEditingController();
    phoneC = PhoneNumber(isoCode: 'ID');
    dateC = DateRangePickerController();
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    passReC.dispose();
    dateC.dispose();
    super.dispose();
  }
}