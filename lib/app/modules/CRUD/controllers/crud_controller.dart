import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CrudController extends GetxController {
  final nameC = TextEditingController();
  final amountC = TextEditingController();
  final notesC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? itemData;

  @override
  void onInit() {
    super.onInit();
    // Ambil arguments yang dikirim dari HomeView
    itemData = Get.arguments as Map<String, dynamic>?;

    if (itemData != null) {
      nameC.text = itemData!['category'] ?? '';
      amountC.text = itemData!['amount'].toString();
      notesC.text = itemData!['notes'] ?? '';
    }
  }

  void updateData() async {
    if (itemData == null) return;

    String date = itemData!['date'];   // "22-4-2026"
    String id = itemData!['id'] ?? ''; // pastikan 'id' tersimpan di item

    if (id.isEmpty) {
      Get.snackbar("Error", "ID transaksi tidak ditemukan");
      return;
    }

    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("transactions")
          .doc(date)
          .collection("items")
          .doc(id)
          .update({
            "category": nameC.text,
            "amount": int.parse(amountC.text),
            "notes": notesC.text,
            // update juga search fields supaya konsisten
            "search_category": nameC.text.toLowerCase(),
            "search_notes": notesC.text.toLowerCase(),
            "search_text":
                "${nameC.text.toLowerCase()} ${notesC.text.toLowerCase()}",
          });

          await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("all_transactions")
          .doc(id)
          .update({
            "category": nameC.text,
            "amount": int.parse(amountC.text),
            "notes": notesC.text,
            // update juga search fields supaya konsisten
            "search_category": nameC.text.toLowerCase(),
            "search_notes": notesC.text.toLowerCase(),
            "search_text":
                "${nameC.text.toLowerCase()} ${notesC.text.toLowerCase()}",
          });

      Get.back();
      Get.snackbar("Sukses", "Transaksi berhasil diupdate");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void deleteData() async {
    if (itemData == null) return;

    String date = itemData!['date'];
    String id = itemData!['id'] ?? '';

    if (id.isEmpty) {
      Get.snackbar("Error", "ID transaksi tidak ditemukan");
      return;
    }

    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("transactions")
          .doc(date)
          .collection("items")
          .doc(id)
          .delete();
      Get.back();
      Get.snackbar("Sukses", "Transaksi berhasil dihapus");

      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("all_transactions")
          .doc(id)
          .delete();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    amountC.dispose();
    notesC.dispose();
    super.onClose();
  }
}