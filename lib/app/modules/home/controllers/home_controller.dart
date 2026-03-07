import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void logout() async {
    await auth.signOut();
    Get.offNamed(Routes.LOGIN);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamProfile() {
    final uid = auth.currentUser!.uid;
    return firestore.collection("users").doc(uid).snapshots();
  }
}
