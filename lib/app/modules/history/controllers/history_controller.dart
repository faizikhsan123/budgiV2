import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString nilaiTanggal = "All".obs;

  final searchC = TextEditingController();

  RxString keyword = "".obs;
  Rx<DateTime?> start = Rx<DateTime?>(null);
  Rx<DateTime?> end = Rx<DateTime?>(null);

  // Stream semua data, filter dilakukan di Flutter
  Stream<QuerySnapshot<Map<String, dynamic>>> transactionsStream() {
    String uid = auth.currentUser!.uid;

    Query<Map<String, dynamic>> query = firestore
        .collection("users")
        .doc(uid)
        .collection("all_transactions")
        .orderBy("created_at", descending: true);

    final DateTime? startDate = start.value;
    final DateTime? endDate = end.value;

    if (startDate != null) {
      final DateTime effectiveEnd = (endDate ?? DateTime.now()).add(
        const Duration(days: 1),
      );

      query = firestore
          .collection("users")
          .doc(uid)
          .collection("all_transactions")
          .where(
            "filter_tanggal",
            isGreaterThanOrEqualTo: startDate.toIso8601String(),
          )
          .where("filter_tanggal", isLessThan: effectiveEnd.toIso8601String())
          .orderBy("filter_tanggal", descending: true);
    }

    return query.snapshots();
  }

  // Filter dilakukan di sini — supports "contains" dan multi-kata
  List<Map<String, dynamic>> filterDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final String key = keyword.value.trim().toLowerCase();

    if (key.isEmpty) return docs.map((e) => e.data()).toList();

    return docs
        .where((doc) {
          final data = doc.data();
          final category = (data['category'] ?? '').toString().toLowerCase();
          final notes = (data['notes'] ?? '').toString().toLowerCase();
          final searchText = "$category $notes";

          // Supports multi-kata: "ayam geprek" → cari "ayam" DAN "geprek"
          final words = key.split(' ').where((w) => w.isNotEmpty).toList();
          return words.every((word) => searchText.contains(word));
        })
        .map((e) => e.data())
        .toList();
  }

  void search(String value) {
    keyword.value = value;
  }

  void pickDateRange(DateTime startDate, DateTime endDate) {
    start.value = DateTime(startDate.year, startDate.month, startDate.day);
    end.value = DateTime(endDate.year, endDate.month, endDate.day);

    // Update label dinamis
    if (startDate == endDate) {
      nilaiTanggal.value = DateFormat('d MMM yyyy').format(startDate);
    } else {
      nilaiTanggal.value =
          '${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM yyyy').format(endDate)}';
    }

    Get.back();
  }

  void resetFilter() {
    start.value = null;
    end.value = null;
    keyword.value = "";
    searchC.clear();
    nilaiTanggal.value = "All"; // reset ke default
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
