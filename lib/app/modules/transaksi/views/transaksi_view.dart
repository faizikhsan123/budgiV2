import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/ButtonPink_transaksi.dart';
import 'package:budgi/app/modules/widgets/Input_rupiah.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/transaksi_controller.dart';

class TransaksiView extends GetView<TransaksiController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: bottom_navbar(pageC: pageC,),
  
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "New Transaction",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 SWITCH EXPENSE / INCOME
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
                              onPressed: controller.setExpense,
                              child: Text(
                                "Expense",
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      controller.transactionType.value ==
                                          "expense"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.transactionType.value == "income"
                                    ? const Color(0xFFBC9CC6)
                                    : Colors.white,
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 197, 160, 208),
                                  width: 2,
                                ),
                              ),
                              onPressed: controller.setIncome,
                              child: Text(
                                "Income",
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      controller.transactionType.value ==
                                          "income"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),

                    /// 🔹 DATE PICKER
                    InkWell(
                      onTap: () => Get.dialog(
                        Dialog(
                          child: Container(
                            height: 400,
                            padding: const EdgeInsets.all(10),
                            child: SfDateRangePicker(
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
                              showActionButtons: true,
                              selectionColor: const Color(0xFFBC9CC6),
                              onCancel: () => Get.back(),
                              onSubmit: (obj) {
                                DateTime date = obj as DateTime;
                                controller.nilaiTanggal.value =
                                    "${date.day}-${date.month}-${date.year}";
                                Get.back();
                              },
                            ),
                          ),
                        ),
                      ),
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 206, 204, 207),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFFBC9CC6),
                              ),
                              const SizedBox(width: 10),
                              const Text("Date"),
                              const Spacer(),
                              Text(
                               controller.nilaiTanggal.value,
                                
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 INPUT RUPIAH
                    Obx(
                      () => input_rupiah(
                        hintText: "Amount",

                        // hintText: "",
                        amountC: controller.transactionType.value == "expense"
                            ? controller.amount1C
                            : controller.amount2C,
                      ),
                    ),

                    Obx(
                      () => controller.transactionType.value == "expense"
                          ? const SizedBox(height: 20)
                          : const SizedBox(height: 0),
                    ),

                    /// 🔹 SELECT CATEGORY (Expense only)
                    Obx(
                      () => controller.transactionType.value == "expense"
                          ? Row(
                              children: [
                                Text(
                                  "Select Category",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),

                    SizedBox(height: 10),

                    Obx(
                      () => controller.transactionType.value == "expense"
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double itemWidth =
                                      (constraints.maxWidth - (15 * 3)) / 4;

                                  return Wrap(
                                    spacing: 15,
                                    runSpacing: 28,
                                    children: List.generate(
                                      controller.categories.length,
                                      (index) => Obx(
                                        () => InkWell(
                                          onTap: () {
                                            controller
                                                    .selectedCategoryIndex
                                                    .value =
                                                index;
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                width: itemWidth,
                                                height: itemWidth,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                  border:
                                                      controller
                                                              .selectedCategoryIndex
                                                              .value ==
                                                          index
                                                      ? Border.all(
                                                          color:
                                                              const Color.fromARGB(
                                                                255,
                                                                195,
                                                                131,
                                                                214,
                                                              ),
                                                          width: 2,
                                                        )
                                                      : Border.all(
                                                          color:
                                                              const Color.fromARGB(
                                                                255,
                                                                255,
                                                                255,
                                                                255,
                                                              ),
                                                          width: 2,
                                                        ),
                                                  color:
                                                      controller
                                                              .selectedCategoryIndex
                                                              .value ==
                                                          index
                                                      ? const Color.fromARGB(
                                                          255,
                                                          234,
                                                          217,
                                                          239,
                                                        )
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                      ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Center(
                                                          child: SvgPicture.network(
                                                            "${controller.categories[index]['icon']}",
                                                            fit: BoxFit.contain,
                                                            width:
                                                                itemWidth *
                                                                0.45,
                                                            height:
                                                                itemWidth *
                                                                0.45,
                                                          ),
                                                        ),
                                                      ),
                                                      FittedBox(
                                                        child: Text(
                                                          "${controller.categories[index]['name']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.plusJakartaSans(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
                    ),

                    Obx(
                      () => controller.transactionType.value == "expense"
                          ? const SizedBox(height: 20)
                          : const SizedBox(height: 0),
                    ),

                    /// 🔹 NOTES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notes",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                    SizedBox(height: 7),

                    Obx(
                      () => TextField(
                        controller:
                            controller.transactionType.value == "expense"
                            ? controller.notes1C
                            : controller.notes2C,
                        maxLines: 3,
                        keyboardType: TextInputType.name,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 215, 204, 219),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xffBC9CC6),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Obx(
                      () => controller.transactionType.value == "expense"
                          ? const SizedBox(height: 15)
                          : const SizedBox(height: 216),
                    ),

                    buildButtonPinkTransaksi(
                      text: "Add Transaction",
                      onTap: () {
                        controller.transactionType.value == "expense"
                            ? controller.tambahExpense(controller.notes1C.text)
                            : controller.tambahTransaksiIncome(
                                controller.notes2C.text,
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
