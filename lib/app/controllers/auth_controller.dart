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
      await docRef.set({"updated_at": Timestamp.now()}, SetOptions(merge: true));
    }
  }

  Future<void> _handleRedirect(String uid) async {
    final doc = await firestore.collection("users").doc(uid).get();
    final balance = doc.data()?["balance"];

    if (!doc.exists || doc.data() == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    Get.offAllNamed(balance == null ? Routes.COMPLETE_BALANCE : Routes.HOME);
  }

  Future<void> loginWithGoogle() async {
    try {
      isloading.value = true;
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user!;

      await _saveUserIfNotExists(
        uid: user.uid,
        data: {
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          "photo_url": user.photoURL ?? "",
        },
      );

      await _handleRedirect(user.uid);
    } catch (e) {
      Get.snackbar(
        'failed'.tr,
        'google_login_failed'.tr,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isloading.value = false;
    }
  }

  Future<void> loginForm(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'failed'.tr,
        'fields_required'.tr,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isloading.value = true;
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.reload();
      final freshUser = auth.currentUser!;

      if (!freshUser.emailVerified) {
        await auth.signOut();
        Get.snackbar(
          'failed'.tr,
          'verify_email'.tr,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
        );
        return;
      }

      await _handleRedirect(freshUser.uid);
    } catch (e) {
      Get.snackbar('failed'.tr, 'login_failed'.tr);
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signOut() async {
    await Future.wait([auth.signOut(), _googleSignIn.signOut()]);
    Get.offAllNamed(Routes.LOGIN);
  }
}