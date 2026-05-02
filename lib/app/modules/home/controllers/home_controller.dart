import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

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
        .limit(3)
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

      Get.defaultDialog(
        title: 'delete_transaction'.tr,
        titlePadding: const EdgeInsets.only(top: 24, left: 20, right: 20),
        middleText: 'delete_transaction_msg'.tr,
        radius: 12,
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        titleStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        cancel: Container(
          width: 120,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromARGB(255, 149, 170, 235)),
          ),
          child: TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
        confirm: Container(
          width: 120,
          height: 45,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 78, 94, 175),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () async {
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

              Get.back();

              Get.snackbar(
                'success'.tr,
                'delete_success'.tr,
                backgroundColor: Colors.green.shade50,
                colorText: Colors.green.shade900,
              );
            },
            child: Text(
              'yes'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      Get.snackbar('error'.tr, e.toString());
    }
  }
}
