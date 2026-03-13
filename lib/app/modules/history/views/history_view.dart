import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "History",
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                labelText: "Search ...",
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.allTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("History Transaksi anda belum ada"),
                    );
                  }

                  List data = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var id = data[index].id;
                      var datahasil = data[index].data();

                      return Container(
                        margin: EdgeInsets.all(12),
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${datahasil['date']}"),

                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: controller.DetailAllTransactions(id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Text(
                                    "tanggal hari ini blm ada transaksi",
                                  );
                                }

                                var data = snapshot.data!.docs;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (context, itemIndex) {
                                    var itemSnapshot = data[itemIndex].data();
                                    return ListTile(
                                      title: Text(
                                        itemSnapshot['category'] ?? "",
                                      ),
                                      subtitle: Text(
                                        itemSnapshot['notes'] ?? "",
                                      ),
                                      trailing: Text(
                                        "${itemSnapshot['amount']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              itemSnapshot['type'] ==
                                                  'expense'
                                              ? Colors.red
                                              : Colors.green,
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
          ],
        ),
      ),
    );
  }
}
