import 'dart:convert';

import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
  RxBool isloading = false.obs;

  late TextEditingController nameC;
  late TextEditingController emailC;
  final ImagePicker _imagePicker = ImagePicker();

  XFile? pickedImage;
  String? imageUrl;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ── Helper snackbar ───────────────────────────────────────────────────────
  void _snackError(String messageKey) {
    Get.snackbar(
      'failed'.tr,
      messageKey.tr,
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
    );
  }

  void _snackSuccess(String messageKey) {
    Get.snackbar(
      'success'.tr,
      messageKey.tr,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
    );
  }

  // ── Select & upload image ─────────────────────────────────────────────────
  Future<void> selectImage() async {
    try {
      final image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      pickedImage = image;
      Get.back();
      isloading.value = true;

      final newImageUrl = await _uploadImageOnly();

      await _firestore.collection("users").doc(_uid).update({
        'updated_at': Timestamp.now(),
        if (newImageUrl != null) 'photo_url': newImageUrl,
      });

      Get.offAllNamed(Routes.PROFILE);
    } catch (e) {
      _snackError('pick_image_failed');
      pickedImage = null;
    } finally {
      isloading.value = false;
      update();
    }
  }

  // ── Delete image ──────────────────────────────────────────────────────────
  void deleteImage() {
    Get.defaultDialog(
      title: 'delete_photo_title'.tr,
      titlePadding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      middleText: 'delete_photo_confirm'.tr,
      radius: 12,
      backgroundColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
          border: Border.all(color: const Color(0xFFBC9CC6)),
        ),
        child: TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'cancel'.tr,
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
          color: const Color(0xFFBC9CC6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () async {
            await _firestore
                .collection("users")
                .doc(_uid)
                .update({'photo_url': null});
            Get.offAllNamed(Routes.PROFILE);
          },
          child: Text(
            'yes'.tr,
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

  // ── Update profile name ───────────────────────────────────────────────────
  Future<void> updateProfile() async {
    if (nameC.text.trim().length < 3) {
      _snackError('name_min');
      return;
    }

    try {
      isloading.value = true;

      await _firestore.collection("users").doc(_uid).update({
        'name': nameC.text.trim(),
        'updated_at': Timestamp.now(),
      });

      Get.back();
      _snackSuccess('profile_updated');
    } catch (e) {
      _snackError('update_profile_failed');
    } finally {
      isloading.value = false;
    }
  }

  // ── Upload image to Cloudinary ────────────────────────────────────────────
  Future<String?> _uploadImageOnly() async {
    try {
      const cloudName = 'dzfi5acyl';
      const uploadPreset = 'budgiv2';
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
            await http.MultipartFile.fromPath('file', pickedImage!.path));

      final response = await request.send();
      final bytes = await response.stream.toBytes();
      final data = jsonDecode(String.fromCharCodes(bytes));
      return data['secure_url'] as String?;
    } catch (e) {
      _snackError('upload_image_failed');
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    nameC = TextEditingController();
    emailC = TextEditingController();

    final args = Get.arguments as Map<String, dynamic>;
    nameC.text = args['name'] ?? '';
    emailC.text = args['email'] ?? '';
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    super.onClose();
  }
}