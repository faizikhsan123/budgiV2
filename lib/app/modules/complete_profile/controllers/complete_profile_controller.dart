import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';

class CompleteProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString nilaiTanggal = "".obs;
  RxBool isloading = false.obs;
  late PhoneNumber phoneC;
  late DateRangePickerController dateC;

  void LengkapiProfile() {
    isloading.value = true;
    if (phoneC.phoneNumber!.length < 13) {
      Get.snackbar(
        "Error",
        "Nomor telepon tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isloading.value = false;
      return;
      
    }

    if (nilaiTanggal.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Tanggal lahir tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isloading.value = false;
      return;
    }

    final uid = auth.currentUser!.uid;
    firestore.collection("users").doc(uid).update({
      'phone': phoneC.phoneNumber,
      'tanggal_lahir': nilaiTanggal.value,
    });
    Get.offAllNamed(Routes.COMPLETE_BALANCE);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    dateC = DateRangePickerController();
    phoneC = PhoneNumber();
    super.onInit();
  }

  @override
  void dispose() {
    dateC.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
