import 'dart:io';
import 'package:budgi/app/modules/transaksi/controllers/transaksi_controller.dart';

import 'package:budgi/core/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ScanBillController extends GetxController {
  final GeminiService _geminiService = GeminiService();
  final ImagePicker _picker = ImagePicker();

  // ── OBSERVABLE VARIABLES ──────────────────────────
  final isLoading = false.obs;
  final totalAmount = 0.0.obs;
  final namaToko = ''.obs;
  final tanggal = ''.obs;
  final pesanError = ''.obs;
  final selectedImage = Rx<File?>(null);
  final customKategori = ''.obs;
  final selectedKategori = ''.obs;
  final notes = ''.obs;
  final tipe = 'expense'.obs;

  // ── TEXT CONTROLLERS ──────────────────────────────
  // ✅ Semua TextEditingController ada di sini (bukan di View)
  final totalCtrl = TextEditingController();
  final namaTokoCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final notesCtrl =
      TextEditingController(); // ✅ Ditambahkan (sebelumnya hilang)

  // ── KATEGORI ──────────────────────────────────────
  final daftarKategori = [
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

  // ── GETTER ────────────────────────────────────────
  final rupiah = Rupiah();

  String get formattedTotal => rupiah.convertToRupiah(totalAmount.value);

  bool get scanBerhasil => totalAmount.value > 0;

  // ── METHODS ───────────────────────────────────────

  void pilihKategori(String nama) {
    selectedKategori.value = nama;
  }

  Future<void> ambilDariKamera() async {
    await _pilihGambar(ImageSource.camera);
  }

  Future<void> ambilDariGaleri() async {
    await _pilihGambar(ImageSource.gallery);
  }

  void setupRupiahListener() {
    totalCtrl.addListener(() {
      final String raw = totalCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');

      if (raw.isEmpty) {
        totalAmount.value = 0;
        return;
      }

      final int value = int.parse(raw);
      totalAmount.value = value.toDouble();

      final String formatted =
          "Rp ${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}";

      if (totalCtrl.text != formatted) {
        totalCtrl.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  Future<void> _pilihGambar(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (picked == null) return;

      selectedImage.value = File(picked.path);
      await _scanStruk();
    } catch (e) {
      pesanError.value = 'Gagal membuka kamera: $e';
    }
  }

  Future<void> _scanStruk() async {
    if (selectedImage.value == null) return;

    isLoading.value = true;
    pesanError.value = '';
    totalAmount.value = 0;

    totalCtrl.text =
        "Rp ${totalAmount.value.toInt().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}";

    try {
      final hasil = await _geminiService.scanStruk(selectedImage.value!);

      totalAmount.value = (hasil['total'] as num?)?.toDouble() ?? 0.0;
      namaToko.value = hasil['toko'] as String? ?? '';
      tanggal.value = hasil['tanggal'] as String? ?? '';
      selectedKategori.value = hasil['kategori'] as String? ?? 'Other';
      notes.value = hasil['notes'] as String? ?? '';

      // ✅ Sync hasil scan ke semua TextEditingController
      totalCtrl.text = totalAmount.value > 0
          ? "Rp ${totalAmount.value.toInt().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}"
          : '';
      namaTokoCtrl.text = namaToko.value;
      tanggalCtrl.text = tanggal.value;
      notesCtrl.text = notes.value;

      if (totalAmount.value <= 0) {
        pesanError.value = 'Total tidak terdeteksi. Coba foto lebih jelas.';
      }
    } catch (e) {
      print('=== ERROR CONTROLLER ===');
      print(e.toString());
      pesanError.value = 'Gagal scan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    isLoading.value = false;
    totalAmount.value = 0.0;
    namaToko.value = '';
    tanggal.value = '';
    pesanError.value = '';
    selectedImage.value = null;
    selectedKategori.value = '';
    notes.value = '';
    tipe.value = 'expense';
    customKategori.value = '';

    // ✅ Clear semua TextEditingController sekaligus
    totalCtrl.clear();
    namaTokoCtrl.clear();
    tanggalCtrl.clear();
    notesCtrl.clear();
  }

  @override
  void onInit() {
    setupRupiahListener();
    reset();
    super.onInit();
  }

  // ✅ Dispose semua controller agar tidak memory leak
  @override
  void onClose() {
    totalCtrl.dispose();
    namaTokoCtrl.dispose();
    tanggalCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
    reset();
  }

  Future<void> simpan() async {
    if (!scanBerhasil) {
      Get.snackbar(
        'Perhatian',
        'Scan struk dulu sebelum menyimpan!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final transaksiC = Get.find<TransaksiController>();

    final kategoriAkhir =
        selectedKategori.value == 'Other' && customKategori.value.isNotEmpty
        ? customKategori.value
        : selectedKategori.value;

    if (tanggal.value.isNotEmpty) {
      try {
        final parsed = DateFormat('dd/MM/yyyy').parse(tanggal.value);
        transaksiC.nilaiTanggal.value = DateFormat('d-M-yyyy').format(parsed);
      } catch (_) {
        transaksiC.nilaiTanggal.value = DateFormat(
          'd-M-yyyy',
        ).format(DateTime.now());
      }
    }

    // ✅ Baca dari namaTokoCtrl & notesCtrl (user mungkin sudah edit manual)
    final int amount =
        int.tryParse(totalCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    if (amount == 0) {
      Get.snackbar(
        'Error',
        'Nominal tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    transaksiC.amount1C.text = amount.toString();
    transaksiC.amount2C.text = amount.toString();

    final int idx = transaksiC.categories.indexWhere(
      (cat) => cat['name'] == kategoriAkhir,
    );

    if (idx != -1) {
      transaksiC.selectedCategoryIndex.value = idx;
    } else {
      final int otherIdx = transaksiC.categories.indexWhere(
        (cat) => cat['name'] == 'Other',
      );
      transaksiC.selectedCategoryIndex.value = otherIdx;
      transaksiC.otherC.text = kategoriAkhir;
    }

    // ✅ SESUDAH
    if (tipe.value == 'expense') {
      transaksiC.tambahExpense(notesCtrl.text);
    } else {
      // handle income nanti
    }
  }
}
