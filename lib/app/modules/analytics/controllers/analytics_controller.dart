import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  RxString transactionType = "expense".obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? start;
  DateTime? end = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void liatExpense() {
    transactionType.value = "expense";
  }

  void liatIncome() {
    transactionType.value = "income";
  }

  void pickDateRange(DateTime startDate, DateTime endDate) {
    start = startDate;
    end = endDate;
    update(); // biar GetBuilder rebuild
    Get.back();
  }

  /// ambil semua transaksi
  Stream<QuerySnapshot<Map<String, dynamic>>> datatransaksi() {
    final uid = auth.currentUser!.uid;
    if (start == null) {
      return firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .orderBy("filter_tanggal", descending: true)
          .snapshots();
    } else {
      return firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .where(
            "filter_tanggal",
            isGreaterThanOrEqualTo: start!.toIso8601String(),
          )
          .where(
            "filter_tanggal",
            isLessThan: end!.add(const Duration(days: 1)).toIso8601String(),
          )
          .orderBy("filter_tanggal", descending: true)
          .snapshots();
    }
  }

  /// STREAM EXPENSE
  Stream<QuerySnapshot<Map<String, dynamic>>> streamExpenseItem(String docId) {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(docId)
        .collection("items")
        .where("type", isEqualTo: "expense")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  /// STREAM INCOME

  Stream<QuerySnapshot<Map<String, dynamic>>> streamIncomeItem(String docId) {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(docId)
        .collection("items")
        .where("type", isEqualTo: "income")
        .orderBy("created_at", descending: true)
        .snapshots();
  }
}
