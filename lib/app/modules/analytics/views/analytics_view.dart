// ignore_for_file: must_be_immutable
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 0),
        child: Column(
          children: [
            // ── AppBar ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    await controller.resetForm();
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back, size: 30),
                ),
                Text(
                  "Analytics",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => Get.dialog(
                    Dialog(
                      child: Container(
                        height: 400,
                        padding: const EdgeInsets.all(10),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.range,
                          showActionButtons: true,
                          todayHighlightColor: Colors.transparent,
                          showNavigationArrow: true,
                          showTodayButton: false,
                          startRangeSelectionColor: const Color(0xFFBC9CC6),
                          endRangeSelectionColor: const Color(0xFFBC9CC6),
                          onCancel: () => Get.back(),
                          onSubmit: (obj) {
                            final range = obj as PickerDateRange;
                            if (range.endDate == null) {
                              controller.pickDateRange(
                                range.startDate!,
                                range.startDate!,
                              );
                              controller.nilaiTanggal.value = DateFormat(
                                'EEEE, d MMMM yyyy',
                              ).format(range.startDate!);
                            } else {
                              controller.pickDateRange(
                                range.startDate!,
                                range.endDate!,
                              );
                              controller.nilaiTanggal.value =
                                  "${DateFormat('d MMM yyyy').format(range.startDate!)} - "
                                  "${DateFormat('d MMM yyyy').format(range.endDate!)}";
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFBC9CC6),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: const Icon(
                      Icons.calendar_month_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GetBuilder<AnalyticsController>(
                builder: (controller) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // ── Toggle ──
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.transactionType.value ==
                                          "expense"
                                      ? const Color(0xFFBC9CC6)
                                      : Colors.white,
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 197, 160, 208),
                                    width: 2,
                                  ),
                                ),
                                onPressed: controller.liatExpense,
                                child: Text(
                                  "Expense",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        controller.transactionType.value ==
                                            "expense"
                                        ? Colors.white
                                        : const Color.fromARGB(255, 52, 51, 51),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.transactionType.value ==
                                          "income"
                                      ? const Color(0xFFBC9CC6)
                                      : Colors.white,
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 197, 160, 208),
                                    width: 2,
                                  ),
                                ),
                                onPressed: controller.liatIncome,
                                child: Text(
                                  "Income",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        controller.transactionType.value ==
                                            "income"
                                        ? Colors.white
                                        : const Color.fromARGB(255, 52, 51, 51),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Konten utama — satu StreamBuilder untuk segalanya ──
                      Expanded(
                        child: Obx(() {
                          final currentType = controller.transactionType.value;

                          return StreamBuilder<
                            QuerySnapshot<Map<String, dynamic>>
                          >(
                            stream: controller.streamAllTransactions(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final allDocs = snapshot.data!.docs;

                              // Semua komputasi dilakukan di client, tidak ada nested stream
                              final filteredItems = controller.filterByType(
                                allDocs,
                                currentType,
                              );
                              final metrics = controller.computeMetrics(
                                allDocs,
                              );
                              final chartData = controller.buildChartData(
                                filteredItems,
                                currentType,
                              );
                              final percentages = controller
                                  .computeCategoryPercentages(filteredItems);

                              final maxValue = currentType == "income"
                                  ? metrics['totalIncome']!
                                  : metrics['totalExpense']!;

                              // Group by tanggal untuk list
                              final Map<String, List<Map<String, dynamic>>>
                              grouped = {};
                              for (final item in filteredItems) {
                                final date = item['date'] as String;
                                grouped.putIfAbsent(date, () => []).add(item);
                              }
                              final dates = grouped.keys.toList();

                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    // ── Radial Chart ──
                                    SizedBox(
                                      height: 260,
                                      child: SfCircularChart(
                                        annotations: [
                                          CircularChartAnnotation(
                                            widget: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Total Value",
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                                Text(
                                                  currentType == "income"
                                                      ? "Income"
                                                      : "Expense",
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        series: [
                                          RadialBarSeries<CategoryData, String>(
                                            dataSource: chartData.isEmpty
                                                ? [
                                                    CategoryData(
                                                      'No Data',
                                                      1,
                                                      Colors.grey.shade300,
                                                    ),
                                                  ]
                                                : chartData,
                                            xValueMapper: (d, _) => d.category,
                                            yValueMapper: (d, _) => d.value,
                                            pointColorMapper: (d, _) => d.color,
                                            radius: '100%',
                                            innerRadius: '50%',
                                            gap: '3%',
                                            maximumValue: maxValue > 0
                                                ? maxValue
                                                : 1,
                                            cornerStyle: CornerStyle.bothCurve,
                                            trackColor: const Color(0xFFEEEEEE),
                                            trackBorderWidth: 0,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ── Bubble persentase ──
                                    if (percentages.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 8,
                                        ),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          alignment: WrapAlignment.center,
                                          children:
                                              (percentages.entries.toList()
                                                    ..sort(
                                                      (a, b) => b.value
                                                          .compareTo(a.value),
                                                    ))
                                                  .map((entry) {
                                                    final color =
                                                        currentType == "income"
                                                        ? controller
                                                              .getIncomeCategoryColor(
                                                                entry.key,
                                                              )
                                                        : controller
                                                              .getExpenseCategoryColor(
                                                                entry.key,
                                                              );
                                                    return _CategoryBubble(
                                                      label: entry.key,
                                                      percentage: entry.value,
                                                      color: color,
                                                    );
                                                  })
                                                  .toList(),
                                        ),
                                      ),

                                    const SizedBox(height: 8),

                                    // ── List transaksi ──
                                    if (currentType == "expense") ...[
                                      if (dates.isEmpty)
                                        _emptyState(controller)
                                      else
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: dates.length,
                                          itemBuilder: (context, index) {
                                            final date = dates[index];
                                            final items = grouped[date]!;
                                            return _DateGroup(
                                              date: date,
                                              items: items,
                                            );
                                          },
                                        ),
                                    ] else ...[
                                      // Income summary
                                      _IncomeSummaryCard(
                                        totalIncome: metrics['totalIncome']!,
                                        nilaiTanggal:
                                            controller.nilaiTanggal.value,
                                      ),
                                    ],

                                    const SizedBox(height: 20),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
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

  Widget _emptyState(AnalyticsController controller) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              controller.nilaiTanggal.value.isEmpty
                  ? "No expenses found"
                  : "No expenses on\n${controller.nilaiTanggal.value}",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date Group Widget ──
class _DateGroup extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> items;
  const _DateGroup({required this.date, required this.items});

  @override
  Widget build(BuildContext context) {
    final rupiah = Rupiah();
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBC9CC6), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat(
              'EEEE, d MMMM yyyy',
            ).format(DateFormat("d-M-yyyy").parse(date)),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 16,
              thickness: 1,
              color: Color(0xFFBC9CC6),
            ),
            itemBuilder: (context, i) {
              final item = items[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 42,
                  height: 42,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.network(
                      item['icon'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(
                  item['category'],
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle:
                    (item['notes'] == null ||
                        item['notes'].toString().trim().isEmpty)
                    ? null
                    : Text(
                        item['notes'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[900],
                        ),
                      ),
                trailing: Text(
                  "-${rupiah.convertToRupiah('${item['amount']}')}",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Income Summary Card ──
class _IncomeSummaryCard extends StatelessWidget {
  final double totalIncome;
  final String nilaiTanggal;
  const _IncomeSummaryCard({
    required this.totalIncome,
    required this.nilaiTanggal,
  });

  @override
  Widget build(BuildContext context) {
    final rupiah = Rupiah();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBC9CC6), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFBC9CC6),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0xFFBC9CC6),
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
          BoxShadow(
            color: Color(0xFFBC9CC6),
            blurRadius: 3,
            offset: Offset(1, 0),
          ),
          BoxShadow(
            color: Color(0xFFBC9CC6),
            blurRadius: 3,
            offset: Offset(-1, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nilaiTanggal.isEmpty ? "All Time" : nilaiTanggal,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: const Color.fromARGB(255, 69, 69, 69),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Income",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
              Text(
                "+${rupiah.convertToRupiah('$totalIncome')}",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Category Bubble ──
class _CategoryBubble extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;
  const _CategoryBubble({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.45), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.85),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            "${percentage.toStringAsFixed(1)}%",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryData {
  final String category;
  final double value;
  final Color color;
  CategoryData(this.category, this.value, this.color);
}
