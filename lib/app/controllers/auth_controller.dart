import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ================================
  // GOOGLE LOGIN
  // ================================
  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await auth.signInWithCredential(credential);

      await _handleUserData(userCredential);

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print("Google Login Error: $e");
    }
  }
  Future<void> loginFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) return;

      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      final userCredential =
          await auth.signInWithCredential(credential);

      await _handleUserData(userCredential);

      Get.offAllNamed(Routes.HOME);
      Get.snackbar('berhasil', 'berhasil login');
    } catch (e) {
      print("Facebook Login Error: $e");
    }
  }

  Future<void> login(String email, String pass) async {
    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "Semua field wajib diisi",
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: pass);

      await _handleUserData(userCredential);

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print("Email Login Error: $e");
      Get.snackbar("Error", "Login Gagal",
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }


  Future<void> _handleUserData(UserCredential userCredential) async {
    final user = userCredential.user!;
    final uid = user.uid;

    final isNewUser =
        userCredential.additionalUserInfo?.isNewUser ?? false;

    if (isNewUser) {
      await firestore.collection("users").doc(uid).set({
        "name": user.displayName,
        "email": user.email,
        "phone": user.phoneNumber,
        "photo_url": user.photoURL,
        "tanggal_lahir": null,
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
      });
    } else {
      await firestore.collection("users").doc(uid).set({
        "last_login_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
      }, SetOptions(merge: true));
    }
  }
}