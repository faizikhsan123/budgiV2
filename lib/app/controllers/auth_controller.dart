import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  RxBool isloading = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _saveUserIfNotExists({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final docRef = firestore.collection("users").doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        ...data,
        "provider": "google",
        "isOnboardingComplete": false,
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
      });
    } else {
      await docRef.set({
        "updated_at": Timestamp.now(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> _handleRedirect(String uid) async {
    final doc = await firestore.collection("users").doc(uid).get();
    final data = doc.data();

    if (data == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    final balance = data["balance"];

    if (balance == null) {
      Get.offAllNamed(Routes.COMPLETE_BALANCE);
      return;
    }

    Get.offAllNamed(Routes.HOME);
  }

  Future<void> loginWithGoogle() async {
    try {
      isloading.value = true;

      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isloading.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user!;
      final uid = user.uid;

      await _saveUserIfNotExists(
        uid: uid,
        data: {
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          "photo_url": user.photoURL ?? "",
        },
      );

      await _handleRedirect(uid);
    } catch (e) {
      print("Failed GOOGLE: $e");
      Get.snackbar(
        "Failed",
        "Google login failed",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isloading.value = false;
    }
  }

  Future<void> loginForm(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Failed', 'All fields are required');
      return;
    }

    isloading.value = true;

    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      await user.reload(); // refresh status verify
      final freshUser = auth.currentUser!;

      if (!freshUser.emailVerified) {
        await auth.signOut(); // 🔥 penting
        Get.snackbar('Failed', 'Please verify your email check your inbox / spam ');
        return;
      }

      await _handleRedirect(freshUser.uid);
    } catch (e) {
      Get.snackbar('Failed', 'Login failed');
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
