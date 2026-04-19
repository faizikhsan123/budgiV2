import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/crud_controller.dart';

class CrudView extends GetView<CrudController> {
  var dataParameter = Get.arguments as Map<String, dynamic>?;

  @override
  Widget build(BuildContext context) {
    controller.nameC.text = dataParameter!['category'] ?? '';
    controller.amountC.text = dataParameter!['amount'].toString();
    controller.notesC.text = dataParameter!['notes'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("CRUD"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 🔹 CATEGORY
            TextField(
              controller: controller.nameC,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),
          
            TextField(
              controller: controller.amountC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller.notesC,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 BUTTON SAVE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.deleteData();
                },
                child: Text("Delete"),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateData(
                  
                  );
                },
                child: Text("Update"), 
              ),
            ),

            Text("${dataParameter}"),

            const SizedBox(height: 12),

            /// 🔥 DELETE BUTTON (HANYA SAAT EDIT)
          ],
        ),
      ),
    );
  }
}
