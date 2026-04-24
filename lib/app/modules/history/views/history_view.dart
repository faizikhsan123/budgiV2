import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EBF8),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          'History',
                          style: GoogleFonts.plusJakartaSans(
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
                  const SizedBox(height: 4),

                  // Date filter trigger
                  GestureDetector(
                    onTap: () => _showDatePicker(),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.nilaiTanggal.value,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3D5AF1),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: Color(0xFF3D5AF1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Search Bar ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller.searchC,
                onChanged: controller.search,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: const Color(0xFF1A1D2E),
                ),
                decoration: InputDecoration(
                  hintText: 'search here',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF3D5AF1),
                    size: 20,
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
              ),
            ),
            const SizedBox(height: 16),

            // ── List ──────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                // Reactive dependencies
                final _ = controller.keyword.value;
                final __ = controller.start.value;
                final ___ = controller.end.value;

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.transactionsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _EmptyState();
                    }

                    final docs = snapshot.data!.docs;
                    final rupiah = Rupiah();

                    // Group by date
                    final Map<
                      String,
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    >
                    grouped = {};
                    for (final doc in docs) {
                      final date = doc.data()['date']?.toString() ?? '';
                      grouped.putIfAbsent(date, () => []).add(doc);
                    }
                    final dates = grouped.keys.toList();

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: dates.length,
                      itemBuilder: (context, i) {
                        final date = dates[i];
                        final items = grouped[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date label
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 4),
                              child: Text(
                                _formatDate(date),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),

                            // Items for this date
                            ...items.map((doc) {
                              final item = doc.data();
                              final bool isIncome = item['type'] == 'income';

                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                  Routes.CRUD,
                                  arguments: {...item, 'id': doc.id},
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F6FA),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(7),
                                        child: SvgPicture.network(
                                          item['icon'] ?? '',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Category + notes
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['category'] ?? '',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xFF1A1D2E,
                                                    ),
                                                  ),
                                            ),
                                            if ((item['notes'] ?? '')
                                                .toString()
                                                .trim()
                                                .isNotEmpty)
                                              Text(
                                                item['notes'],
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 11,
                                                      color: Colors.grey[500],
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Amount
                                      Text(
                                        isIncome
                                            ? '+${rupiah.convertToRupiah('${item['amount']}')}'
                                            : '-${rupiah.convertToRupiah('${item['amount']}')}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isIncome
                                              ? const Color(0xFF2ECC71)
                                              : const Color(0xFFE74C3C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 4),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(12),
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            showActionButtons: true,
            todayHighlightColor: Colors.transparent,
            showNavigationArrow: true,
            showTodayButton: false,
            startRangeSelectionColor: const Color(0xFF3D5AF1),
            endRangeSelectionColor: const Color(0xFF3D5AF1),
            rangeSelectionColor: const Color(0xFF3D5AF1).withOpacity(0.15),
            onCancel: () => Get.back(),
            onSubmit: (obj) {
              if (obj == null) return;
              final range = obj as PickerDateRange;
              if (range.startDate == null) return;

              final endDate = range.endDate ?? range.startDate!;
              controller.pickDateRange(range.startDate!, endDate);
              // Get.back() sudah dipanggil di dalam pickDateRange
            },
          ),
        ),
      ),
    );
  }

  String _currentDateLabel() {
    final start = controller.start.value;
    final end = controller.end.value;
    if (start == null) return DateFormat('MMMM yyyy').format(DateTime.now());
    if (start == end || end == null) {
      return DateFormat('d MMM yyyy').format(start);
    }
    return '${DateFormat('d MMM').format(start)} - ${DateFormat('d MMM yyyy').format(end)}';
  }

  String _formatDate(String rawDate) {
    try {
      return DateFormat(
        'EEEE, d MMMM yyyy',
      ).format(DateFormat('d-M-yyyy').parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 52, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No transactions found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
