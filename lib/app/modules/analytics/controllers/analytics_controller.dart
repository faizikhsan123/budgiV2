import 'dart:ui';

import 'package:budgi/app/modules/analytics/views/analytics_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnalyticsController extends GetxController {
  RxString transactionType = "expense".obs;
  RxString nilaiTanggal = "".obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? start;
  DateTime? end = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    nilaiTanggal.value = 'All Time';
  }

  Future<void> resetForm() async {
    Future.delayed(const Duration(seconds: 1), () {
      nilaiTanggal.value = DateFormat('dd-M-yyyy').format(DateTime.now());
    });
  }

  void liatExpense() => transactionType.value = "expense";
  void liatIncome()  => transactionType.value = "income";

  void pickDateRange(DateTime startDate, DateTime endDate) {
    start = startDate;
    end = endDate;
    update();
    Get.back();
  }

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
          .where("filter_tanggal", isGreaterThanOrEqualTo: start!.toIso8601String())
          .where("filter_tanggal",
              isLessThan: end!.add(const Duration(days: 1)).toIso8601String())
          .orderBy("filter_tanggal", descending: true)
          .snapshots();
    }
  }

  Future<Map<String, double>> getChartMetrics() async {
    final uid = auth.currentUser!.uid;
    double totalIncome = 0;
    double totalExpense = 0;

    final txSnap = await datatransaksi().first;
    for (final doc in txSnap.docs) {
      final incomeSnap = await firestore
          .collection("users").doc(uid).collection("transactions")
          .doc(doc.id).collection("items")
          .where("type", isEqualTo: "income").get();
      for (final item in incomeSnap.docs) {
        totalIncome += (item['amount'] as num).toDouble();
      }

      final expenseSnap = await firestore
          .collection("users").doc(uid).collection("transactions")
          .doc(doc.id).collection("items")
          .where("type", isEqualTo: "expense").get();
      for (final item in expenseSnap.docs) {
        totalExpense += (item['amount'] as num).toDouble();
      }
    }

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'balance': totalIncome - totalExpense,
    };
  }

  Future<Map<String, double>> calculateTotals() async => getChartMetrics();

  /// Persentase tiap kategori EXPENSE dari total expense
  Future<Map<String, double>> getCategoryPercentages() async {
    final uid = auth.currentUser!.uid;
    final Map<String, double> totals = {};
    double grand = 0;

    final txSnap = await datatransaksi().first;
    for (final doc in txSnap.docs) {
      final snap = await firestore
          .collection("users").doc(uid).collection("transactions")
          .doc(doc.id).collection("items")
          .where("type", isEqualTo: "expense").get();
      for (final item in snap.docs) {
        final cat = item['category'] as String;
        final amt = (item['amount'] as num).toDouble();
        totals[cat] = (totals[cat] ?? 0) + amt;
        grand += amt;
      }
    }

    if (grand == 0) return {};
    return totals.map((k, v) => MapEntry(k, (v / grand) * 100));
  }

  /// Persentase tiap kategori INCOME dari total income
  Future<Map<String, double>> getIncomeCategoryPercentages() async {
    final uid = auth.currentUser!.uid;
    final Map<String, double> totals = {};
    double grand = 0;

    final txSnap = await datatransaksi().first;
    for (final doc in txSnap.docs) {
      final snap = await firestore
          .collection("users").doc(uid).collection("transactions")
          .doc(doc.id).collection("items")
          .where("type", isEqualTo: "income").get();
      for (final item in snap.docs) {
        final cat = item['category'] as String;
        final amt = (item['amount'] as num).toDouble();
        totals[cat] = (totals[cat] ?? 0) + amt;
        grand += amt;
      }
    }

    if (grand == 0) return {};
    return totals.map((k, v) => MapEntry(k, (v / grand) * 100));
  }

  Color getExpenseCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "food":      return const Color(0xFFFF9800);
      case "transport": return const Color(0xFF2196F3);
      case "health":    return const Color(0xFF4CAF50);
      case "bill":      return const Color(0xFFE91E63);
      case "shopping":  return const Color(0xFFFF5D78);
      case "transfer":  return const Color.fromARGB(255, 240, 224, 85);
      case "entertain": return const Color(0xFF9C27B0);
      case "other":     return const Color(0xFFC2C2C2);
      default:          return const Color(0xFF8D8D8D);
    }
  }

  Color getIncomeCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "salary":     return const Color(0xFF4CAF50);
      case "freelance":  return const Color(0xFF81C784);
      case "investment": return const Color(0xFF00897B);
      case "bonus":      return const Color(0xFF66BB6A);
      case "transfer":   return const Color(0xFFBC9CC6);
      case "gift":       return const Color(0xFF26A69A);
      case "other":      return const Color(0xFFC8E6C9);
      default:           return const Color(0xFF388E3C);
    }
  }

  Stream<List<CategoryData>> streamChartData() async* {
    final uid = auth.currentUser!.uid;

    await for (final txSnap in datatransaksi()) {
      final docs = txSnap.docs;
      if (docs.isEmpty) { yield []; continue; }

      final Map<String, double> categoryTotals = {};
      final currentType = transactionType.value;

      for (final doc in docs) {
        final itemsSnap = await firestore
            .collection("users").doc(uid).collection("transactions")
            .doc(doc.id).collection("items")
            .where("type", isEqualTo: currentType).get();

        for (final item in itemsSnap.docs) {
          final category = item['category'] as String;
          final amount   = (item['amount'] as num).toDouble();
          categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
        }
      }

      if (categoryTotals.isEmpty) { yield []; continue; }

      final sorted = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      yield sorted.map((entry) {
        final color = currentType == "income"
            ? getIncomeCategoryColor(entry.key)
            : getExpenseCategoryColor(entry.key);
        return CategoryData(entry.key, entry.value, color);
      }).toList();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamExpenseItem(String docId) {
    final uid = auth.currentUser!.uid;
    return firestore
        .collection("users").doc(uid).collection("transactions")
        .doc(docId).collection("items")
        .where("type", isEqualTo: "expense")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamIncomeItem(String docId) {
    final uid = auth.currentUser!.uid;
    return firestore
        .collection("users").doc(uid).collection("transactions")
        .doc(docId).collection("items")
        .where("type", isEqualTo: transactionType.value)
        .orderBy("created_at", descending: true)
        .snapshots();
  }
}