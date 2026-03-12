import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
  RxString nilaiTanggal = "".obs;
  RxBool isloading = false.obs;

  late TextEditingController nameC;

  late DateRangePickerController dateC;
  late TextEditingController emailC;
  late ImagePicker imagePicker = ImagePicker();

  XFile? pickedIMage;
  String? imageurl;
  TextEditingController phoneTextC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  PhoneNumber phoneC = PhoneNumber(isoCode: 'ID');

  void selectImage() async {
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        //ketika user memilih gambar
        pickedIMage = image;
      }
      update(); //untuk memperbarui karena pakai get buildeedr
    } catch (e) {
      //kalo user klik cancel pada pemilihan gamabar
      Get.snackbar('gagal', 'anda tidak bisa mengambil gambar $e');
      pickedIMage = null;
      update();
    }
  }

  Future uploadImage() async {
    if (pickedIMage == null) return; // kalau tidak ada gambar, langsung stop

    try {
      String uid = auth.currentUser!.uid;

      String cloudName = 'dzfi5acyl';
      String uploadPreset = 'budgiv2';

      var url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath('file', pickedIMage!.path),
      );

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = jsonDecode(responseString);

      imageurl = data['secure_url'];

      await firestore.collection("users").doc(uid).update({
        'photo_url': imageurl,
      });
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Upload gambar gagal $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void deleteImage() {
    Get.defaultDialog(
      title: "Delete Image",
      middleText: "Anda yakin ingin menghapus gambar ini?",
      backgroundColor: Colors.white,
      radius: 10,
      textCancel: "No",

      textConfirm: "Yes",

      onConfirm: () async {
        await firestore.collection("users").doc(auth.currentUser!.uid).update({
          'photo_url': null,
        });
        Get.back();
        Get.back();
      },
    );
  }

  Future updateProfile() async {
    try {
      isloading.value = true;
      final uid = auth.currentUser!.uid;

      // Upload gambar dulu (parallel bisa pakai Future.wait jika ada banyak)
      String? newImageUrl;
      if (pickedIMage != null) {
        newImageUrl =
            await _uploadImageOnly(); // return URL, jangan update Firestore di sini
      }

      await firestore.collection("users").doc(uid).update({
        'name': nameC.text,
        'phone': phoneC.phoneNumber,
        'tanggal_lahir': nilaiTanggal.value,
        'updated_at': Timestamp.now(),
        if (newImageUrl != null) 'photo_url': newImageUrl,
      });

      Get.back();
      Get.snackbar(
        'Success',
        'Profile Updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal update profile $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isloading.value = false; // jangan lupa reset
    }
  }

  // Pisahkan fungsi upload — hanya return URL, tidak update Firestore
  Future<String?> _uploadImageOnly() async {
    try {
      String cloudName = 'dzfi5acyl';
      String uploadPreset = 'budgiv2';
      var url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', pickedIMage!.path),
      );

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var data = jsonDecode(String.fromCharCodes(responseData));
      return data['secure_url'];
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Upload gambar gagal $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
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
