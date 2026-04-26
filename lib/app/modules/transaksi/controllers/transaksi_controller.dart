import 'package:budgi/app/modules/widgets/cancel_transaksi.dart';
import 'package:budgi/app/modules/widgets/content_before_transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiController extends GetxController {
  RxString transactionType = "expense".obs;
  RxInt selectedCategoryIndex = (-1).obs;
  RxString nilaiTanggal = "".obs;

  final otherC = TextEditingController();
  final amount1C = TextEditingController();
  final amount2C = TextEditingController();
  final notes1C = TextEditingController();
  final notes2C = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Shorthand getter agar tidak perlu ulang tiap kali
  String get _uid => _auth.currentUser!.uid;

  final categories = [
    {
      "name": "Food",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--fork-spoon-fill_k44lpk.svg",
    },
    {
      "name": "Transport",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--car-fill_oyvkvd.svg",
    },
    {
      "name": "Health",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1775021799/mingcute--shield-fill_1_hbbsu5.svg",
    },
    {
      "name": "Bill",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--bill-fill_f1txbv.svg",
    },
    {
      "name": "Shopping",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--shopping-cart-2-fill_dbgrgo.svg",
    },
    {
      "name": "Transfer",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--transfer-3-fill_vywadq.svg",
    },
    {
      "name": "Entertain",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--movie-fill_kps26w.svg",
    },
    {
      "name": "Other",
      "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg",
    },
  ];

  void setExpense() => transactionType.value = "expense";
  void setIncome() => transactionType.value = "income";

  String _getTodayFormatted() => DateFormat('d-M-yyyy').format(DateTime.now());

  String get tanggalLabel {
    return nilaiTanggal.value == _getTodayFormatted() ? 'today'.tr : nilaiTanggal.value;
  }

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
    nilaiTanggal.value = _getTodayFormatted();
  }

  // ── Helper: snackbar error ────────────────────────────────────────────────
  void _snackError(String messageKey) {
    Get.snackbar(
      'failed'.tr,
      messageKey.tr,
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
    );
  }

  void _snackSuccess(String messageKey) {
    Get.snackbar(
      'success'.tr,
      messageKey.tr,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
    );
  }

  // ── Helper: parse amount dari TextEditingController ───────────────────────
  int? _parseAmount(TextEditingController c) {
    final clean = c.text
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .replaceAll(",", "")
        .trim();
    return int.tryParse(clean);
  }

  // ── Helper: capitalize string ─────────────────────────────────────────────
  String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  // ── Helper: ensure parent transaction doc exists ──────────────────────────
  Future<void> _ensureParentDoc(
    String uid,
    String docId,
    DateTime filterTanggal,
  ) async {
    final parent = await _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(docId)
        .get();

    if (!parent.exists) {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(docId)
          .set({
        "date": docId,
        "filter_tanggal": filterTanggal.toIso8601String(),
      });
    }
  }

  // ── Helper: simpan ke items + all_transactions ────────────────────────────
  Future<void> _saveTransaction(
    String uid,
    String docId,
    String itemId,
    Map<String, dynamic> data,
  ) async {
    final batch = _firestore.batch();

    batch.set(
      _firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(docId)
          .collection("items")
          .doc(itemId),
      data,
    );

    batch.set(
      _firestore
          .collection("users")
          .doc(uid)
          .collection("all_transactions")
          .doc(itemId),
      data,
    );

    await batch.commit();
  }

  // ── Tambah Expense ────────────────────────────────────────────────────────
  void tambahExpense(String noteText) async {
    final number = _parseAmount(amount1C);

    if (number == null || number <= 0) {
      _snackError('invalid_amount');
      return;
    }

    if (selectedCategoryIndex.value == -1) {
      _snackError('category_required');
      return;
    }

    if (_auth.currentUser == null) {
      _snackError('user_not_logged_in');
      return;
    }

    final uid = _uid;
    final userDoc = await _firestore.collection("users").doc(uid).get();
    final balance = userDoc.data()?['balance'] ?? 0;

    if (number > balance) {
      _snackError('insufficient_balance');
      return;
    }

    Get.defaultDialog(
      title: 'confirm_transaction'.tr,
      content: contentBefore(
        rupiah: Rupiah(),
        number: number,
        text: 'expense'.tr,
      ),
      cancel: cancel_transaksi(),
      confirm: TextButton(
        onPressed: () async {
          try {
            final docId = nilaiTanggal.value;
            final filterTanggal = DateFormat("d-M-yyyy").parse(docId);
            final itemId = DateTime.now().millisecondsSinceEpoch.toString();

            final categoryName =
                categories[selectedCategoryIndex.value]['name'] == "Other"
                    ? _capitalize(otherC.text)
                    : categories[selectedCategoryIndex.value]['name'] as String;

            final formattedNote = _capitalize(noteText);

            final data = {
              "type": "expense",
              "category": categoryName,
              "amount": number,
              "notes": formattedNote,
              "date": docId,
              "filter_tanggal": filterTanggal.toIso8601String(),
              "created_at": DateTime.now().toIso8601String(),
              "search_category": categoryName.toLowerCase(),
              "search_notes": formattedNote.toLowerCase(),
              "search_text":
                  "${categoryName.toLowerCase()} ${formattedNote.toLowerCase()}",
              "icon": categories[selectedCategoryIndex.value]['icon'],
            };

            await _ensureParentDoc(uid, docId, filterTanggal);
            await _saveTransaction(uid, docId, itemId, data);

            await _firestore.collection("users").doc(uid).update({
              "balance": balance - number,
            });

            resetForm();
            Get.back();
            _snackSuccess('expense_added');
          } catch (e) {
            debugPrint("ERROR ADD EXPENSE: $e");
            _snackError('transaction_failed');
          }
        },
        child: Text('add'.tr),
      ),
    );
  }

  // ── Tambah Income ─────────────────────────────────────────────────────────
  void tambahTransaksiIncome(String noteText) async {
    final number = _parseAmount(amount2C);

    if (number == null || number <= 0) {
      _snackError('invalid_amount');
      return;
    }

    if (_auth.currentUser == null) {
      _snackError('user_not_logged_in');
      return;
    }

    final uid = _uid;

    Get.defaultDialog(
      title: 'confirm_transaction'.tr,
      content: contentBefore(
        rupiah: Rupiah(),
        number: number,
        text: 'income'.tr,
      ),
      cancel: cancel_transaksi(),
      confirm: TextButton(
        onPressed: () async {
          try {
            final docId = nilaiTanggal.value;
            final filterTanggal = DateFormat("d-M-yyyy").parse(docId);
            final itemId = DateTime.now().millisecondsSinceEpoch.toString();
            final formattedNote = _capitalize(noteText);

            final userDoc =
                await _firestore.collection("users").doc(uid).get();
            final balance = userDoc.data()?['balance'] ?? 0;

            final data = {
              "type": "income",
              "category": "Income",
              "amount": number,
              "notes": formattedNote,
              "date": docId,
              "filter_tanggal": filterTanggal.toIso8601String(),
              "created_at": DateTime.now().toIso8601String(),
              "search_category": "income",
              "search_notes": formattedNote.toLowerCase(),
              "search_text": "income ${formattedNote.toLowerCase()}",
              "icon":
                  "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774979395/mingcute--cash-line_nsv7vc.svg",
            };

            await _ensureParentDoc(uid, docId, filterTanggal);
            await _saveTransaction(uid, docId, itemId, data);

            await _firestore.collection("users").doc(uid).update({
              "balance": balance + number,
            });

            resetForm();
            Get.back();
            _snackSuccess('income_added');
          } catch (e) {
            debugPrint("ERROR ADD INCOME: $e");
            _snackError('transaction_failed');
          }
        },
        child: Text('add'.tr),
      ),
    );
  }
}