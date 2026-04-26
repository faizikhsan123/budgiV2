import 'package:budgi/app/modules/analytics/views/analytics_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  final RxString transactionType = "expense".obs;
  final RxString nilaiTanggal = "".obs;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime? start;
  DateTime? end;

  @override
  void onInit() {
    super.onInit();
    nilaiTanggal.value = 'all_time'.tr;
  }

  Future<void> resetForm() async {
    start = null;
    end = null;
    nilaiTanggal.value = 'all_time'.tr;
    update();
  }

  void liatExpense() => transactionType.value = "expense";
  void liatIncome() => transactionType.value = "income";

  void pickDateRange(DateTime startDate, DateTime endDate) {
    start = DateTime(startDate.year, startDate.month, startDate.day);
    end = DateTime(endDate.year, endDate.month, endDate.day);
    update();
    Get.back();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllTransactions() {
    final uid = auth.currentUser!.uid;
    Query<Map<String, dynamic>> query = firestore
        .collection("users")
        .doc(uid)
        .collection("all_transactions");

    if (start != null && end != null) {
      final effectiveEnd = end!.add(const Duration(days: 1));
      query = query
          .where("filter_tanggal",
              isGreaterThanOrEqualTo: start!.toIso8601String())
          .where("filter_tanggal",
              isLessThan: effectiveEnd.toIso8601String())
          .orderBy("filter_tanggal", descending: true);
    } else {
      query = query.orderBy("created_at", descending: false);
    }

    return query.snapshots();
  }

  List<Map<String, dynamic>> filterByType(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String type,
  ) {
    return docs
        .where((d) => d.data()['type'] == type)
        .map((d) => d.data())
        .toList();
  }

  Map<String, double> computeMetrics(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    double totalIncome = 0;
    double totalExpense = 0;
    for (final doc in docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      if (data['type'] == 'income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    }
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'balance': totalIncome - totalExpense,
    };
  }

  Map<String, double> computeCategoryPercentages(
    List<Map<String, dynamic>> items,
  ) {
    final Map<String, double> totals = {};
    double grand = 0;
    for (final item in items) {
      final cat = item['category'] as String;
      final amt = (item['amount'] as num).toDouble();
      totals[cat] = (totals[cat] ?? 0) + amt;
      grand += amt;
    }
    if (grand == 0) return {};
    return totals.map((k, v) => MapEntry(k, (v / grand) * 100));
  }

  List<CategoryData> buildChartData(
    List<Map<String, dynamic>> items,
    String type,
  ) {
    final Map<String, double> totals = {};
    for (final item in items) {
      final cat = item['category'] as String;
      final amt = (item['amount'] as num).toDouble();
      totals[cat] = (totals[cat] ?? 0) + amt;
    }
    if (totals.isEmpty) return [];

    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((entry) {
      final color = type == "income"
          ? getIncomeCategoryColor(entry.key)
          : getExpenseCategoryColor(entry.key);
      return CategoryData(entry.key, entry.value, color);
    }).toList();
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
      case "income":     return const Color(0xFF388E3C);
      case "other":      return const Color(0xFFC8E6C9);
      default:           return const Color(0xFF388E3C);
    }
  }
}