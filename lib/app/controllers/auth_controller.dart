import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:lottie/lottie.dart';

class AuthController extends GetxController {
  RxBool isloading = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ✅ Cek email sudah terdaftar di provider lain atau belum
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
    return null; // Email belum terdaftar
  }

  Future<void> _saveUser({
    required String uid,
    required Map<String, dynamic> data,
    required String provider,
  }) async {
    await firestore.collection("users").doc(uid).set({
      ...data,
      "providers": [provider],
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
    });
  }

  void loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isLogin = await _googleSignIn.isSignedIn();
      if (!isLogin) return;

      final email = _currentUser!.email;

      // 🔍 Cek dulu apakah email sudah dipakai provider lain
      final existingProvider = await _getExistingProvider(email);

      if (existingProvider != null && existingProvider != "google") {
        // ❌ Tolak login, tampilkan notif
        Get.snackbar(
          '❌ Email Sudah Terdaftar',
          'Email "$email" sudah digunakan via $existingProvider. '
              'Silakan login menggunakan $existingProvider.',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
        );
        await _googleSignIn.signOut(); // Pastikan Google session dibersihkan
        return; // 🚫 Stop, tidak lanjut ke Firebase Auth
      }

      // ✅ Email aman, lanjut login
      final googleAuth = await _currentUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => userCredential = value);

      final uid = userCredential!.user!.uid;

      await _saveUser(
        uid: uid,
        provider: "google",
        data: {
          "name": _currentUser!.displayName,
          "email": email,
          "balance": 0,
          "phone": null,
          "tanggal_lahir": null,
          "photo_url": userCredential!.user!.photoURL,
        },
      );

      Get.offAllNamed(Routes.COMPLETE_PROFILE);
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        print("Login gagal: ${result.message}");
        Get.snackbar(
          'Error',
          'Login Gagal',
          backgroundColor: Colors.white,
          colorText: Colors.red,
        );
        return;
      }

      // ✅ Step 1: Ambil userData dari Facebook
      final userData = await FacebookAuth.instance.getUserData();
      print("FB USER DATA: $userData");

      final email = userData['email'];
      if (email == null) {
        Get.snackbar(
          '❌ Error',
          'Akun Facebook tidak memiliki email.',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
        );
        await FacebookAuth.instance.logOut();
        return;
      }

      // ✅ Step 2: Cek email di Firestore
      final existingProvider = await _getExistingProvider(email);
      if (existingProvider != null && existingProvider != "facebook") {
        Get.snackbar(
          '❌ Email Sudah Terdaftar',
          'Email "$email" sudah digunakan via $existingProvider. '
              'Silakan login menggunakan $existingProvider.',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
        );
        await FacebookAuth.instance.logOut();
        return;
      }

      // ✅ Step 3: Login ke Firebase Auth pakai token Facebook
      final accessToken = result.accessToken!;
      final facebookCredential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      userCredential = await FirebaseAuth.instance.signInWithCredential(
        facebookCredential,
      ); // ← login dulu baru ambil uid

      final uid = userCredential!.user!.uid; // ← baru aman dipakai

      // ✅ Step 4: Simpan ke Firestore
      await _saveUser(
        uid: uid,
        provider: "facebook",
        data: {
          "name": userData['name'],
          "email": email,
          "phone": null,
          "tanggal_lahir": null,
          "balance": 0,
          "photo_url": userData['picture']['data']['url'],
        },
      );

      print("data dari fb: ${userData.toString()}");

      Get.offAllNamed(Routes.COMPLETE_PROFILE);
    } catch (e) {
      print("ERROR FACEBOOK LOGIN: $e");
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    }
  }

  Future<void> loginFOrm(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field wajib diisi',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isloading.value = true;

    try {
      await Future.delayed(Duration(seconds: 1)); // supaya lottie terlihat

      await auth.signInWithEmailAndPassword(email: email, password: password);

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Login Gagal',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isloading.value = false;
    }
  }
}
