import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

class HistoryController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> allTransactions() {
    String uid = auth.currentUser!.uid;
    return firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .orderBy("created_at", descending: true)
        .snapshots();
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
        .snapshots();
  }
}
