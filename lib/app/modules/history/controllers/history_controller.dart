import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString nilaiTanggal = "".obs;
  final searchC = TextEditingController();
  var queryResult = [].obs;
  var tempSearchResult = [].obs;

  DateTime? start;
  DateTime? end = DateTime.now();

  void search(String value) async {
    if (value == 0) {
      queryResult.value = [];
      tempSearchResult.value = [];
    } else {
      if (value.length != 0) {
        var kapital = value.substring(0, 1).toUpperCase() + value.substring(1);
        print("${kapital}");

        if (queryResult.length == 0 && value.length == 1) {
          //krtikan satu huruf
          QuerySnapshot<Map<String, dynamic>> dataTransaksi = await firestore
              .collection("users")
              .doc(auth.currentUser!.uid)
              .collection("transactions")
              .get();
          print("data ${dataTransaksi.docs.length}");
        }
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allTransactions() {
    String uid = auth.currentUser!.uid;

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

  Stream<QuerySnapshot<Map<String, dynamic>>> DetailAllTransactions(
    String docId,
  ) {
    String uid = auth.currentUser!.uid;

    return firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(docId)
        .collection("items")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  void pickDateRange(DateTime startDate, DateTime endDate) {
    start = startDate;
    end = endDate;
    update(); // biar GetBuilder rebuild
    Get.back();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    // searchC = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // searchC.dispose();
    super.dispose();
  }
}
