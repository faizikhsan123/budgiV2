import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTransaksiController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final amountC = TextEditingController();
  final notesC = TextEditingController();

  RxString selectedCategory = ''.obs;
  RxString selectedDate = ''.obs;
  RxBool isLoading = false.obs;

  late String docId;
  late Map<String, dynamic> originalData;

  final List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Health',
    'Entertaint',
    'Transfer',
    'Bill',
    'Other',
  ];

  final List<String> incomeCategories = [
    'Income',
    'Salary',
    'Bonus',
    'Transfer',
    'Other',
  ];

  List<String> get categories {
    final type = (originalData['type'] ?? '').toString().toLowerCase();
    return type == 'income' ? incomeCategories : expenseCategories;
  }

  final categoryNameC = TextEditingController();

  String _getIconUrl(String category) {
    const icons = {
      'Food': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--fork-spoon-fill_k44lpk.svg',
      'Transport': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--car-fill_oyvkvd.svg',
      'Shopping': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--shopping-cart-2-fill_dbgrgo.svg',
      'Health': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1775021799/mingcute--shield-fill_1_hbbsu5.svg',
      'Entertaint': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--movie-fill_kps26w.svg',
      'Transfer': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--transfer-3-fill_vywadq.svg',
      'Bill': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--bill-fill_f1txbv.svg',
      'Other': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg',
      // income categories - pakai other icon sebagai fallback
      'Income': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg',
      'Salary': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg',
      'Bonus': 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg',
    };
    return icons[category] ??
        'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg';
  }

  @override
  void onClose() {
    amountC.dispose();
    notesC.dispose();
    categoryNameC.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    docId = args['id'] ?? '';
    originalData = args;

    amountC.text = '${args['amount'] ?? ''}';
    notesC.text = args['notes'] ?? '';
    selectedDate.value = args['date'] ?? '';

    final cat = args['category'] ?? '';
    final isInList = categories.contains(cat);
    selectedCategory.value = isInList ? cat : 'Other';

    if (!isInList && cat.isNotEmpty) {
      categoryNameC.text = cat;
    }
  }

  Future<void> save() async {
    if (amountC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Amount tidak boleh kosong',
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final uid = auth.currentUser!.uid;

      final isOther = selectedCategory.value.toLowerCase() == 'other';

      final finalCategory = isOther ? categoryNameC.text : selectedCategory.value;

      final iconUrl = isOther
          ? 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg'
          : _getIconUrl(selectedCategory.value);

      final updateData = {
        'category': finalCategory,
        'amount': int.tryParse(amountC.text) ?? 0,
        'notes': notesC.text,
        'date': selectedDate.value,
        'icon': iconUrl,
        'search_category': finalCategory.toLowerCase(),
        'search_notes': notesC.text.toLowerCase(),
        'search_text': '${finalCategory.toLowerCase()} ${notesC.text.toLowerCase()}'.trim(),
      };

      final transSnap = await firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .get();

      String? parentId;
      for (final doc in transSnap.docs) {
        final itemSnap = await firestore
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .doc(doc.id)
            .collection('items')
            .doc(docId)
            .get();

        if (itemSnap.exists) {
          parentId = doc.id;
          break;
        }
      }

      if (parentId == null) {
        Get.snackbar('Error', 'Transaksi tidak ditemukan');
        isLoading.value = false;
        return;
      }

      await firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(parentId)
          .collection('items')
          .doc(docId)
          .update(updateData);

      await firestore
          .collection('users')
          .doc(uid)
          .collection('all_transactions')
          .doc(docId)
          .update(updateData);

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Transaksi berhasil diperbarui',
        backgroundColor: const Color(0xFF2ECC71),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}