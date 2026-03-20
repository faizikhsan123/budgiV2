import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isHide = true.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late TextEditingController emailC;
  late TextEditingController passC;

  @override
  void onInit() {
    emailC = TextEditingController();
    passC = TextEditingController();
    isHide.value = true;

    super.onInit();
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    isHide.value = true;

    super.dispose();
  }

 
}
