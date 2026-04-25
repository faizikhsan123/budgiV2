import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return firestore.collection('users').doc(uid).snapshots();
  }

  /// Stream dokumen tanggal (untuk list recent activity)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamTransaction() {
    final uid = auth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('filter_tanggal', descending: true)
        .limit(5)
        .snapshots();
  }

  /// Stream items berdasarkan docId tanggal
  Stream<QuerySnapshot<Map<String, dynamic>>> streamTransactionItem(
    String docId,
  ) {
    final uid = auth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(docId)
        .collection('items')
        .orderBy('filter_tanggal', descending: true)
        .snapshots();
  }

  /// Stream semua items dari all_transactions (flat) untuk kalkulasi
  /// summary expense/income. Ini FIX untuk error:
  /// "Bad state: field 'type' does not exist within the DocumentSnapshot"
  /// karena field 'type' ada di items, bukan di dokumen tanggal.
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllItems() {
    final uid = auth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('all_transactions')
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  @override
  void onInit() {
    pageC.pageIndex.value = 0;
    super.onInit();
  }

  void deleteData(String date, String id) async {
    if (id.isEmpty) {
      Get.snackbar("Error", "ID transaksi tidak ditemukan");
      return;
    }

    try {
      final uid = auth.currentUser!.uid;

      await firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(date)
          .collection("items")
          .doc(id)
          .delete();

      await firestore
          .collection("users")
          .doc(uid)
          .collection("all_transactions")
          .doc(id)
          .delete();

      Get.snackbar(
        "Sukses",
        "Transaksi berhasil dihapus",
        backgroundColor: const Color(0xFF2ECC71),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
