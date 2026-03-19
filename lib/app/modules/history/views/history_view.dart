import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back, size: 30),
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
            SizedBox(height: 10),
            // buildTextField(
            //   hint: "Search",
            //   onchange: (value) {
              
                // controller.search(value);
                
            //   },
            //   filled: true,
            //   keyboardType: TextInputType.text,
            //   controller: controller.searchC,
            //   suffixIcon: const Icon(Icons.search, size: 25),
              
            // ),

            SizedBox(height: 10),

            Expanded(
              child: GetBuilder<HistoryController>(
                builder: (controller) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.allTransactions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: const Center(
                            child: Text(
                              "History transaksi blm ada",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      var dataPerhari = snapshot.data!;

                      return ListView.builder(
                        itemCount: dataPerhari.docs.length,
                        itemBuilder: (context, index) {
                          var doc = dataPerhari.docs[index];
                          String docId = doc.id;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFBC9CC6),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, d MMMM yyyy').format(
                                    DateFormat("d-M-yyyy").parse(doc['date']),
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>
                                >(
                                  stream: controller.DetailAllTransactions(
                                    docId,
                                  ),
                                  builder: (context, itemSnapshot) {
                                    if (itemSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (!itemSnapshot.hasData ||
                                        itemSnapshot.data!.docs.isEmpty) {
                                      return const Text("Belum ada transaksi");
                                    }

                                    var dataItem = itemSnapshot.data!;
                                    var rupiah = Rupiah();

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: dataItem.docs.length,
                                      itemBuilder: (context, i) {
                                        var item = dataItem.docs[i];

                                        bool isIncome =
                                            item['category'] == 'income';

                                        return Column(
                                          children: [
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: SizedBox(
                                                width: 42,
                                                height: 42,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  child: Image.network(
                                                    item['icon'],
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (
                                                          _,
                                                          __,
                                                          ___,
                                                        ) => const Icon(
                                                          Icons
                                                              .image_not_supported,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                item['category'],
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              subtitle: Text(
                                                item['notes'],
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 12,
                                                    ),
                                              ),
                                              trailing: Text(
                                                isIncome
                                                    ? "+ ${rupiah.convertToRupiah('${item['amount']}')}"
                                                    : "-${rupiah.convertToRupiah('${item['amount']}')}",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: isIncome
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                              ),
                                            ),
                                            if (i != dataItem.docs.length - 1)
                                              const Divider(),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
