import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthController extends GetxController {
  RxBool isloading = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  /// ===============================
  /// 🔍 CEK PROVIDER
  /// ===============================
  Future<String?> _getExistingProvider(String email) async {
    final query = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final providers = List<String>.from(
        query.docs.first.data()['providers'] ?? [],
      );
      return providers.isNotEmpty ? providers.first : null;
    }
    return null;
  }

  /// ===============================
  /// 💾 SAVE USER (ANTI RESET)
  /// ===============================
  Future<void> _saveUserIfNotExists({
  required String uid,
  required Map<String, dynamic> data,
  required String provider,
}) async {
  final docRef = firestore.collection("users").doc(uid);
  final doc = await docRef.get();

  if (!doc.exists) {
    /// ✅ USER BARU
    await docRef.set({
      ...data,
      "providers": [provider],
      // ❌ jangan kasih balance default
      // "balance": 0,
      "isOnboardingComplete": false,
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
    });
  } else {
    /// ✅ USER LAMA
    await docRef.set({
      "updated_at": Timestamp.now(),
    }, SetOptions(merge: true));
  }
}

  /// ===============================
  /// 🔁 HANDLE REDIRECT
  /// ===============================
  Future<void> _handleRedirect(String uid) async {
    final doc = await firestore.collection("users").doc(uid).get();
    final data = doc.data();

    if (data == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    final phone = data["phone"];
    final tanggalLahir = data["tanggal_lahir"];
    final balance = data["balance"];

    if (phone == null || tanggalLahir == null) {
      Get.offAllNamed(Routes.COMPLETE_PROFILE);
      return;
    }

    if (balance == null) {
      Get.offAllNamed(Routes.COMPLETE_BALANCE);
      return;
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  /// ===============================
  /// 🔥 LOGIN GOOGLE
  /// ===============================
  Future loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      if (!await _googleSignIn.isSignedIn()) return;

      final email = _currentUser!.email;

      final existingProvider = await _getExistingProvider(email);

      if (existingProvider != null && existingProvider != "google") {
        Get.snackbar(
          '❌ Failed',
          'Please login with $existingProvider',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
        );
        await _googleSignIn.signOut();
        return;
      }

      final googleAuth = await _currentUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final uid = userCredential!.user!.uid;

      await _saveUserIfNotExists(
        uid: uid,
        provider: "google",
        data: {
          "name": _currentUser!.displayName,
          "email": email,
          "photo_url": userCredential!.user!.photoURL,
        },
      );

      await _handleRedirect(uid);
    } catch (e) {
      print("Failed GOOGLE: $e");
    }
  }

  /// ===============================
  /// 🔥 LOGIN FACEBOOK
  /// ===============================
  Future<void> loginFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) return;

      final userData = await FacebookAuth.instance.getUserData();

      final email = userData['email'];
      if (email == null) {
        Get.snackbar('Failed', 'Facebook email is empty');
        await FacebookAuth.instance.logOut();
        return;
      }

      final existingProvider = await _getExistingProvider(email);

      if (existingProvider != null && existingProvider != "facebook") {
        Get.snackbar('❌ Failed', 'Gunakan login $existingProvider');
        await FacebookAuth.instance.logOut();
        return;
      }

      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final uid = userCredential!.user!.uid;

      await _saveUserIfNotExists(
        uid: uid,
        provider: "facebook",
        data: {
          "name": userData['name'],
          "email": email,
          "photo_url": userData['picture']['data']['url'],
        },
      );

      await _handleRedirect(uid);
    } catch (e) {
      print("Failed FACEBOOK: $e");
    }
  }

  /// ===============================
  /// 🔥 LOGIN EMAIL
  /// ===============================
  Future<void> loginForm(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Failed', 'all fields are required');
      return;
    }

    isloading.value = true;

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      final uid = auth.currentUser!.uid;

      await _handleRedirect(uid);
    } catch (e) {
      Get.snackbar('Failed', 'Login failed $e');
    } finally {
      isloading.value = false;
    }
  }

  /// ===============================
  /// 🚪 LOGOUT
  /// ===============================
  void signOut() async {
    await auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();

    Get.offAllNamed(Routes.LOGIN);
  }
}
