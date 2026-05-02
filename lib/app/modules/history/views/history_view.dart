import 'package:budgi/app/bahasa/category_helper.dart';
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
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  'history'.tr,
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
                  onTap: Get.back,
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
          GestureDetector(
            onTap: _showDatePicker,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.nilaiTanggal.value,
                    style: GoogleFonts.poppins(
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
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller.searchC,
        onChanged: controller.search,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: const Color(0xFF1A1D2E),
        ),
        decoration: InputDecoration(
          hintText: 'search_here'.tr,
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
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
            borderSide: const BorderSide(color: Color(0xFF3D5AF1), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
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
            return const _EmptyState();
          }

          final docs = snapshot.data!.docs;
          final filtered = controller.filterDocs(docs);
          if (filtered.isEmpty) return const _EmptyState();

          final rupiah = Rupiah();
          final Map<String, List<Map<String, dynamic>>> grouped = {};

          for (int i = 0; i < docs.length; i++) {
            final data = docs[i].data();
            final key = data['date']?.toString() ?? '';
            final matchesFilter = filtered.any(
              (f) =>
                  f['category'] == data['category'] &&
                  f['amount'] == data['amount'] &&
                  f['date'] == data['date'] &&
                  f['notes'] == data['notes'],
            );
            if (!matchesFilter) continue;
            grouped.putIfAbsent(key, () => []).add({
              ...data,
              '_docId': docs[i].id,
            });
          }

          final dates = grouped.keys.toList();
          if (dates.isEmpty) return const _EmptyState();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: dates.length,
            itemBuilder: (context, i) {
              final date = dates[i];
              final items = grouped[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 4),
                    child: Text(
                      _formatDate(date),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(items.length, (j) {
                        final item = items[j];
                        final bool isIncome = item['type'] == 'income';
                        final String docId = item['_docId'] ?? '';
                        final bool isLast = j == items.length - 1;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                   
                                    padding: const EdgeInsets.all(7),
                                    child: SvgPicture.network(
                                      item['icon'] ?? '',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translateCategory(
                                            item['category'] ?? '',
                                          ),

                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1A1D2E),
                                          ),
                                        ),
                                        if ((item['notes'] ?? '')
                                            .toString()
                                            .trim()
                                            .isNotEmpty)
                                          Text(
                                            item['notes'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey[500],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        isIncome
                                            ? '+${rupiah.convertToRupiah('${item['amount']}')}'
                                            : '-${rupiah.convertToRupiah('${item['amount']}')}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isIncome
                                              ? const Color(0xFF2ECC71)
                                              : const Color(0xFFE74C3C),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTapDown: (details) => _showPopupMenu(
                                          context,
                                          details.globalPosition,
                                          item,
                                          docId,
                                        ),
                                        child: const Icon(
                                          Icons.more_vert_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Divider(
                                height: 1,
                                indent: 14,
                                endIndent: 14,
                                color: Colors.grey[300],
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }

  

  void _showPopupMenu(
    BuildContext context,
    Offset position,
    Map<String, dynamic> item,
    String docId,
  ) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      items: [
        PopupMenuItem<String>(
          value: 'detail',
          child: Text(
            'view_details'.tr,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF1A1D2E),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'edit',
          child: Text(
            'update'.tr,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF3D5AF1),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            'delete'.tr,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFFE74C3C),
            ),
          ),
        ),
      ],
    );

    if (result == null) return;

    switch (result) {
      case 'detail':
        Get.toNamed(Routes.DETAIL, arguments: {...item, 'id': docId});
      case 'edit':
        Get.toNamed(Routes.EDIT_TRANSAKSI, arguments: {...item, 'id': docId});
      case 'delete':
        // controller.deleteTransaction(docId);
        break;
    }
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
            onCancel: Get.back,
            onSubmit: (obj) {
              if (obj == null) return;
              final range = obj as PickerDateRange;
              if (range.startDate == null) return;
              controller.pickDateRange(
                range.startDate!,
                range.endDate ?? range.startDate!,
              );
            },
          ),
        ),
      ),
    );
  }

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
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 52, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'no_transactions_found'.tr,
            style: GoogleFonts.poppins(
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
