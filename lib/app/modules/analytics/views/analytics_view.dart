// ignore_for_file: must_be_immutable
import 'package:budgi/app/bahasa/category_helper.dart';
import 'package:budgi/app/modules/widgets/loading_awal.dart';
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
            _buildHeader(),
            _buildTabToggle(),
            const SizedBox(height: 16),
            Expanded(child: _buildContent()),
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
                  'analytics'.tr,
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
          GestureDetector(
            onTap: _showDatePicker,
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
    );
  }

  Widget _buildTabToggle() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _TabItem(
              label: 'expenses'.tr,
              isSelected: controller.transactionType.value == 'expense',
              onTap: controller.liatExpense,
            ),
            _TabItem(
              label: 'income'.tr,
              isSelected: controller.transactionType.value == 'income',
              onTap: controller.liatIncome,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return GetBuilder<AnalyticsController>(
      builder: (ctrl) => Obx(() {
        final currentType = ctrl.transactionType.value;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ctrl.streamAllTransactions(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: loading_awal());
            }

            final allDocs = snapshot.data!.docs;
            final filteredItems = ctrl.filterByType(allDocs, currentType);
            final metrics = ctrl.computeMetrics(allDocs);
            final chartData = ctrl.buildChartData(filteredItems, currentType);

            final maxValue = currentType == 'income'
                ? metrics['totalIncome']!
                : metrics['totalExpense']!;

            final Map<String, List<Map<String, dynamic>>> grouped = {};
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
                  _buildChartCard(
                    ctrl,
                    chartData,
                    maxValue,
                    currentType,
                    filteredItems,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'activity'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  dates.isEmpty
                      ? _emptyState(ctrl)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dates.length,
                          itemBuilder: (context, i) => _DateGroup(
                            date: dates[i],
                            items: grouped[dates[i]]!,
                            isIncome: currentType == 'income',
                          ),
                        ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildChartCard(
    AnalyticsController ctrl,
    List<CategoryData> chartData,
    double maxValue,
    String currentType,
    List<Map<String, dynamic>> filteredItems,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
          : _BarChart(filteredItems: filteredItems, ctrl: ctrl),
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
            maxDate: DateTime.now(),
            showTodayButton: false,
            startRangeSelectionColor: const Color(0xFF3D5AF1),
            endRangeSelectionColor: const Color(0xFF3D5AF1),
            rangeSelectionColor: const Color(0xFF3D5AF1).withOpacity(0.15),
            onCancel: Get.back,
            onSubmit: (obj) {
              final range = obj as PickerDateRange;
              if (range.endDate == null) {
                controller.pickDateRange(range.startDate!, range.startDate!);
                controller.nilaiTanggal.value = DateFormat(
                  'EEEE, d MMMM yyyy',
                ).format(range.startDate!);
              } else {
                controller.pickDateRange(range.startDate!, range.endDate!);
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
          Obx(() {
            final isExpense = ctrl.transactionType.value == "expense";
            final emptyKey = isExpense ? 'no_expense_found' : 'no_income_found';
            final emptyOnKey = isExpense ? 'no_expense_on' : 'no_income_on';
            return Text(
              ctrl.nilaiTanggal.value.isEmpty
                  ? emptyKey.tr
                  : '${emptyOnKey.tr}\n${ctrl.nilaiTanggal.value}',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Tab Item ──────────────────────────────────────────────────────────────────
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
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? const Color(0xFF3D5AF1) : Colors.grey[500],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3D5AF1) : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Radial Chart ──────────────────────────────────────────────────────────────
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
    // ✅ Hitung total untuk persentase
    final total = chartData.fold<double>(0, (sum, d) => sum + d.value);

    return Column(
      children: [
        SizedBox(
          height: 240,
          child: SfCircularChart(
            annotations: [
              CircularChartAnnotation(
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'total_value'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1D2E),
                      ),
                    ),
                    Text(
                      currentType == 'income' ? 'income'.tr : 'expenses'.tr,
                      style: GoogleFonts.plusJakartaSans(
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
        ),

        // ✅ Legend pills dengan persentase
        if (chartData.isNotEmpty && total > 0) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: chartData.map((d) {
              final pct = ((d.value / total) * 100).round();
              return _LegendPill(
                label: translateCategory(d.category),
                percent: pct,
                color: d.color,
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

// ── Legend Pill ───────────────────────────────────────────────────────────────
class _LegendPill extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;

  const _LegendPill({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label  $percent%',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bar Chart ─────────────────────────────────────────────────────────────────
class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> filteredItems;
  final AnalyticsController ctrl;

  const _BarChart({required this.filteredItems, required this.ctrl});

  @override
  Widget build(BuildContext context) {
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
        // ✅ Support format ISO yyyy-MM-dd dan lama d-M-yyyy
        DateTime dt;
        if (dateStr.length >= 10 && dateStr[4] == '-') {
          dt = DateTime.parse(dateStr);
        } else {
          dt = DateFormat('d-M-yyyy').parse(dateStr);
        }
        final day = dt.day;
        final key = day <= 6
            ? '1-6'
            : day <= 12
                ? '7-12'
                : day <= 18
                    ? '13-18'
                    : day <= 24
                        ? '19-24'
                        : '25-30';
        weeklyTotals[key] =
            (weeklyTotals[key] ?? 0) + (item['amount'] as num).toDouble();
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
          labelStyle: GoogleFonts.plusJakartaSans(
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
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: Colors.grey[400],
          ),
          numberFormat: NumberFormat.compact(),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: const Color(0xFF2D3A8C),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
        series: [
          ColumnSeries<_BarData, String>(
            dataSource: barData,
            xValueMapper: (d, _) => d.label,
            yValueMapper: (d, _) => d.value,
            color: const Color.fromARGB(138, 0, 142, 38).withOpacity(0.7),
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
  const _BarData(this.label, this.value);
}

// ── Date Group ────────────────────────────────────────────────────────────────
class _DateGroup extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> items;
  final bool isIncome;

  const _DateGroup({
    required this.date,
    required this.items,
    this.isIncome = false,
  });

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
            _formatDate(items[0]['date']),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                Divider(height: 14, color: Colors.grey[300]),
            itemBuilder: (context, i) {
              final item = items[i];
              return Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                   
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.network(
                      item['icon'] ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translateCategory(item['category'] ?? ''),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1D2E),
                          ),
                        ),
                        if ((item['notes'] ?? '').toString().trim().isNotEmpty)
                          Text(
                            item['notes'],
                            style: GoogleFonts.plusJakartaSans(
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
              );
            },
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
  const CategoryData(this.category, this.value, this.color);
}

// ✅ Support ISO (yyyy-MM-dd) dan format lama (d-M-yyyy)
String _formatDate(dynamic rawDate) {
  if (rawDate == null || rawDate.toString().isEmpty) return '';
  try {
    final raw = rawDate.toString();
    if (raw.length >= 10 && raw[4] == '-') {
      final dt = DateTime.parse(raw);
      return DateFormat('d MMMM yyyy').format(dt);
    }
    return DateFormat('d MMMM yyyy')
        .format(DateFormat('d-M-yyyy').parse(raw));
  } catch (_) {
    return rawDate.toString();
  }
}