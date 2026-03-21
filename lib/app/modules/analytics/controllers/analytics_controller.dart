import 'dart:ui';

import 'package:budgi/app/modules/analytics/views/analytics_view.dart';
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

  /// Stream agregasi chart per kategori (expense atau income)
  Stream<List<CategoryData>> streamChartData() async* {
    final uid = auth.currentUser!.uid;
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
      const Color(0xFFFF5722),
      const Color(0xFFFFEB3B),
    ];

    await for (final txSnap in datatransaksi()) {
      final docs = txSnap.docs;
      if (docs.isEmpty) {
        yield [];
        continue;
      }

      // ── INCOME: 1 bar total ──────────────────────────────
      if (transactionType.value == "income") {
        double totalIncome = 0;

        for (final doc in docs) {
          final itemsSnap = await firestore
              .collection("users")
              .doc(uid)
              .collection("transactions")
              .doc(doc.id)
              .collection("items")
              .where("type", isEqualTo: "income")
              .get();

          for (final item in itemsSnap.docs) {
            totalIncome += (item['amount'] as num).toDouble();
          }
        }

        if (totalIncome == 0) {
          yield [];
          continue;
        }

        yield [
          CategoryData('Total Income', totalIncome, const Color(0xFF4CAF50)),
        ];
        continue;
      }

      // ── EXPENSE: per kategori ────────────────────────────
      final Map<String, double> categoryTotals = {};

      for (final doc in docs) {
        final itemsSnap = await firestore
            .collection("users")
            .doc(uid)
            .collection("transactions")
            .doc(doc.id)
            .collection("items")
            .where("type", isEqualTo: "expense")
            .get();

        for (final item in itemsSnap.docs) {
          final category = item['category'] as String;
          final amount = (item['amount'] as num).toDouble();
          categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
        }
      }

      if (categoryTotals.isEmpty) {
        yield [];
        continue;
      }

      final sorted = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      yield sorted.asMap().entries.map((entry) {
        return CategoryData(
          entry.value.key,
          entry.value.value,
          colors[entry.key % colors.length],
        );
      }).toList();
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
        .where("type", isEqualTo: transactionType.value)
        .orderBy("created_at", descending: true)
        .snapshots();
  }
}
