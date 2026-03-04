import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); //membuat objek GoogleSignIn
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _currentUser; //untuk menyimpan data akun Google user

  UserCredential? userCredential; //userCredential
  void loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isLogin = await _googleSignIn.isSignedIn();

      if (isLogin) {
        print("sudah berhasil login");
        print(_currentUser);

        final gooleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: gooleAuth.idToken,
          accessToken: gooleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print(" data dari goggle : $userCredential");

        final uid = userCredential!.user!.uid;

       final photoUrl = userCredential!.user!.photoURL;

        firestore.collection("users").doc(uid).set({
          "name": _currentUser!.displayName,
          "email": _currentUser!.email,
          "phone": _currentUser!.photoUrl,
          "tanggal_lahir": null, //null
          "created_at": Timestamp.now(),
          "updated_at": Timestamp.now(),
          "photo_url": photoUrl,
          "provider": "google",
        });

        Get.snackbar(
          'Success',
          'Berhasil Login',
          backgroundColor: Colors.white,
          colorText: Colors.green,
        );

        Get.toNamed(Routes.HOME);
      } else {
        print("gagal login");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      final uid = userCredential!.user!.uid;

      firestore.collection("users").doc(uid).set({
        "name": userData['name'],
        "email": userData['email'],
        "phone": null,
        "tanggal_lahir": null, //null
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
        "photo_url": userData['picture']['data']['url'],
        "provider": "facebook",
      });

      print("data dari fb ${userData.toString()}");
      Get.snackbar(
        'Success',
        'Login Berhasil',
        backgroundColor: Colors.white,
        colorText: Colors.green,
      );
      Get.offAllNamed(Routes.HOME);
    } else {
      print("Login gagal");
      print(result.message);
    }
  }
}
