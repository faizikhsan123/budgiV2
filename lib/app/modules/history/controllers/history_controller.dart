import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

class HistoryController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime? start;
  DateTime? end = DateTime.now();
  // late TextEditingController searchC;
  // var tempSearch = [].obs;
  // var queryResult = [].obs;


  // void search(String value)async{
  //   if (value.length == 0) {
  //     queryResult.value = [];
  //     tempSearch.value = [];
  //   }else {
  //     if (value.length !=0) {
  //       var hurufkecil = value.toLowerCase();
  //       print(hurufkecil);
        
  //     }

  //   }

  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> allTransactions() {
    String uid = auth.currentUser!.uid;

    if (start == null) {
      return firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .where(
            'filter_tanggal',
            isLessThan:
                end!.add(const Duration(days: 1)).toIso8601String(),
          )
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
            isLessThan:
                end!.add(const Duration(days: 1)).toIso8601String(),
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