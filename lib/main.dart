import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //wajib tambahkan ini
  await Firebase.initializeApp(); //inisialisasi firebase
  final authC = Get.put(AuthController(), permanent: true);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Application",
      initialRoute: Routes.PROFILE,
      getPages: AppPages.routes,
    ),
  );
}
