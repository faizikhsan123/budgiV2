import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //wajib tambahkan ini
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, //tambahkan inioptions: DefaultFirebaseOptions();
  ); //inisialisasi firebase

  runApp(NyApp());
}

class NyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Application",
          initialRoute: Routes.LOGIN,
          // initialRoute: snapshot.hasData ? Routes.HOME : Routes.LOGIN,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
