import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/transaksi_controller.dart';

class TransaksiView extends GetView<TransaksiController> {
  final pageC = Get.find<PageIndexController>();

  TransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpense = controller.transactionType.value == 'expense';

      return Scaffold(
        backgroundColor: const Color(0xFFF0EBF8),
        bottomNavigationBar: bottom_navbar(pageC: pageC),
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        isExpense ? 'Add Expense' : 'Add Income',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1D2E),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1A1D2E),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Amount input ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Input your expense',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 1,
                      width: 140,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Scrollable content ────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Date picker row ─────────────────────────
                      GestureDetector(
                        onTap: () => _showDatePicker(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Color(0xFF3D5AF1),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Date',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1A1D2E),
                                ),
                              ),
                              const Spacer(),
                              Obx(
                                () => Text(
                                  controller.nilaiTanggal.value.isEmpty
                                      ? 'Today'
                                      : controller.nilaiTanggal.value,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: Color(0xFF1A1D2E),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Select Category (Expense only) ───────────
                      if (isExpense) ...[
                        Text(
                          'Select Category',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1D2E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const crossCount = 4;
                            const spacing = 12.0;
                            final itemWidth =
                                (constraints.maxWidth -
                                    spacing * (crossCount - 1)) /
                                crossCount;

                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: List.generate(
                                controller.categories.length,
                                (index) => Obx(
                                  () {
                                    final isSelected =
                                        controller
                                            .selectedCategoryIndex
                                            .value ==
                                        index;
                                    return GestureDetector(
                                      onTap: () => controller
                                          .selectedCategoryIndex
                                          .value = index,
                                      child: _CategoryBox(
                                        name:
                                            '${controller.categories[index]['name']}',
                                        iconUrl:
                                            '${controller.categories[index]['icon']}',
                                        isSelected: isSelected,
                                        size: itemWidth,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Other category text field
                        Obx(() {
                          if (controller.selectedCategoryIndex.value == -1)
                            return const SizedBox.shrink();
                          final isOther =
                              controller
                                      .categories[controller
                                          .selectedCategoryIndex
                                          .value]['name'] ==
                                  'Other';
                          if (!isOther) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildTextField(
                              controller: controller.otherC,
                              hint: 'Category Name',
                            ),
                          );
                        }),
                      ],

                      // ── Notes ────────────────────────────────────
                      _buildTextField(
                        controller: isExpense
                            ? controller.notes1C
                            : controller.notes2C,
                        hint: 'add your notes here',
                        maxLines: 4,
                      ),

                      const SizedBox(height: 24),

                      // ── Action buttons ───────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                isExpense
                                    ? controller.tambahExpense(
                                        controller.notes1C.text,
                                      )
                                    : controller.tambahTransaksiIncome(
                                        controller.notes2C.text,
                                      );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D3A8C),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDatePicker() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(12),
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.single,
            showActionButtons: true,
            selectionColor: const Color(0xFF3D5AF1),
            todayHighlightColor: const Color(0xFF3D5AF1),
            maxDate: DateTime.now(),
            onCancel: () => Get.back(),
            onSubmit: (obj) {
              final date = obj as DateTime;
              controller.nilaiTanggal.value =
                  '${date.day}-${date.month}-${date.year}';
              Get.back();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1A1D2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF3D5AF1),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// ── Category Box ─────────────────────────────────────────────────────────────
class _CategoryBox extends StatelessWidget {
  final String name;
  final String iconUrl;
  final bool isSelected;
  final double size;

  const _CategoryBox({
    required this.name,
    required this.iconUrl,
    required this.isSelected,
    required this.size,
  });

  // Warna gradient per kategori
  List<Color> _gradientColors() {
    switch (name.toLowerCase()) {
      case 'food':
        return [const Color(0xFFFF6B35), const Color(0xFFFF8C42)];
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
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2.5)
                  : null,
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
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
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
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1D2E),
            ),
          ),
        ],
      ),
    );
  }
}