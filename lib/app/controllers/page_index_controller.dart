import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/ButtonPink_transaksi.dart';
import 'package:budgi/app/modules/widgets/Input_rupiah.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final amountC = TextEditingController();
  final notesC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final categories = [
    {
      "name": "Food",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665552/Vector_k2mnaw.png",
    },
    {
      "name": "Transport",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665566/car_3_fill_tn9bzs.png",
    },
    {
      "name": "Health",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665583/healthicons_health_bvd1hp.png",
    },
    {
      "name": "Bill",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665616/bill_fill_ygxibf.png",
    },
    {
      "name": "Shopping",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665669/Group_2_lzddae.png",
    },
    {
      "name": "Transfer",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665624/Group_1_db9gng.png",
    },
    {
      "name": "Entertainment",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665624/movie_fill_lmbyru.png",
    },
    {
      "name": "Other",
      "icon":
          "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773665624/more_4_fill_dulejq.png",
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
    amountC.clear();
    notesC.clear();
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
    amountC.dispose();
    notesC.dispose();
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

                        ElevatedButton(
                          onPressed: () {
                            Get.dialog(
                              Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 400,
                                        width: 300,
                                        child: SfDateRangePicker(
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .single, //mode datepicker

                                          initialSelectedDate: null,
                                          initialSelectedRange: null,
                                          showNavigationArrow: true,
                                          selectionColor: Color(0xFFBC9CC6),

                                          showTodayButton: false,
                                          allowViewNavigation: true,
                                          showActionButtons:
                                              true, //tampilkan tombol

                                          onCancel: () =>
                                              Get.back(), //ketika tombol cancel ditekan
                                          /// ketika tombol submit ditekan
                                          onSubmit: (obj) {
                                            DateTime date = obj as DateTime;
                                            nilaiTanggal.value =
                                                "${date.day}-${date.month}-${date.year}";

                                            print(nilaiTanggal.value);
                                            Get.back();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${nilaiTanggal.value}",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 21,
                                  color: Colors.black,
                                ),
                              ],
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
                    input_rupiah(amountC: amountC, hintText: "Rp. 0"),

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
                                          child: Container(
                                            width: itemWidth,
                                            height: itemWidth,

                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xFFBC9CC6),
                                              ),
                                              color:
                                                  selectedCategoryIndex.value ==
                                                      index
                                                  ? Color.fromARGB(
                                                      255,
                                                      234,
                                                      217,
                                                      239,
                                                    )
                                                  : Color.fromARGB(
                                                      255,
                                                      255,
                                                      255,
                                                      255,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Image.network(
                                              categories[index]['icon']!,
                                            ),
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
                    TextFormField(
                      controller: notesC,
                      maxLines: 4,
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

                    const SizedBox(height: 20),

                    Obx(
                      () => transactionType.value == "expense"
                          ? buildButtonPinkTransaksi(
                              text: 'Save',
                              onTap: () {
                                tambahExpense(notesC.text);
                              },
                            )
                          : buildButtonPinkTransaksi(
                              text: 'Save',
                              onTap: () {
                                tambahTransaksiIncome(notesC.text);
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
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future tambahExpense(String notes) async {
    String cleanText = amountC.text
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .trim();

    int? number = int.tryParse(cleanText);

    if (number == null) {
      Get.snackbar(
        'Error',
        'Nominal wajib diisi',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    String uid = auth.currentUser!.uid;

    var snapshot = await firestore.collection("users").doc(uid).get();
    int balance = snapshot.data()?['balance'];

    /// VALIDASI
    if (number > balance) {
      Get.snackbar(
        'Error',
        'Saldo tidak mencukupi',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    /// CEK TRANSAKSI HARI INI
    var streamTransaction = await firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(nilaiTanggal.value)
        .get();

    var data = streamTransaction.data();
    String waktu = DateFormat.jms().format(DateTime.now());

    if (data == null || data.isEmpty) {
      await firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(nilaiTanggal.value)
          .set({'date': nilaiTanggal.value, 'created_at': waktu});
    }

    /// SIMPAN TRANSAKSI
    await firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(nilaiTanggal.value)
        .collection("items")
        .doc(waktu)
        .set({
          'type': "expense",
          "date": nilaiTanggal.value,
          "icon": categories[selectedCategoryIndex.value]['icon'],
          'amount': number,
          'notes': notes,
          'category': categories[selectedCategoryIndex.value]['name'],
          'created_at': waktu,
        });

    /// UPDATE SALDO
    await firestore.collection("users").doc(uid).update({
      'balance': balance - number,
    });

    Get.snackbar('berhasil', 'pengeluaran berhasil ditambahkan');
  }

  // Fungsinya jadi:
  void tambahTransaksiIncome(String notes) async {
    String cleanText = amountC.text
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .trim();

    int? number = int.tryParse(cleanText);

    if (number == null) {
      Get.snackbar(
        'Error',
        'Nominal wajib diisi',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    String uid = auth.currentUser!.uid;

    Future<DocumentSnapshot<Map<String, dynamic>>> streamTransaction = firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(nilaiTanggal.value)
        .get();

    var data = await streamTransaction.then((value) => value.data());

    // tambah data transaksi wakttu s3ekatang
    String waktu = DateFormat.jms().format(DateTime.now());

    //jika hari ini belum ada transaksi
    if (data == null || data.isEmpty) {
      firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(nilaiTanggal.value)
          .set({'date': nilaiTanggal.value, 'created_at': waktu});
    }

    // tambah transaksi baru (tidak menimpa)

    Future<DocumentSnapshot<Map<String, dynamic>>> dataProfile = firestore
        .collection("users")
        .doc(uid)
        .get();
    dataProfile.then((snapshot) {
      int balance = snapshot.data()?['balance'];
      firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(nilaiTanggal.value)
          .collection("items")
          .doc(waktu)
          .set({
            'type': "income",
            "icon": "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773693028/Group_3_c6c4wv.png",
            "category": "income",
            "date": nilaiTanggal.value,
            'amount': number,
            'notes': notes,
            'created_at': waktu,
          });

      firestore.collection("users").doc(uid).update({
        'balance': balance + number,
      });
    });

    Get.snackbar('berhasil', 'income berhasil ditambahkan');
  }
}
