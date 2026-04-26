import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final RxString nilaiTanggal = "".obs;
  final searchC = TextEditingController();
  final RxString keyword = "".obs;
  final Rx<DateTime?> start = Rx<DateTime?>(null);
  final Rx<DateTime?> end = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    nilaiTanggal.value = 'all'.tr;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> transactionsStream() {
    final uid = auth.currentUser!.uid;

    if (start.value != null) {
      final effectiveEnd = (end.value ?? DateTime.now()).add(
        const Duration(days: 1),
      );
      return firestore
          .collection("users")
          .doc(uid)
          .collection("all_transactions")
          .where("filter_tanggal",
              isGreaterThanOrEqualTo: start.value!.toIso8601String())
          .where("filter_tanggal",
              isLessThan: effectiveEnd.toIso8601String())
          .orderBy("filter_tanggal", descending: true)
          .snapshots();
    }

    return firestore
        .collection("users")
        .doc(uid)
        .collection("all_transactions")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  List<Map<String, dynamic>> filterDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final key = keyword.value.trim().toLowerCase();
    if (key.isEmpty) return docs.map((e) => e.data()).toList();

    return docs.where((doc) {
      final data = doc.data();
      final searchText =
          '${(data['category'] ?? '').toString().toLowerCase()} '
          '${(data['notes'] ?? '').toString().toLowerCase()}';
      final words = key.split(' ').where((w) => w.isNotEmpty).toList();
      return words.every((word) => searchText.contains(word));
    }).map((e) => e.data()).toList();
  }

  void search(String value) => keyword.value = value;

  void pickDateRange(DateTime startDate, DateTime endDate) {
    start.value = DateTime(startDate.year, startDate.month, startDate.day);
    end.value = DateTime(endDate.year, endDate.month, endDate.day);

    nilaiTanggal.value = startDate == endDate
        ? DateFormat('d MMM yyyy').format(startDate)
        : '${DateFormat('d MMM').format(startDate)} - '
            '${DateFormat('d MMM yyyy').format(endDate)}';

    Get.back();
  }

  void resetFilter() {
    start.value = null;
    end.value = null;
    keyword.value = "";
    searchC.clear();
    nilaiTanggal.value = 'all'.tr;
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}