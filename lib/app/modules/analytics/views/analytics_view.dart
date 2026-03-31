import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 0),
        child: Column(
          children: [
            // ── AppBar ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    Get.back();
                    await controller.resetForm();
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
                          initialSelectedDate: null,
                          todayHighlightColor: Colors.transparent,
                          showNavigationArrow: true,
                          showTodayButton: false,
                          startRangeSelectionColor: Color(0xFFBC9CC6),
                          endRangeSelectionColor: Color(0xFFBC9CC6),
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
                                  "${DateFormat('EEEE, d MMMM yyyy').format(range.startDate!)} - "
                                  "${DateFormat('EEEE, d MMMM yyyy').format(range.endDate!)}";
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GetBuilder<AnalyticsController>(
                builder: (controller) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      // ── Toggle Expense / Income ────────────────────────────
                      Obx(() {
                        return Row(
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
                        );
                      }),

                      // ── Chart ──────────────────────────────────────────────
                      Obx(() {
                        final currentType = controller.transactionType.value;
                        return FutureBuilder<Map<String, double>>(
                          future: controller.getChartMetrics(),
                          builder: (context, metricsSnapshot) {
                            if (!metricsSnapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final metrics = metricsSnapshot.data!;
                            final totalIncome = metrics['totalIncome'] ?? 0;
                            final totalExpense = metrics['totalExpense'] ?? 0;
                            final isIncome = currentType == "income";
                            final maxValue = isIncome
                                ? totalIncome
                                : totalExpense;

                            return StreamBuilder<List<CategoryData>>(
                              // ✅ key memaksa rebuild saat type berubah
                              key: ValueKey(currentType),
                              stream: controller.streamChartData(),
                              builder: (context, snapshot) {
                                final chartData = snapshot.data ?? [];

                                return Center(
                                  child: SfCircularChart(
                                    annotations: <CircularChartAnnotation>[
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
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            Text(
                                              isIncome ? "Income" : "Expense",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    // ✅ FIXED: legend tampil untuk income maupun expense
                                    legend: Legend(
                                      isVisible: chartData.isNotEmpty,
                                      position: LegendPosition.bottom,
                                      overflowMode: LegendItemOverflowMode.wrap,
                                      legendItemBuilder:
                                          (
                                            legendText,
                                            series,
                                            point,
                                            seriesIndex,
                                          ) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  margin: const EdgeInsets.only(
                                                    right: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: chartData.isNotEmpty
                                                        ? chartData[seriesIndex %
                                                                  chartData
                                                                      .length]
                                                              .color
                                                        : Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                Text(
                                                  legendText,
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 12,
                                                      ),
                                                ),
                                                const SizedBox(width: 12),
                                              ],
                                            );
                                          },
                                    ),
                                    series: <CircularSeries>[
                                      if (chartData.isEmpty)
                                        RadialBarSeries<CategoryData, String>(
                                          dataSource: [
                                            CategoryData(
                                              'No Data',
                                              1,
                                              Colors.grey.shade300,
                                            ),
                                          ],
                                          xValueMapper: (d, _) => d.category,
                                          yValueMapper: (d, _) => d.value,
                                          pointColorMapper: (d, _) => d.color,
                                          radius: '100%',
                                          innerRadius: '50%',
                                          gap: '3%',
                                          maximumValue: 1,
                                          cornerStyle: CornerStyle.bothCurve,
                                          trackColor: const Color(0xFFEEEEEE),
                                          trackBorderWidth: 0,
                                        )
                                      else
                                        RadialBarSeries<CategoryData, String>(
                                          dataSource: chartData,
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
                                );
                              },
                            );
                          },
                        );
                      }),

                      // ── List / Summary ─────────────────────────────────────
                      Obx(
                        () => controller.transactionType.value == "expense"
                            // ── EXPENSE: list per tanggal ──────────────────
                            ? Expanded(
                                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.datatransaksi(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.receipt_long_outlined,
                                              size: 48,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 12),
                                            Obx(
                                              () => Text(
                                                controller
                                                        .nilaiTanggal
                                                        .value
                                                        .isEmpty
                                                    ? "No expenses found"
                                                    : "No expenses on\n${controller.nilaiTanggal.value}",
                                                textAlign: TextAlign.center,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey[500],
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    var data = snapshot.data!.docs;

                                    return ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        var transactionData = data[index]
                                            .data();
                                        String docId = data[index].id;

                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 20,
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFBC9CC6),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat(
                                                  'EEEE, d MMMM yyyy',
                                                ).format(
                                                  DateFormat("d-M-yyyy").parse(
                                                    transactionData['date'],
                                                  ),
                                                ),
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey[900],
                                                    ),
                                              ),
                                              const SizedBox(height: 10),
                                              StreamBuilder<
                                                QuerySnapshot<
                                                  Map<String, dynamic>
                                                >
                                              >(
                                                stream: controller
                                                    .streamExpenseItem(docId),
                                                builder: (context, itemSnapshot) {
                                                  if (itemSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }

                                                  if (!itemSnapshot.hasData ||
                                                      itemSnapshot
                                                          .data!
                                                          .docs
                                                          .isEmpty) {
                                                    return Center(
                                                      child: Text(
                                                        "No expenses found Today",
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                      ),
                                                    );
                                                  }

                                                  var dataItem =
                                                      itemSnapshot.data!;
                                                  var rupiah = Rupiah();

                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        dataItem.docs.length,
                                                    itemBuilder: (context, i) {
                                                      var item =
                                                          dataItem.docs[i];
                                                      return Column(
                                                        children: [
                                                          ListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            leading: SizedBox(
                                                              width: 42,
                                                              height: 42,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      8,
                                                                    ),
                                                                child: SvgPicture.network(
                                                                  item['icon'],
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            ),
                                                            title: Text(
                                                              item['category'],
                                                              style: GoogleFonts.plusJakartaSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            subtitle: Text(
                                                              item['notes'],
                                                              style: GoogleFonts.plusJakartaSans(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey[900],
                                                              ),
                                                            ),
                                                            trailing: Text(
                                                              "-${rupiah.convertToRupiah('${item['amount']}')}",
                                                              style: GoogleFonts.plusJakartaSans(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                          if (i !=
                                                              dataItem
                                                                      .docs
                                                                      .length -
                                                                  1)
                                                            const Divider(
                                                              height: 16,
                                                              thickness: 1,
                                                              color: Color(
                                                                0xFFBC9CC6,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            // ── INCOME: hanya Total Income ─────────────────
                            : FutureBuilder<Map<String, double>>(
                                future: controller.calculateTotals(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData)
                                    return const SizedBox.shrink();

                                  final totals = snapshot.data!;
                                  final totalIncome =
                                      totals['totalIncome'] ?? 0;
                                  var rupiah = Rupiah();

                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: const Color(0xFFBC9CC6),
                                          width: 0.8,
                                        ),
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
                                          Obx(
                                            () => Text(
                                              controller
                                                      .nilaiTanggal
                                                      .value
                                                      .isEmpty
                                                  ? "All time"
                                                  : controller
                                                        .nilaiTanggal
                                                        .value,
                                              textAlign: TextAlign.center,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      69,
                                                      69,
                                                      69,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Income',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey[900],
                                                    ),
                                              ),
                                              Text(
                                                '+${rupiah.convertToRupiah('$totalIncome')}',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.green,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
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
}

class CategoryData {
  final String category;
  final double value;
  final Color color;

  CategoryData(this.category, this.value, this.color);
}
