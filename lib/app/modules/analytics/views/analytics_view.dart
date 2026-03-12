import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Analytics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                Dialog(
                  child: Container(
                    height: 400,
                    padding: const EdgeInsets.all(20),
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode
                          .range, //ini bisa multipel
                      showActionButtons: true,
                      onCancel: () => Get.back(),
                      onSubmit: (obj) {
                        // print(obj as PickerDateRange?);
                        // if (obj != null) {
                        //   if ((obj as PickerDateRange).endDate != null) {
                        //     controller.pickDate(obj.startDate!, obj.endDate!);
                        //   }
                        //   Get.snackbar('Gagal', 'Anda belum memilih tanggal');

                        // }
                      },
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      body: GetBuilder<AnalyticsController>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.liatExpense();
                    },
                    child: Text("Expense"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.liatIncome();
                    },
                    child: Text("Income"),
                  ),
                ],
              ),
              SizedBox(height: 30),

              /// STREAM TRANSACTIONS
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
                              return const Center(
                                child: Text("history is empty"),
                              );
                            }

                            var data = snapshot.data!.docs;

                            return ListView.builder(
                            
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                var transactionData = data[index].data();
                                String docId = data[index].id;

                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      214,
                                      212,
                                      206,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// TANGGAL
                                      Text(
                                        transactionData['date'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      /// STREAM ITEMS
                                      StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>
                                      >(
                                        stream: controller.streamExpenseItem(
                                          docId,
                                        ),
                                        builder: (context, itemSnapshot) {
                                          if (itemSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          if (!itemSnapshot.hasData ||
                                              itemSnapshot.data!.docs.isEmpty) {
                                            return const Text(
                                              "Belum ada transaksi",
                                            );
                                          }

                                          var rupiah = Rupiah();

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            reverse: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                itemSnapshot.data!.docs.length,
                                            itemBuilder: (context, itemIndex) {
                                              var dataItem = itemSnapshot
                                                  .data!
                                                  .docs[itemIndex]
                                                  .data();

                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    dataItem['icon'],
                                                  ),
                                                ),
                                                title: Text(
                                                  dataItem['category'],
                                                ),
                                                subtitle: Text(
                                                  dataItem['notes'] ?? "",
                                                ),
                                                trailing: Text(
                                                  "${rupiah.convertToRupiah(dataItem['amount'])}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
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
                              return const Center(
                                child: Text("history is empty"),
                              );
                            }

                            var data = snapshot.data!.docs;

                            return ListView.builder(
                              itemCount: data.length,

                              itemBuilder: (context, index) {
                                var transactionData = data[index].data();
                                String docId = data[index].id;

                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      214,
                                      212,
                                      206,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// TANGGAL
                                      Text(
                                        transactionData['date'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      /// STREAM ITEMS
                                      StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>
                                      >(
                                        stream: controller.streamIncomeItem(
                                          docId,
                                        ),
                                        builder: (context, itemSnapshot) {
                                          if (itemSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          if (!itemSnapshot.hasData ||
                                              itemSnapshot.data!.docs.isEmpty) {
                                            return const Text(
                                              "anda belum set income pada tanggal ini",
                                            );
                                          }

                                          var rupiah = Rupiah();

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            reverse: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                itemSnapshot.data!.docs.length,
                                            itemBuilder: (context, itemIndex) {
                                              var dataItem = itemSnapshot
                                                  .data!
                                                  .docs[itemIndex]
                                                  .data();

                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    dataItem['icon'],
                                                  ),
                                                ),
                                                title: Text(
                                                  dataItem['category'],
                                                ),
                                                subtitle: Text(
                                                  dataItem['notes'] ?? "",
                                                ),
                                                trailing: Text(
                                                  "${rupiah.convertToRupiah(dataItem['amount'])}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 82, 244, 54),
                                                  ),
                                                ),
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
    );
  }
}
