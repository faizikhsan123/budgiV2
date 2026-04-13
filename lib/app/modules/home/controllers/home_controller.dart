import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final pageC = Get.put(PageIndexController());

  void logout() async {
    await auth.signOut();
    Get.offNamed(Routes.LOGIN);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamProfile() {
    final uid = auth.currentUser!.uid;

    return firestore.collection("users").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamTransaction() {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .orderBy("date", descending: true)
        .limit(5)
        .snapshots();
  }

  // STREAM ITEMS BERDASARKAN TANGGAL
  Stream<QuerySnapshot<Map<String, dynamic>>> streamTransactionItem(
    String docId,
  ) {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(docId)
        .collection("items")
        .orderBy("created_at", descending: true)
        .snapshots();
  }
  @override
  void onInit() {
       pageC.pageIndex.value = 0; // ✅ Force reset ke Home saat halaman Home init
    // TODO: implement onInit
    super.onInit();
  }
}
