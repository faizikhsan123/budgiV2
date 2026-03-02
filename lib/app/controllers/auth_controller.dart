import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); //membuat objek GoogleSignIn

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
    print("Login berhasil");
    print("data dari fb ${userData.toString()}");
    Get.snackbar('Success', 'Login Berhasil');
  } else {
    print("Login gagal");
    print(result.message);
  }
}
}
