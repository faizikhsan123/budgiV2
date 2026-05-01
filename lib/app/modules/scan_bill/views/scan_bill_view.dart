import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/scan_bill_controller.dart';

class ScanBillView extends GetView<ScanBillController> {
  const ScanBillView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 77, 54, 113),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.reset();
                      Get.offAllNamed(Routes.HOME);
                    },
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'Review Transaksi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // ── TOTAL DISPLAY ────────────────────────
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    IntrinsicWidth(
                      child: TextField(
                        // ✅ Pakai controller.totalCtrl langsung dari ScanBillController
                        controller: controller.totalCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (controller.namaToko.value.isNotEmpty)
                      Text(
                        controller.namaToko.value,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── BOTTOM CARD ──────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── SCAN ZONE ─────────────────
                      Obx(
                        () => controller.selectedImage.value == null
                            ? _buildTombolPilihFoto()
                            : _buildPreviewFoto(),
                      ),

                      const SizedBox(height: 16),

                      // ── STATUS SCAN ───────────────
                      Obx(() {
                        if (controller.isLoading.value) return _buildLoading();
                        if (controller.pesanError.value.isNotEmpty) return _buildError();
                        if (controller.scanBerhasil) return _buildHasilScan();
                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 20),

                      // ── TOMBOL AKSI ───────────────
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.reset();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Ulangi'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: controller.isLoading.value || !controller.scanBerhasil
                                    ? null
                                    : () {
                                      controller.simpan();
                               
                                      
                                    }, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1a56db),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── WIDGET HELPERS ──────────────────────────────────────

  Widget _buildTombolPilihFoto() {
    return Column(
      children: [
        GestureDetector(
          onTap: controller.ambilDariKamera,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1a56db)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_rounded, color: Color(0xFF1a56db), size: 32),
                SizedBox(height: 8),
                Text(
                  'Foto Struk',
                  style: TextStyle(
                    color: Color(0xFF1a56db),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: controller.ambilDariGaleri,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library_rounded, color: Colors.grey, size: 18),
                SizedBox(width: 8),
                Text('Pilih dari Galeri', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewFoto() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            controller.selectedImage.value!,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: controller.ambilDariKamera,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.refresh_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('Ganti', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Column(
      children: [
        SpinKitThreeBounce(color: Color(0xFF1a56db), size: 24),
        SizedBox(height: 8),
        Text('Membaca struk...', style: TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.red, size: 16),
              SizedBox(width: 6),
              Text(
                'Gagal membaca struk',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            controller.pesanError.value,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: controller.ambilDariKamera,
            child: const Text(
              'Foto ulang →',
              style: TextStyle(
                color: Color(0xFF1a56db),
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHasilScan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── GRID KATEGORI ──────────────────────────
        const Text(
          'Kategori',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            const crossCount = 4;
            const spacing = 12.0;
            final itemWidth =
                (constraints.maxWidth - spacing * (crossCount - 1)) / crossCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(controller.daftarKategori.length, (index) {
                return Obx(() {
                  final item = controller.daftarKategori[index];
                  final isSelected =
                      controller.selectedKategori.value == item['name'];
                  return GestureDetector(
                    onTap: () => controller.pilihKategori(item['name'] as String),
                    child: _CategoryBoxScan(
                      name: item['name'] as String,
                      iconUrl: item['icon'] as String,
                      isSelected: isSelected,
                      size: itemWidth,
                    ),
                  );
                });
              }),
            );
          },
        ),

        // ── CUSTOM KATEGORI (muncul kalau pilih Other) ──
        Obx(() {
          if (controller.selectedKategori.value != 'Other') {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1a56db)),
              ),
              child: Row(
                children: [
                  const Text('🏷️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => controller.customKategori.value = val,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                      decoration: const InputDecoration(
                        hintText: 'Nama kategori...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // ── NAMA TOKO ──────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            children: [
              const Text('🏢', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  // ✅ Pakai controller.namaTokoCtrl dari ScanBillController
                  controller: controller.namaTokoCtrl,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Nama toko...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Icon(Icons.edit, size: 14, color: Colors.grey),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── TANGGAL ────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            children: [
              const Text('📅', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  // ✅ Pakai controller.tanggalCtrl dari ScanBillController
                  controller: controller.tanggalCtrl,
                  keyboardType: TextInputType.datetime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'DD/MM/YYYY',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Icon(Icons.edit, size: 14, color: Colors.grey),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── NOTES ─────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text('📝', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  // ✅ Pakai controller.notesCtrl dari ScanBillController
                  controller: controller.notesCtrl,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                  decoration: const InputDecoration(
                    hintText: 'Nama barang yang dibeli...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── CATEGORY BOX ──────────────────────────────────────────────────────────────

class _CategoryBoxScan extends StatelessWidget {
  final String name;
  final String iconUrl;
  final bool isSelected;
  final double size;

  const _CategoryBoxScan({
    required this.name,
    required this.iconUrl,
    required this.isSelected,
    required this.size,
  });

  List<Color> _gradientColors() {
    switch (name.toLowerCase()) {
      case 'food':
        return [const Color.fromARGB(255, 131, 100, 89), const Color(0xFFFF8C42)];
      case 'transport':
        return [const Color(0xFF3D9BE9), const Color(0xFF2D7DD2)];
      case 'shopping':
        return [const Color(0xFFE91E8C), const Color(0xFFFF4081)];
      case 'health':
        return [const Color(0xFF4CAF50), const Color(0xFF66BB6A)];
      case 'entertain':
        return [const Color(0xFF9C27B0), const Color(0xFFBA68C8)];
      case 'transfer':
        return [const Color(0xFFFFB300), const Color(0xFFFFCA28)];
      case 'bill':
        return [const Color(0xFF00ACC1), const Color(0xFF26C6DA)];
      case 'other':
        return [const Color(0xFF607D8B), const Color(0xFF90A4AE)];
      default:
        return [const Color(0xFF8D8D8D), const Color(0xFFAAAAAA)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradientColors();

    return SizedBox(
      width: size,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                    ? colors
                    : [colors[0].withOpacity(0.85), colors[1].withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(isSelected ? 0.5 : 0.25),
                  blurRadius: isSelected ? 10 : 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.network(
                iconUrl,
                width: size * 0.44,
                height: size * 0.44,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1D2E),
            ),
          ),
        ],
      ),
    );
  }
}