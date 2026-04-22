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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),

      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 0),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back, size: 30),
                ),
                Text(
                  "History",
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

                          startRangeSelectionColor: Color(0xFFBC9CC6),
                          endRangeSelectionColor: Color(0xFFBC9CC6),
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
                      color: const Color.fromARGB(255, 255, 255, 255),
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
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            TextField(
              controller: controller.searchC,
              onChanged: (value) => controller.search(
                value,
              ), //menangkap data yang diketik pada textfield
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search by category or notes',
                suffixIcon: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Icon(Icons.search, color: Colors.amber),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),

            Expanded(
              child: Obx(() {
                final _ = controller.keyword.value;
                final __ = controller.start.value;
                final ___ = controller.end.value;

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.transactionsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: Text("No transactions found"));
                    }

                    // ← filter di client side
                    var dataItem = snapshot.data!.docs;

                    if (dataItem.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No transactions found",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    var rupiah = Rupiah();

                    return ListView.builder(
                      itemCount: dataItem!.length,
                      itemBuilder: (context, index) {
                        var item = dataItem![index].data();
                        // var item = filtered[index];
                        bool isIncome = item['type'] == "income";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFBC9CC6),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              Get.toNamed(
                                Routes.CRUD,
                                arguments: {
                                  ...item,
                                  "id":
                                      dataItem[index].id, // 🔥 INI YANG KURANG
                                },
                                
                              );
                            },
                            leading: SvgPicture.network(
                              item!['icon'] ?? '',
                              width: 30,
                              height: 30,
                            ),
                            title: Text(
                              item!['category'] ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item!['notes'] != null &&
                                    item!['notes'].toString().isNotEmpty)
                                  Text(item!['notes'] ?? ''),
                                Text(
                                  DateFormat('d MMM yyyy').format(
                                    DateFormat("d-M-yyyy").parse(item['date']),
                                  ),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                            trailing: Text(
                              isIncome
                                  ? "+ ${rupiah.convertToRupiah('${item['amount']}')}"
                                  : "- ${rupiah.convertToRupiah('${item['amount']}')}",
                              style: TextStyle(
                                color: isIncome ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
}
