import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditProfileController extends GetxController {
  RxString nilaiTanggal = "".obs;

  late TextEditingController nameC;

  late DateRangePickerController dateC;
  late TextEditingController emailC;
  TextEditingController phoneTextC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  PhoneNumber phoneC = PhoneNumber(isoCode: 'ID');

  Future updateProfile() async {
    final uid = auth.currentUser!.uid;
    await firestore.collection("users").doc(uid).update({
      'name': nameC.text,
      'phone': phoneC.phoneNumber,
      'tanggal_lahir': nilaiTanggal.value,
      'updated_at': Timestamp.now(),
    });
    Get.back();
    Get.snackbar(
      'success',
      'Profile Updated',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onInit() {
    nameC = TextEditingController();
    emailC = TextEditingController();
    phoneC = PhoneNumber();
    dateC = DateRangePickerController();
    final dataArgument = Get.arguments as Map<String, dynamic>;

    nameC.text = dataArgument['name'];
    emailC.text = dataArgument['email'];
    nilaiTanggal.value = dataArgument['tanggal_lahir'];

    String phone = dataArgument['phone'];

    phoneC = PhoneNumber(phoneNumber: phone, isoCode: 'ID');

    /// hilangkan kode negara
    phoneTextC.text = phone.replaceFirst(RegExp(r'^\+\d{1,2}'), '');

    super.onInit();
    // TODO: implement onInit
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    dateC.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
