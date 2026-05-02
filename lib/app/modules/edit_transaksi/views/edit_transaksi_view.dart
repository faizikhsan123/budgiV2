import 'package:budgi/app/bahasa/category_helper.dart';
import 'package:budgi/app/modules/widgets/Input_rupiah_transaksi.dart';
import 'package:budgi/app/modules/widgets/loading_awal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/edit_transaksi_controller.dart';

class EditTransaksiView extends GetView<EditTransaksiController> {
  const EditTransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    final rupiah = Rupiah();
    final args = Get.arguments as Map<String, dynamic>;

    final String notes = args['notes'] ?? '';
    final String icon = args['icon'] ?? '';
    controller.amountC.text = rupiah.convertToRupiah('${args['amount'] ?? ''}');
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 50),

                        Text(
                          'edit_transaction'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1D2E),
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ── Icon ────────────────────────────────────
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: SvgPicture.network(
                              icon,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Amount display ───────────────────────────
                          Text(
                            rupiah.convertToRupiah('${args['amount'].toInt()}'),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1D2E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notes,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ── Category ─────────────────────────────────
                          _FormRow(
                            label: 'category'.tr,
                            child: Obx(() {
                              final isIncome =
                                  controller.selectedType.value == 'income';
                              if (isIncome) {
                                // 🔒 TAMPILAN SAJA (tidak bisa diedit)
                                return Text(
                                  translateCategory(
                                    controller.selectedCategory.value,
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: const Color(0xFF1A1D2E),
                                  ),
                                );
                              }

                              // ✅ DROPDOWN (bisa diedit)
                              return DropdownButton<String>(
                                value: controller.selectedCategory.value.isEmpty
                                    ? null
                                    : controller.selectedCategory.value,
                                underline: const SizedBox.shrink(),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 20,
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: const Color(0xFF1A1D2E),
                                ),
                                items: controller.categories.map((c) {
                                  return DropdownMenuItem(
                                    value: c,
                                    child: Text(translateCategory(c)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    controller.selectedCategory.value = val;
                                  }
                                },
                              );
                            }),
                          ),
                          Divider(height: 20, color: Colors.grey[400]),

                          // ── Amount input ──────────────────────────────
                          _FormRow(
                            label: 'amount'.tr,

                            child: SizedBox(
                              width: 140,
                              child: input_rupiah_transaksi(
                                amountC: controller.amountC,
                                hintText: 'Rp ',
                              ),
                            ),
                          ),
                          Divider(height: 20, color: Colors.grey[400]),

                          // ── Date ─────────────────────────────────────
                          _FormRow(
                            label: 'date'.tr,
                            child: GestureDetector(
                              onTap: () {
                                Get.dialog(
                                  Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      height: 400,
                                      padding:  EdgeInsets.all(12),
                                      child: SfDateRangePicker(
                                        selectionMode:
                                            DateRangePickerSelectionMode.single,
                                        showActionButtons: true,
                                        todayHighlightColor: Colors.transparent,
                                        maxDate: DateTime.now(),
                                        showNavigationArrow: true,
                                        showTodayButton: false,
                                        startRangeSelectionColor: Color.fromARGB(255, 0, 0, 0),
                                        endRangeSelectionColor: Color(
                                          0xFF3D5AF1,
                                        ),
                                        rangeSelectionColor: Color(
                                          0xFF3D5AF1,
                                        ).withOpacity(0.15),
                                        onCancel: Get.back,
                                        onSubmit: (obj) {
                                          if (obj == null) return;

                                          final date = obj as DateTime;

                                          controller.selectedDate.value =
                                              '${date.day}-${date.month}-${date.year}';

                                          Get.back(); // 🔥 penting biar dialog nutup
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },

                              child: Obx(
                                () => Text(
                                  controller.selectedDate.value.isEmpty
                                      ? 'select_date'.tr
                                      : _formatDate(
                                          controller.selectedDate.value,
                                        ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: const Color(0xFF1A1D2E),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // ── Other category input ──────────────────────
                          Obx(() {
                            if (controller.selectedCategory.value
                                    .toLowerCase() !=
                                'other') {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                Divider(height: 20, color: Colors.grey[400]),
                                TextField(
                                  controller: controller.categoryNameC,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'category_name'.tr,
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: Colors.grey[400],
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF5F6FA),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          Divider(height: 20, color: Colors.grey[400]),

                          // ── Notes ────────────────────────────────────
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'notes_optional'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: controller.notesC,
                            maxLines: 3,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'add_note_hint'.tr,
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F6FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom Buttons ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'cancel'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : controller.save,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3A8C),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          alignment: Alignment.center,
                          child: controller.isLoading.value
                              ? const loading_awal()
                              : Text(
                                  'save'.tr,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Format tanggal sesuai locale aktif ─────────────────────────────────
  String _formatDate(dynamic rawDate) {
    if (rawDate == null || rawDate.toString().isEmpty) return '';
    try {
      // Ambil locale aktif dari GetX, format ke kode locale intl
      return DateFormat(
        'd-M-yyyy',
      ).format(DateFormat('d-M-yyyy').parse(rawDate.toString()));
    } catch (_) {
      return rawDate.toString();
    }
  }
}

// ── Helper Widget ─────────────────────────────────────────────────────────────
class _FormRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        child,
      ],
    );
  }
}
