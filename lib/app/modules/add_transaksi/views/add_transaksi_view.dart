import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_transaksi_controller.dart';

class AddTransaksiView extends GetView<AddTransaksiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddTransaksiView'), centerTitle: true),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('AddTransaksaksi', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: () {}, child: Text("Expense/Income")),
                        ElevatedButton(onPressed: () {}, child: Text("select Date")),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: Get.width,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              Container(
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        height: 30,
                        child: Center(
                          child: Text(
                            "Keterangan",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 150,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 95, 87, 62),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(onPressed: () {}, child: Text("Add More")),
                          ElevatedButton(onPressed: () {}, child: Text("Finish")),
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
