import 'package:budgi/app/modules/widgets/ButtonPink_transaksi.dart';
import 'package:budgi/app/modules/widgets/Input_rupiah.dart';
import 'package:budgi/app/modules/widgets/cancel_transaksi.dart';
import 'package:budgi/app/modules/widgets/content_transaksi.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PageIndexController extends GetxController {
  RxInt CurrentIndex = 0.obs;
  RxString transactionType = "expense".obs;
  RxInt selectedCategoryIndex = (-1).obs;
  late DateRangePickerController dateC;
  RxString nilaiTanggal = "".obs;

  final amount1C = TextEditingController();
  final amount2C = TextEditingController();
  final notes1C = TextEditingController();
  final notes2C = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final categories = [
    {
      "name": "Food",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--fork-spoon-fill_k44lpk.svg",
    },
    {
      "name": "Transport",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--car-fill_oyvkvd.svg",
    },
    {
      "name": "Health",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974433/mingcute--shield-line_es79kq.svg",
    },
    {
      "name": "Bill",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--bill-fill_f1txbv.svg",
    },
    {
      "name": "Shopping",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--shopping-cart-2-fill_dbgrgo.svg",
    },
    {
      "name": "Transfer",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--transfer-3-fill_vywadq.svg",
    },
    {
      "name": "Entertaiment",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--movie-fill_kps26w.svg",
    },
    {
      "name": "Other",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg",
    },
  ];

  void setExpense() {
    transactionType.value = "expense";
  }

  void setIncome() {
    transactionType.value = "income";
  }

  /// RESET FORM
  void resetForm() {
    selectedCategoryIndex.value = -1;
    amount1C.clear();
    amount2C.clear();
    notes1C.clear();
    notes2C.clear();

    Future.delayed(Duration(seconds: 1), () {
      nilaiTanggal.value = DateFormat('dd-M-yyyy').format(DateTime.now());
    });
  }

  @override
  void onInit() {
    super.onInit();
    nilaiTanggal.value = DateFormat('dd-M-yyyy').format(DateTime.now());
    print(nilaiTanggal.value);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    amount1C.dispose();
    amount2C.dispose();
    notes1C.dispose();
    notes2C.dispose();
    dateC.dispose();
    super.onClose();
  }

  void changePage(int index) {
    switch (index) {
      case 0:
        CurrentIndex.value = index;
        Get.offAllNamed(Routes.HOME);
        break;

      case 1:
        CurrentIndex.value = index;

        Get.bottomSheet(
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Transaction",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),

                        InkWell(
                          onTap: () => Get.dialog(
                            Dialog(
                              child: Container(
                                height: 400,
                                padding: const EdgeInsets.all(10),
                                child: SfDateRangePicker(
                                  selectionMode: DateRangePickerSelectionMode
                                      .single, //ini bisa multipel
                                  showActionButtons: true,
                                  initialSelectedDate: null,

                                  todayHighlightColor: Colors.transparent,
                                  showNavigationArrow: true,
                                  showTodayButton: false,

                                  selectionColor: Color(0xFFBC9CC6),
                                  onCancel: () => Get.back(),
                                  onSubmit: (obj) {
                                    DateTime date = obj as DateTime;
                                    nilaiTanggal.value =
                                        "${date.day}-${date.month}-${date.year}";
                                    print(nilaiTanggal.value);
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                          ),
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFBC9CC6),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${nilaiTanggal.value}",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 21,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// SWITCH EXPENSE / INCOME
                    Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    transactionType.value == "expense"
                                    ? Color(0xFFBC9CC6)
                                    : Colors.white,
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 197, 160, 208),
                                  width: 2,
                                ),
                              ),
                              onPressed: setExpense,
                              child: Text(
                                "Expense",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: transactionType.value == "expense"
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
                                    transactionType.value == "income"
                                    ? Color(0xFFBC9CC6)
                                    : Colors.white,
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 197, 160, 208),
                                  width: 2,
                                ),
                              ),
                              onPressed: setIncome,
                              child: Text(
                                "income",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: transactionType.value == "income"
                                      ? Colors.white
                                      : const Color.fromARGB(255, 52, 51, 51),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),

                    /// AMOUNT
                    Obx(
                      () => input_rupiah(
                        amountC: transactionType.value == "expense"
                            ? amount1C
                            : amount2C,
                        hintText: "Rp. 0",
                      ),
                    ),

                    Obx(
                      () => transactionType.value == "expense"
                          ? SizedBox(height: 20)
                          : SizedBox(height: 20),
                    ),

                    Obx(
                      () => transactionType.value == "expense"
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
                                      categories.length,
                                      (index) => Obx(
                                        () => InkWell(
                                          onTap: () {
                                            selectedCategoryIndex.value = index;
                                            print(
                                              "data categories sesuai index : ${categories[index]['name']}",
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                width: itemWidth,
                                                height: itemWidth,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFBC9CC6,
                                                    ),
                                                  ),
                                                  color:
                                                      selectedCategoryIndex
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
                                                            "${categories[index]['icon']}",
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
                                                      Text(
                                                        "${categories[index]['name']}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                      () => transactionType.value == "expense"
                          ? SizedBox(height: 20)
                          : SizedBox(height: 0),
                    ),

                    /// NOTE
                    Obx(
                      () => TextField(
                        controller: transactionType.value == "expense"
                            ? notes1C
                            : notes2C,
                        maxLines: 2,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
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
                          isDense: true,
                          hintText: "Catatan",
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Obx(
                      () => transactionType.value == "expense"
                          ? buildButtonPinkTransaksi(
                              text: 'Save',
                              onTap: () {
                                tambahExpense(notes1C.text);
                              },
                            )
                          : buildButtonPinkTransaksi(
                              text: 'Save',
                              onTap: () {
                                tambahTransaksiIncome(notes2C.text);
                              },
                            ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        ).then((value) {
          /// RESET SAAT BOTTOMSHEET DITUTUP
          resetForm();
        });

        break;

      case 2:
        CurrentIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;

      default:
        CurrentIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }

  void tambahExpense(String notes1C) async {
    String cleanText = amount1C.text
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .trim();

    int? number = int.tryParse(cleanText);

    /// VALIDASI NOMINAL
    if (number == null) {
      Get.snackbar(
        'Failed',
        'Amount is required',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (number <= 0) {
      Get.snackbar(
        'Failed',
        'Amount must be greater than 0',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    /// VALIDASI KATEGORI
    if (selectedCategoryIndex.value == -1) {
      Get.snackbar(
        'Failed',
        'Category is required',
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade900,
      );
      return;
    }

    String uid = auth.currentUser!.uid;

    /// AMBIL DATA USER
    var snapshot = await firestore.collection("users").doc(uid).get();
    int balance = snapshot.data()?['balance'] ?? 0;

    /// CEK SALDO
    if (number > balance) {
      Get.snackbar(
        'Failed',
        'Not enough balance',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    var rupiah = Rupiah();

    /// DIALOG KONFIRMASI (DESIGN SAMA SEPERTI INCOME)
    Get.defaultDialog(
      title: "Add ${rupiah.convertToRupiah(number)} to expense?",
      titlePadding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      middleText: "",
      radius: 12,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),

      titleStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      cancel: cancel_transaksi(),

      confirm: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFBC9CC6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () async {
            /// CEK TRANSAKSI HARI INI
            var docTransaction = await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(nilaiTanggal.value)
                .get();

            var data = docTransaction.data();

            String waktu = DateFormat.jms().format(DateTime.now());
            DateTime filterTanggal = DateFormat(
              "d-M-yyyy",
            ).parse(nilaiTanggal.value);

            /// JIKA BELUM ADA TRANSAKSI HARI INI
            if (data == null) {
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(nilaiTanggal.value)
                  .set({
                    'date': nilaiTanggal.value,
                    'created_at': waktu,
                    'filter_tanggal': filterTanggal.toIso8601String(),
                  });
            }

            /// SIMPAN EXPENSE
            await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(nilaiTanggal.value)
                .collection("items")
                .doc(waktu)
                .set({
                  'type': "expense",
                  "icon": categories[selectedCategoryIndex.value]['icon'],
                  "category": categories[selectedCategoryIndex.value]['name'],
                  "date": nilaiTanggal.value,
                  'amount': number,
                  'notes': notes1C,
                  'created_at': waktu,
                });

            /// UPDATE BALANCE (DIKURANGI)
            await firestore.collection("users").doc(uid).update({
              'balance': balance - number,
            });
            amount1C.clear();
          
            selectedCategoryIndex.value = -1;

            Get.back();

            /// SUCCESS DIALOG (DESIGN SAMA)
            Get.defaultDialog(
              title: "Expense Added!",
              radius: 12,
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              titleStyle: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),

              content: content(
                rupiah: rupiah,
                number: number,
                text: "Balance has been deducted",
              ),
            );
          },

          child: Text(
            "Add",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Fungsinya jadi:
  void tambahTransaksiIncome(String notes2C) async {
    String cleanText = amount2C.text
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .trim();

    int? number = int.tryParse(cleanText);

    if (number == null) {
      Get.snackbar(
        'Failed',
        'Amount is required',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (number < 0) {
      Get.snackbar(
        'Failed',
        'Amount must be greater than 0',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }
    var rupiah = Rupiah();

    // dialog konfirmasi
    Get.defaultDialog(
      title: "Add ${rupiah.convertToRupiah(number)} to income?",
      titlePadding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      middleText: "",
      radius: 12,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),

      titleStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      cancel: cancel_transaksi(),

      confirm: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xFFBC9CC6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () async {
            String uid = auth.currentUser!.uid;

            var docTransaction = await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(nilaiTanggal.value)
                .get();

            var data = docTransaction.data();

            // waktu sekarang
            String waktu = DateFormat.jms().format(DateTime.now());
            DateTime filterTanggal = DateFormat(
              "d-M-yyyy",
            ).parse(nilaiTanggal.value);
            // jika hari ini belum ada transaksi
            if (data == null) {
              await firestore
                  .collection("users")
                  .doc(uid)
                  .collection("transactions")
                  .doc(nilaiTanggal.value)
                  .set({
                    'date': nilaiTanggal.value,
                    'created_at': waktu,
                    'filter_tanggal': filterTanggal.toIso8601String(),
                  });
            }

            // ambil profile user
            var snapshot = await firestore.collection("users").doc(uid).get();

            int balance = snapshot.data()?['balance'] ?? 0;

            // tambah item transaksi
            await firestore
                .collection("users")
                .doc(uid)
                .collection("transactions")
                .doc(nilaiTanggal.value)
                .collection("items")
                .doc(waktu)
                .set({
                  'type': "income",
                  "icon":
                      "https://res.cloudinary.com/dzfi5acyl/image/upload/v1774979395/mingcute--cash-line_nsv7vc.svg",
                  "category": "income",
                  "date": nilaiTanggal.value,
                  'amount': number,
                  'notes': notes2C,
                  'created_at': waktu,
                });

            // update balance
            await firestore.collection("users").doc(uid).update({
              'balance': balance + number,
            });
            amount2C.clear();
           
            Get.back(); //tutup dialog konfirmasi
            Get.defaultDialog(
              title: "Income Added!",
              radius: 12,
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              titleStyle: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              middleTextStyle: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 51, 51, 51),
              ),

              content: content(
                rupiah: rupiah,
                number: number,
                text: "Balance has been added",
              ),
            );

            // fungsi tambah transaksi disini
          },
          child: Text(
            "Add",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
