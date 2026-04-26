import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTransaksiController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final amountC = TextEditingController();
  final notesC = TextEditingController();
  final categoryNameC = TextEditingController();

  RxString selectedCategory = ''.obs;
  RxString selectedType = ''.obs;
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
    final type = selectedType.value.toLowerCase(); // ✅
    return type == 'income' ? incomeCategories : expenseCategories;
  }

  // ── Helper snackbar ───────────────────────────────────────────────────────
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

  String _getIconUrl(String category) {
    const icons = {
      'Food':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--fork-spoon-fill_k44lpk.svg',
      'Transport':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--car-fill_oyvkvd.svg',
      'Shopping':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--shopping-cart-2-fill_dbgrgo.svg',
      'Health':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1775021799/mingcute--shield-fill_1_hbbsu5.svg',
      'Entertaint':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--movie-fill_kps26w.svg',
      'Transfer':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--transfer-3-fill_vywadq.svg',
      'Bill':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--bill-fill_f1txbv.svg',
      'Other':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg',
      'Income':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774979395/mingcute--cash-line_nsv7vc.svg',
      'Salary':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774979395/mingcute--cash-line_nsv7vc.svg',
      'Bonus':
          'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774979395/mingcute--cash-line_nsv7vc.svg',
    };
    return icons[category] ??
        'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg';
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

    // ✅ TAMBAH INI
    selectedType.value = (args['type'] ?? '').toString().toLowerCase();

    final cat = args['category'] ?? '';
    final isInList = categories.contains(cat);
    selectedCategory.value = isInList ? cat : 'Other';

    if (!isInList && cat.isNotEmpty) {
      categoryNameC.text = cat;
    }
  }

  @override
  void onClose() {
    amountC.dispose();
    notesC.dispose();
    categoryNameC.dispose();
    super.onClose();
  }

  Future<void> save() async {
    if (amountC.text.trim().isEmpty) {
      _snackError('invalid_amount');
      return;
    }

    // ✅ TAMBAH VALIDASI INI
    final isOther = selectedCategory.value.toLowerCase() == 'other';
    if (isOther && categoryNameC.text.trim().isEmpty) {
      _snackError('category_name_required'); // key bebas
      return;
    }

    isLoading.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final isOther = selectedCategory.value.toLowerCase() == 'other';
      final finalCategory = isOther
          ? categoryNameC.text.trim()
          : selectedCategory.value;
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
        'search_text':
            '${finalCategory.toLowerCase()} ${notesC.text.toLowerCase()}'
                .trim(),
      };

      // Cari parent doc
      final transSnap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .get();

      String? parentId;
      for (final doc in transSnap.docs) {
        final itemSnap = await _firestore
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
        _snackError('transaction_not_found');
        isLoading.value = false;
        return;
      }

      // Update keduanya sekaligus
      await Future.wait([
        _firestore
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .doc(parentId)
            .collection('items')
            .doc(docId)
            .update(updateData),
        _firestore
            .collection('users')
            .doc(uid)
            .collection('all_transactions')
            .doc(docId)
            .update(updateData),
      ]);

      Get.back();
      _snackSuccess('transaction_updated');
    } catch (e) {
      debugPrint('ERROR EDIT TRANSAKSI: $e');
      _snackError('transaction_failed');
    } finally {
      isLoading.value = false;
    }
  }
}
