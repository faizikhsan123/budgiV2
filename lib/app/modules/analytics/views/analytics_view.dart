import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back, size: 30),
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
                        padding: const EdgeInsets.all(20),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode
                              .range, //ini bisa multipel
                          showActionButtons: true,
                          initialSelectedDate: null,
                          todayHighlightColor: Colors.transparent,
                          showNavigationArrow: true,
                          showTodayButton: false,
                          selectionColor: Color(0xFFBC9CC6),
                          onCancel: () => Get.back(),
                          onSubmit: (obj) {
                            final range = obj as PickerDateRange;
                            print(obj);

                            if (range.endDate == null) {
                              //single date
                              controller.pickDateRange(
                                range.startDate!,
                                range.startDate!,
                              );
                            } else {
                              controller.pickDateRange(
                                range.startDate!,
                                range.endDate!,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 209, 194, 214),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(width: 4),

                          Icon(Icons.calendar_month_outlined, size: 20),
                        ],
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
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => controller.liatExpense(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      controller.transactionType.value ==
                                          "expense"
                                      ? Color(0xFFB695C0)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFBC9CC6),
                                    width: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(0, -1),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(1, 0),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(-1, 0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    "Expense",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          controller.transactionType.value ==
                                              "expense"
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.liatIncome(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      controller.transactionType.value ==
                                          "income"
                                      ? Color(0xFFB695C0)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFBC9CC6),
                                    width: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(0, -1),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(1, 0),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFBC9CC6),
                                      blurRadius: 3,
                                      offset: const Offset(-1, 0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    "Income",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          controller.transactionType.value ==
                                              "income"
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      SizedBox(height: 30),

                      Obx(
                        () => controller.transactionType.value == "expense"
                            ? Expanded(
                                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.dataExpenseAll(),
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
                                        height: 200,
                                        child: const Center(
                                          child: Text(
                                            "Pengeluaran belum ada",
                                            textAlign: TextAlign.center,
                                          ),
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
                                            border: Border(
                                              top: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                              bottom: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                              left: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                              right: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(0, -1),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(1, 0),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(-1, 0),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /// DATE
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

                                                  if (!itemSnapshot.hasData) {
                                                    return const Text(
                                                      "Belum ada transaksi",
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
                                                            leading: Container(
                                                              width: 42,
                                                              height: 42,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      8,
                                                                    ),
                                                                child: Image.network(
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
                                                            Divider(
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
                            : Expanded(
                                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.dataIncomeAll(),
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
                                        height: 200,
                                        child: const Center(
                                          child: Text(
                                            "Pemasukan belum ada",
                                            textAlign: TextAlign.center,
                                          ),
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
                                            border: Border(
                                              top: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                              bottom: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                              left: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                              right: BorderSide(
                                                color: const Color(0xFFBC9CC6),
                                                width: 0.8,
                                              ),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(0, -1),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(1, 0),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFFBC9CC6),
                                                blurRadius: 3,
                                                offset: const Offset(-1, 0),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /// DATE
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
                                                    .streamIncomeItem(docId),
                                                builder: (context, itemSnapshot) {
                                                  if (itemSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }

                                                  if (!itemSnapshot.hasData) {
                                                    return const Text(
                                                      "Belum ada transaksi",
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
                                                            leading: Container(
                                                              width: 42,
                                                              height: 42,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      8,
                                                                    ),
                                                                child: Image.network(
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
                                                              "+ ${rupiah.convertToRupiah('${item['amount']}')}",
                                                              style: GoogleFonts.plusJakartaSans(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                          if (i !=
                                                              dataItem
                                                                      .docs
                                                                      .length -
                                                                  1)
                                                            Divider(
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
