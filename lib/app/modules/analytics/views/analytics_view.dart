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
      backgroundColor: const Color(0xFFF0EBF8),
      body: SafeArea(
        bottom: true,
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
                          'Analytics',
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
                          onTap: () async {
                            await controller.resetForm();
                            Get.back();
                          },
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

                  // Date picker trigger
                  GestureDetector(
                    onTap: () => _showDatePicker(),
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
            ),

            // ── Tab Toggle ────────────────────────────────────────────
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _TabItem(
                      label: 'Expense',
                      isSelected: controller.transactionType.value == 'expense',
                      onTap: controller.liatExpense,
                    ),
                    _TabItem(
                      label: 'Income',
                      isSelected: controller.transactionType.value == 'income',
                      onTap: controller.liatIncome,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: GetBuilder<AnalyticsController>(
                builder: (ctrl) => Obx(() {
                  final currentType = ctrl.transactionType.value;

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: ctrl.streamAllTransactions(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final allDocs = snapshot.data!.docs;
                      final filteredItems =
                          ctrl.filterByType(allDocs, currentType);
                      final metrics = ctrl.computeMetrics(allDocs);
                      final chartData =
                          ctrl.buildChartData(filteredItems, currentType);
                      final percentages =
                          ctrl.computeCategoryPercentages(filteredItems);

                      final maxValue = currentType == 'income'
                          ? metrics['totalIncome']!
                          : metrics['totalExpense']!;

                      // Group by date for list
                      final Map<String, List<Map<String, dynamic>>> grouped =
                          {};
                      for (final item in filteredItems) {
                        final date = item['date'] as String;
                        grouped.putIfAbsent(date, () => []).add(item);
                      }
                      final dates = grouped.keys.toList();

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // ── Chart Card ──────────────────────────
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: currentType == 'expense'
                                  ? _RadialChart(
                                      chartData: chartData,
                                      maxValue: maxValue,
                                      currentType: currentType,
                                    )
                                  : _BarChart(
                                      filteredItems: filteredItems,
                                      ctrl: ctrl,
                                    ),
                            ),

                            const SizedBox(height: 16),

                            // ── Category Bubbles ─────────────────────
                            if (percentages.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: (percentages.entries.toList()
                                      ..sort(
                                        (a, b) => b.value.compareTo(a.value),
                                      ))
                                    .map(
                                      (entry) => _CategoryBubble(
                                        label: entry.key,
                                        percentage: entry.value,
                                        color: currentType == 'income'
                                            ? ctrl.getIncomeCategoryColor(
                                                entry.key,
                                              )
                                            : ctrl.getExpenseCategoryColor(
                                                entry.key,
                                              ),
                                      ),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 16),

                            // ── List / Summary ───────────────────────
                            if (currentType == 'expense')
                              dates.isEmpty
                                  ? _emptyState(ctrl)
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: dates.length,
                                      itemBuilder: (context, i) =>
                                          _DateGroup(
                                            date: dates[i],
                                            items: grouped[dates[i]]!,
                                          ),
                                    )
                            else
                              _IncomeSummaryCard(
                                totalIncome: metrics['totalIncome']!,
                                nilaiTanggal: ctrl.nilaiTanggal.value,
                              ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
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
              final range = obj as PickerDateRange;
              if (range.endDate == null) {
                controller.pickDateRange(
                  range.startDate!,
                  range.startDate!,
                );
                controller.nilaiTanggal.value =
                    DateFormat('EEEE, d MMMM yyyy').format(range.startDate!);
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
    );
  }

  Widget _emptyState(AnalyticsController ctrl) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              ctrl.nilaiTanggal.value.isEmpty
                  ? 'No expenses found'
                  : 'No expenses on\n${ctrl.nilaiTanggal.value}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab Item ─────────────────────────────────────────────────────────────────
class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF3D5AF1)
                      : Colors.grey[500],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF3D5AF1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Radial Chart (Expense) ────────────────────────────────────────────────────
class _RadialChart extends StatelessWidget {
  final List<CategoryData> chartData;
  final double maxValue;
  final String currentType;

  const _RadialChart({
    required this.chartData,
    required this.maxValue,
    required this.currentType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: SfCircularChart(
        annotations: [
          CircularChartAnnotation(
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Value',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1D2E),
                  ),
                ),
                Text(
                  currentType == 'income' ? 'Income' : 'Expense',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
        series: [
          RadialBarSeries<CategoryData, String>(
            dataSource: chartData.isEmpty
                ? [CategoryData('No Data', 1, Colors.grey.shade200)]
                : chartData,
            xValueMapper: (d, _) => d.category,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            radius: '100%',
            innerRadius: '50%',
            gap: '3%',
            maximumValue: maxValue > 0 ? maxValue : 1,
            cornerStyle: CornerStyle.bothCurve,
            trackColor: const Color(0xFFF0EBF8),
            trackBorderWidth: 0,
          ),
        ],
      ),
    );
  }
}

// ── Bar Chart (Income) ────────────────────────────────────────────────────────
class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> filteredItems;
  final AnalyticsController ctrl;

  const _BarChart({required this.filteredItems, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    // Group by week range (1-6, 7-12, 13-18, 19-24, 25-30)
    final Map<String, double> weeklyTotals = {
      '1-6': 0,
      '7-12': 0,
      '13-18': 0,
      '19-24': 0,
      '25-30': 0,
    };

    for (final item in filteredItems) {
      final dateStr = item['date'] as String;
      try {
        final date = DateFormat('d-M-yyyy').parse(dateStr);
        final day = date.day;
        String key;
        if (day <= 6) key = '1-6';
        else if (day <= 12) key = '7-12';
        else if (day <= 18) key = '13-18';
        else if (day <= 24) key = '19-24';
        else key = '25-30';
        weeklyTotals[key] = (weeklyTotals[key] ?? 0) +
            (item['amount'] as num).toDouble();
      } catch (_) {}
    }

    final barData = weeklyTotals.entries
        .map((e) => _BarData(e.key, e.value))
        .toList();

    return SizedBox(
      height: 240,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
        primaryYAxis: NumericAxis(
          isVisible: true,
          majorGridLines: const MajorGridLines(
            width: 0.5,
            color: Color(0xFFEEEEEE),
          ),
          axisLine: const AxisLine(width: 0),
          labelStyle: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey[400],
          ),
          numberFormat: NumberFormat.compact(),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: const Color(0xFF2D3A8C),
          textStyle: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
        series: [
          ColumnSeries<_BarData, String>(
            dataSource: barData,
            xValueMapper: (d, _) => d.label,
            yValueMapper: (d, _) => d.value,
            color: const Color(0xFF3D5AF1).withOpacity(0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            width: 0.5,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String label;
  final double value;
  _BarData(this.label, this.value);
}

// ── Date Group ────────────────────────────────────────────────────────────────
class _DateGroup extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> items;

  const _DateGroup({required this.date, required this.items});

  @override
  Widget build(BuildContext context) {
    final rupiah = Rupiah();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, d MMMM yyyy')
                .format(DateFormat('d-M-yyyy').parse(date)),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                Divider(height: 14, color: Colors.grey[100]),
            itemBuilder: (context, i) {
              final item = items[i];
              return Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.network(
                      item['icon'],
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['category'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1D2E),
                          ),
                        ),
                        if (item['notes'] != null &&
                            item['notes'].toString().trim().isNotEmpty)
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
                  Text(
                    '-${rupiah.convertToRupiah('${item['amount']}')}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE74C3C),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Income Summary Card ───────────────────────────────────────────────────────
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Income',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1D2E),
            ),
          ),
          Text(
            '+${rupiah.convertToRupiah('$totalIncome')}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2ECC71),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category Bubble ───────────────────────────────────────────────────────────
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.9),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: GoogleFonts.poppins(
              fontSize: 11,
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