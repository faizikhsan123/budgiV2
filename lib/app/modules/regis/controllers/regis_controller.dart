import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RegisController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString nilaiTanggal = "".obs;
  RxBool ishidepass = true.obs;
  RxBool ishidepassreentry = true.obs;

  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController passC;
  late TextEditingController passReC;
  late PhoneNumber phoneC;
  late DateRangePickerController dateC;

  void jalankanRegis() async {
    // 🔎 Cek kosong
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

    // 🔐 Cek password sama
    if (passC.text != passReC.text) {
      Get.snackbar(
        "Error",
        "Password tidak sama",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 📧 Cek email valid
    if (!GetUtils.isEmail(emailC.text.trim())) {
      Get.snackbar(
        "Error",
        "Email tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

   // 📱 Cek phone valid
    if (phoneC.phoneNumber!.length < 13) {
      Get.snackbar(
        "Error",
        "Nomor telepon tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    //cek email sudah ada atau belum 
    QuerySnapshot snapshot = await firestore
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

    // 🔑 Minimal password
    if (passC.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password minimal 6 karakter",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🚀 Kalau semua valid
    await regis(emailC.text.trim(), passC.text.trim());
  }

 Future<void> regis(String email, String pass) async {
  try {
    await auth.signOut();
    UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(
            email: email,
            password: pass,
        );

    String uid = userCredential.user!.uid;

    await firestore.collection("users").doc(uid).set({
      "name": nameC.text,
      "email": emailC.text,
      "phone": phoneC.phoneNumber,
      "tanggal_lahir": nilaiTanggal.value,
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
      "photo_url": null,
      "provider": "password"
    });

    Get.snackbar(
      'Success',
      'Regis Berhasil',
      backgroundColor: Colors.white,
      colorText: Colors.green,
    );

    Get.toNamed(Routes.LOGIN);

  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
}

  @override
  void onInit() {
    // TODO: implement onInit
    nameC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    passReC = TextEditingController();
    phoneC = PhoneNumber();
    dateC = DateRangePickerController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    passReC.dispose();

    dateC.dispose();
    super.dispose();
  }
}
