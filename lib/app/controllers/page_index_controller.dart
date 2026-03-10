import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt CurrentIndex = 0.obs;
  RxString transactionType = "expense".obs;
  RxInt selectedCategoryIndex = (-1).obs;

  final amountC = TextEditingController();
  final notesC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final categories = [
    {
      "name": "Food",
      "icon": "https://cdn-icons-png.flaticon.com/512/1046/1046784.png",
    },
    {
      "name": "Transport",
      "icon": "https://cdn-icons-png.flaticon.com/512/744/744465.png",
    },
    {
      "name": "Health",
      "icon": "https://cdn-icons-png.flaticon.com/512/2966/2966480.png",
    },
    {
      "name": "Bill",
      "icon": "https://cdn-icons-png.flaticon.com/512/2920/2920269.png",
    },
    {
      "name": "Shopping",
      "icon": "https://cdn-icons-png.flaticon.com/512/3514/3514491.png",
    },
    {
      "name": "Education",
      "icon": "https://cdn-icons-png.flaticon.com/512/3135/3135755.png",
    },
    {
      "name": "Entertainment",
      "icon": "https://cdn-icons-png.flaticon.com/512/3659/3659898.png",
    },
    {
      "name": "Other",
      "icon": "https://cdn-icons-png.flaticon.com/512/565/565547.png",
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
                        const Text(
                          "Add Transaction",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Pilih Tanggal"),
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
                                    ? const Color(0xFFA348B4)
                                    : Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFFA47ADF),
                                  width: 2,
                                ),
                              ),
                              onPressed: setExpense,
                              child: Text(
                                "Expense",
                                style: TextStyle(
                                  color: transactionType.value == "expense"
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
                                    transactionType.value == "income"
                                    ? const Color(0xFFA348B4)
                                    : Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFFA47ADF),
                                  width: 2,
                                ),
                              ),
                              onPressed: setIncome,
                              child: Text(
                                "Income",
                                style: TextStyle(
                                  color: transactionType.value == "income"
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

                    /// AMOUNT
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: amountC,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter.currency(
                          maxValue: 1000000000000,
                          locale: 'id',
                          decimalDigits: 0,
                          symbol: 'Rp',
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: "Current balance",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffB89BC6),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffB89BC6),
                          ),
                        ),
                      ),
                    ),

                    Obx(
                      () => transactionType.value == "expense"
                          ? const SizedBox(height: 40)
                          : const SizedBox(height: 20),
                    ),

                    /// CATEGORY (ONLY EXPENSE)
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
                                    runSpacing: 30,
                                    children: List.generate(
                                      categories.length,
                                      (index) => Obx(
                                        () => InkWell(
                                          onTap: () {
                                            selectedCategoryIndex.value = index;
                                          },
                                          child: Container(
                                            width: itemWidth,
                                            height: itemWidth,
                                            decoration: BoxDecoration(
                                              color:
                                                  selectedCategoryIndex.value ==
                                                      index
                                                  ? const Color(0xFFA348B4)
                                                  : Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Image.network(
                                                categories[index]['icon']!,
                                              ),
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

                    /// NOTE
                    TextFormField(
                      controller: notesC,
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        hintText: "Catatan",
                      ),
                    ),

                    const SizedBox(height: 20),

                    Obx(
                      () => transactionType.value == "expense"
                          ? ElevatedButton(
                              onPressed: () {
                                // tambahTransaksi();
                              },
                              child: const Text("Tambah transaksi"),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                tambahTransaksiIncome(notesC.text);
                              },
                              child: const Text("Tambah transaksi"),
                            ),
                    ),
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

    if (number.toString().isEmpty) {
      Get.snackbar(
        'Error',
        'Nominal wajib diisi',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> streamTransaction = firestore
        .collection("users")
        .doc(uid)
        .collection("transactions");

    DateTime now = DateTime.now();

    String todaydocId = DateFormat.yMd().format(now).replaceAll('/', '-');

    DocumentReference todayDoc = streamTransaction.doc(todaydocId);

    // buat document tanggal kalau belum ada
    await todayDoc.set({
      'date': todaydocId,
      'created_at': Timestamp.now(),
    }, SetOptions(merge: true));

    String waktu = DateFormat.jms().format(now);

    // tambah transaksi baru (tidak menimpa)
    await todayDoc.collection("items").doc(waktu).set({
      'type': "income",
      'amount': number,
      'notes': notes,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });

    Get.snackbar('Berhasil', 'Data berhasil ditambahkan');
  }
}
