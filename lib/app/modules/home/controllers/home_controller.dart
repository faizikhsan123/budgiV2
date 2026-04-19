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

  /// Ambil 20 transaksi terbaru dari all_transactions
  /// Group by tanggal dilakukan di View
  Stream<QuerySnapshot<Map<String, dynamic>>> streamRecentTransactions() {
    final uid = auth.currentUser!.uid;
    return firestore
        .collection("users")
        .doc(uid)
        .collection("all_transactions")
        .orderBy("created_at", descending: true)
        .limit(5)
        .snapshots();
  }

  /// Group docs by tanggal → Map<"19-4-2026", [item, item, ...]>
  Map<String, List<Map<String, dynamic>>> groupByDate(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var doc in docs) {
      final data = doc.data();
      final String date = data['date'] ?? '';
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(data);
    }
    return grouped;
  }

  @override
  void onInit() {
    pageC.pageIndex.value = 0;
    super.onInit();
  }
}