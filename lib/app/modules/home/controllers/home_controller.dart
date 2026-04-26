import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final pageC = Get.put(PageIndexController());
  final box = GetStorage();

  final RxBool balance = false.obs;

  void hidebalance() {
    balance.value = !balance.value;
    box.write('balance', balance.value);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamProfile() {
    final uid = auth.currentUser!.uid;
    return firestore.collection('users').doc(uid).snapshots();
  }

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

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllItems() {
    final uid = auth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('all_transactions')
        .orderBy('filter_tanggal', descending: true)
        .snapshots();
  }

  @override
  void onInit() {
    pageC.pageIndex.value = 0;
    balance.value = box.read<bool>('balance') ?? false;
    super.onInit();
  }

  Future<void> deleteData(String date, String id) async {
    if (id.isEmpty) {
      Get.snackbar('error'.tr, 'delete_error'.tr);
      return;
    }

    try {
      final uid = auth.currentUser!.uid;

      await Future.wait([
        firestore
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .doc(date)
            .collection('items')
            .doc(id)
            .delete(),
        firestore
            .collection('users')
            .doc(uid)
            .collection('all_transactions')
            .doc(id)
            .delete(),
      ]);

      Get.snackbar(
        'done'.tr,
        'delete_success'.tr,
        backgroundColor: const Color(0xFF2ECC71),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('error'.tr, e.toString());
    }
  }
}