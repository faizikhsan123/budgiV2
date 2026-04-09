import 'package:budgi/app/modules/widgets/cancel_transaksi.dart';
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
    String cleanText = amount1C.text
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .trim();

    int? number = int.tryParse(cleanText);

    /// VALIDASI NOMINAL
    if (number == null) {
      Get.snackbar(
        'Failed',
        'Amount is required',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (number <= 0) {
      Get.snackbar(
        'Failed',
        'Amount must be greater than 0',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    /// VALIDASI KATEGORI
    if (selectedCategoryIndex.value == -1) {
      Get.snackbar(
        'Failed',
        'Category is required',
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade900,
      );
      return;
    }

    String uid = auth.currentUser!.uid;

    /// AMBIL DATA USER
    var snapshot = await firestore.collection("users").doc(uid).get();
    int balance = snapshot.data()?['balance'] ?? 0;

    /// CEK SALDO
    if (number > balance) {
      Get.snackbar(
        'Failed',
        'Not enough balance',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    var rupiah = Rupiah();

    Get.defaultDialog(
      title: "Add ${rupiah.convertToRupiah(number)} to expense?",
      titlePadding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      middleText: "",
      radius: 12,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      titleStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      cancel: cancel_transaksi(),
      confirm: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFBC9CC6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () async {
            // FIX: pastikan nilaiTanggal sudah format d-M-yyyy yang valid
            String docId = nilaiTanggal.value;

            var docTransaction = await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(docId)
                .get();

            var data = docTransaction.data();

            String waktu = DateFormat.jms().format(DateTime.now());

            // FIX: parse dengan format yang sama persis saat set
            DateTime filterTanggal = DateFormat("d-M-yyyy").parse(docId);

            if (data == null) {
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(docId)
                  .set({
                    'date': docId,
                    'created_at': waktu,
                    'filter_tanggal': filterTanggal.toIso8601String(),
                  });
            }

            await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(docId)
                .collection("items")
                .doc(waktu)
                .set({
                  'type': "expense",
                  "icon": categories[selectedCategoryIndex.value]['icon'],
                  "category": categories[selectedCategoryIndex.value]['name'],
                  "date": docId,
                  'amount': number,
                  'notes': noteText,
                  'created_at': waktu,
                });

            await firestore.collection("users").doc(uid).update({
              'balance': balance - number,
            });

            amount1C.clear();
            selectedCategoryIndex.value = -1;
            notes1C.clear();

            Get.back();

            Get.defaultDialog(
              title: "Expense Added!",
              radius: 12,
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              titleStyle: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              content: content(
                rupiah: rupiah,
                number: number,
                text: "balance has been deducted",
              ),
            );
          },
          child: Text(
            "Add",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void tambahTransaksiIncome(String noteText) async {
    String cleanText = amount2C.text
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .trim();

    int? number = int.tryParse(cleanText);

    if (number == null) {
      Get.snackbar(
        'Failed',
        'Amount is required',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (number <= 0) {
      Get.snackbar(
        'Failed',
        'Amount must be greater than 0',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    var rupiah = Rupiah();

    Get.defaultDialog(
      title: "Add ${rupiah.convertToRupiah(number)} to income?",
      titlePadding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      middleText: "",
      radius: 12,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      titleStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      cancel: cancel_transaksi(),
      confirm: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFBC9CC6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () async {
            String uid = auth.currentUser!.uid;

            // FIX: pastikan nilaiTanggal sudah format d-M-yyyy yang valid
            String docId = nilaiTanggal.value;

            var docTransaction = await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(docId)
                .get();

            var data = docTransaction.data();

            String waktu = DateFormat.jms().format(DateTime.now());

            // FIX: parse dengan format yang sama persis saat set
            DateTime filterTanggal = DateFormat("d-M-yyyy").parse(docId);

            if (data == null) {
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(docId)
                  .set({
                    'date': docId,
                    'created_at': waktu,
                    'filter_tanggal': filterTanggal.toIso8601String(),
                  });
            }

            var snapshot = await firestore.collection("users").doc(uid).get();
            int balance = snapshot.data()?['balance'] ?? 0;

            await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(docId)
                .collection("items")
                .doc(waktu)
                .set({
                  'type': "income",
                  "icon":
                      "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774979395/mingcute--cash-line_nsv7vc.svg",
                  "category": "income",
                  "date": docId,
                  'amount': number,
                  'notes': noteText,
                  'created_at': waktu,
                });

            await firestore.collection("users").doc(uid).update({
              'balance': balance + number,
            });

            amount2C.clear();
            notes2C.clear();

            Get.back();

            Get.defaultDialog(
              title: "Income Added!",
              radius: 12,
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              titleStyle: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              content: content(
                rupiah: rupiah,
                number: number,
                text: "balance has been added",
              ),
            );
          },
          child: Text(
            "Add",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


}