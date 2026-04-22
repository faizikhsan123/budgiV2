import 'package:budgi/app/modules/widgets/cancel_transaksi.dart';
import 'package:budgi/app/modules/widgets/content_before_transaksi.dart';
import 'package:budgi/app/modules/widgets/content_transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransaksiController extends GetxController {
  RxInt CurrentIndex = 0.obs;
  RxString transactionType = "expense".obs;
  RxInt selectedCategoryIndex = (-1).obs;
  RxString nilaiTanggal = "".obs;

  final otherC = TextEditingController();
  final amount1C = TextEditingController();
  final amount2C = TextEditingController();
  final notes1C = TextEditingController();
  final notes2C = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final categories = [
    {
      "name": "Food",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--fork-spoon-fill_k44lpk.svg",
    },
    {
      "name": "Transport",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--car-fill_oyvkvd.svg",
    },
    {
      "name": "Health",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1775021799/mingcute--shield-fill_1_hbbsu5.svg",
    },
    {
      "name": "Bill",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--bill-fill_f1txbv.svg",
    },
    {
      "name": "Shopping",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--shopping-cart-2-fill_dbgrgo.svg",
    },
    {
      "name": "Transfer",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--transfer-3-fill_vywadq.svg",
    },
    {
      "name": "Entertain",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--movie-fill_kps26w.svg",
    },
    {
      "name": "Other",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg",
    },
  ];

  void setExpense() {
    transactionType.value = "expense";
  }

  void setIncome() {
    transactionType.value = "income";
  }

  // FIX: Ambil tanggal hari ini dalam format yang konsisten
  String _getTodayFormatted() {
    return DateFormat('d-M-yyyy').format(DateTime.now());
  }

  /// RESET FORM
  void resetForm() {
    selectedCategoryIndex.value = -1;
    amount1C.clear();
    amount2C.clear();
    notes1C.clear();
    notes2C.clear();
    otherC.clear();

    nilaiTanggal.value = _getTodayFormatted();
  }

  @override
  void onInit() {
    super.onInit();
    // FIX: langsung set ke format tanggal yang valid, bukan "Today"
    nilaiTanggal.value = _getTodayFormatted();
  }

  // Helper: label yang ditampilkan di UI
  String get tanggalLabel {
    String today = _getTodayFormatted();
    if (nilaiTanggal.value == today) return "Today";
    return nilaiTanggal.value;
  }

  void tambahExpense(String noteText) async {
    try {
      String cleanText = amount1C.text
          .replaceAll("Rp", "")
          .replaceAll(".", "")
          .trim();

      int? number = int.tryParse(cleanText);

      if (number == null || number <= 0) {
        Get.snackbar("Failed", "Invalid amount");
        return;
      }

      if (selectedCategoryIndex.value == -1) {
        Get.snackbar("Failed", "Category is required");
        return;
      }

      if (auth.currentUser == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      String uid = auth.currentUser!.uid;

      var userDoc = await firestore.collection("users").doc(uid).get();
      int balance = userDoc.data()?['balance'] ?? 0;

      if (number > balance) {
        Get.snackbar("Failed", "Not enough balance");
        return;
      }

      Get.defaultDialog(
        title: "Confirm Transaction",
        content: contentBefore(
          rupiah: Rupiah(),
          number: number,
          text: "Expense",
        ),
        cancel: cancel_transaksi(),
        confirm: TextButton(
          onPressed: () async {
            try {
              String docId = nilaiTanggal.value;

              DateTime filterTanggal = DateFormat("d-M-yyyy").parse(docId);

              String itemId = DateTime.now().millisecondsSinceEpoch.toString();

              String createdAt = DateTime.now().toIso8601String();

              String formattedNote = noteText.isNotEmpty
                  ? noteText[0].toUpperCase() + noteText.substring(1)
                  : "";

              var categoryName =
                  categories[selectedCategoryIndex.value]['name'] == "Other"
                  ? (otherC.text.isNotEmpty
                        ? otherC.text[0].toUpperCase() +
                              otherC.text.substring(1)
                        : "")
                  : categories[selectedCategoryIndex.value]['name'];

              /// 🔹 ensure parent doc
              var parent = await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(docId)
                  .get();

              if (!parent.exists) {
                await firestore
                    .collection("users")
                    .doc(uid)
                    .collection("transactions")
                    .doc(docId)
                    .set({
                      "date": docId,
                      "filter_tanggal": filterTanggal.toIso8601String(),
                    });
              }

              Map<String, dynamic> data = {
                "type": "expense",
                "category": categoryName,
                "amount": number,
                "notes": formattedNote,
                "date": docId,
                "filter_tanggal": filterTanggal.toIso8601String(),
                "created_at": createdAt,
                "search_category": categoryName!.toLowerCase(),
                "search_notes": formattedNote.toLowerCase(),

                // ← TAMBAH INI
                "search_text":
                    "${categoryName!.toLowerCase()} ${formattedNote.toLowerCase()}",
                "icon": categories[selectedCategoryIndex.value]['icon'],
              };

              /// 🔹 1. SAVE KE ITEMS (STRUCTURE LAMA)
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(docId)
                  .collection("items")
                  .doc(itemId)
                  .set(data);

              /// 🔥 2. SAVE KE ALL_TRANSACTIONS (UNTUK SEARCH)
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("all_transactions")
                  .doc(itemId)
                  .set(data);

              /// 🔹 update balance
              await firestore.collection("users").doc(uid).update({
                "balance": balance - number,
              });

              resetForm();
              Get.back();

              Get.snackbar("Success", "Expense added");
            } catch (e) {
              print("ERROR ADD EXPENSE: $e");
              Get.snackbar("Error", e.toString());
            }
          },
          child: const Text("Add"),
        ),
      );
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void tambahTransaksiIncome(String noteText) async {
    try {
      String cleanText = amount2C.text
          .replaceAll("Rp", "")
          .replaceAll(".", "")
          .trim();

      int? number = int.tryParse(cleanText);

      if (number == null || number <= 0) {
        Get.snackbar("Failed", "Invalid amount");
        return;
      }

      if (auth.currentUser == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      String uid = auth.currentUser!.uid;

      Get.defaultDialog(
        title: "Confirm Transaction",
        content: contentBefore(
          rupiah: Rupiah(),
          number: number,
          text: "Income",
        ),
        cancel: cancel_transaksi(),
        confirm: TextButton(
          onPressed: () async {
            try {
              String docId = nilaiTanggal.value;

              DateTime filterTanggal = DateFormat("d-M-yyyy").parse(docId);

              String itemId = DateTime.now().millisecondsSinceEpoch.toString();

              String createdAt = DateTime.now().toIso8601String();

              String formattedNote = noteText.isNotEmpty
                  ? noteText[0].toUpperCase() + noteText.substring(1)
                  : "";

              var userDoc = await firestore.collection("users").doc(uid).get();

              int balance = userDoc.data()?['balance'] ?? 0;

              /// ensure parent
              var parent = await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(docId)
                  .get();

              if (!parent.exists) {
                await firestore
                    .collection("users")
                    .doc(uid)
                    .collection("transactions")
                    .doc(docId)
                    .set({
                      "date": docId,
                      "filter_tanggal": filterTanggal.toIso8601String(),
                    });
              }

              Map<String, dynamic> data = {
                "type": "income",
                "category": "Income",
                "amount": number,
                "notes": formattedNote,
                "date": docId,
                "filter_tanggal": filterTanggal.toIso8601String(),
                "created_at": createdAt,
                "search_category": "income",
                "search_notes": formattedNote.toLowerCase(),

                // ← TAMBAH INI
                "search_text": "income ${formattedNote.toLowerCase()}",
                "icon":
                    "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774979395/mingcute--cash-line_nsv7vc.svg",
              };

              /// items
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(docId)
                  .collection("items")
                  .doc(itemId)
                  .set(data);

              /// all_transactions
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("all_transactions")
                  .doc(itemId)
                  .set(data);

              /// update balance
              await firestore.collection("users").doc(uid).update({
                "balance": balance + number,
              });

              resetForm();
              Get.back();

              Get.snackbar("Success", "Income added");
            } catch (e) {
              print("ERROR ADD INCOME: $e");
              Get.snackbar("Error", e.toString());
            }
          },
          child: const Text("Add"),
        ),
      );
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
