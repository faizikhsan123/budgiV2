import 'dart:convert';

import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future selectImage() async {
    try {
      final uid = auth.currentUser!.uid;
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        //ketika user memilih gambar
        pickedIMage = image;
        // Upload gambar dulu (parallel bisa pakai Future.wait jika ada banyak)
        String? newImageUrl;
        if (pickedIMage != null) {
          Get.back();
          isloading.value = true;
          newImageUrl =
              await _uploadImageOnly(); // return URL, jangan update Firestore di sini
        }

        await firestore.collection("users").doc(uid).update({
          'updated_at': Timestamp.now(),
          if (newImageUrl != null) 'photo_url': newImageUrl,
        });
        Get.offAllNamed(Routes.PROFILE);
      }
      update(); //untuk memperbarui karena pakai get buildeedr
    } catch (e) {
      //kalo user klik cancel pada pemilihan gamabar
      Get.snackbar('Failed', 'You cannot pick the image');
      pickedIMage = null;
      update();
    }
  }

  void deleteImage() {
    Get.defaultDialog(
      title: "Delete?",
      titlePadding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      middleText: " Are you sure you want to delete your profile photo?",
      radius: 12,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),

      titleStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      cancel: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFBC9CC6)),
        ),
        child: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),

      confirm: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xFFBC9CC6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () async {
            // update balance
            await firestore
                .collection("users")
                .doc(auth.currentUser!.uid)
                .update({'photo_url': null});
            Get.offAllNamed(Routes.PROFILE);
          },
          child: Text(
            "Yes",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future updateProfile() async {
    try {
      isloading.value = true;
      final uid = auth.currentUser!.uid;

      await firestore.collection("users").doc(uid).update({
        'name': nameC.text,
        'phone': phoneC.phoneNumber,
        'tanggal_lahir': nilaiTanggal.value,
        'updated_at': Timestamp.now(),
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
        'Failed to update profile ',
        'Please, check your internet connection',
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
        'Failed to upload image',
        'Please, check your internet connection',
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
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Dispose all the controllers and text editing controllers.
  /*******  780a78d6-fab5-4f36-a4f3-c9bf5f08cc1c  *******/
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    dateC.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
