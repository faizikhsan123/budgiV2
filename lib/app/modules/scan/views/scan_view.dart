import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Struk")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// IMAGE PREVIEW
            Obx(() {
              if (controller.imageFile.value == null) {
                return Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: Center(child: Text("Belum ada gambar")),
                );
              }

              return Image.file(
                controller.imageFile.value!,
                height: 200,
                fit: BoxFit.cover,
              );
            }),

            SizedBox(height: 20),

            /// BUTTON SCAN
            ElevatedButton(
              onPressed: () {
                controller.scanFromCamera();
              },
              child: Text("Scan Struk"),
            ),

            SizedBox(height: 20),

            /// LOADING
            Obx(
              () => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : SizedBox(),
            ),

            SizedBox(height: 20),

            /// RESULT TEXT
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  child: Text(controller.resultText.value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
