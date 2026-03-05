import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(NyApp());
}

class NyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Budgi",
      initialRoute: Routes.PROFILE,
      // home: AuthWrapper(), 
      getPages: AppPages.routes,
    );
  }
}


class AuthWrapper extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ Auto redirect berdasarkan status login
        if (snapshot.hasData) {
          // Sudah login → ke HOME
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.HOME);
          });
        } else {
          // Belum login → ke LOGIN
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.LOGIN);
          });
        }

        // Tampilkan loading sementara redirect
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}