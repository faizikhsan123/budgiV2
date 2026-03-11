import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/complete_balance_controller.dart';

class CompleteBalanceView extends GetView<CompleteBalanceController> {
  const CompleteBalanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffEDEDED), Color(0xffEED6C6)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ICON / IMAGE
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 24),

                /// TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome to Budgis! 👋",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      const Text(
                        "Start by adding your current balance.\nYou can update it anytime as you record income or expenses.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// TEXTFIELD
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: controller.balance,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyTextInputFormatter.currency(
                            maxValue: 1000000000,
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

                      const SizedBox(height: 20),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            String value = controller.balance.text
                                .replaceAll("Rp", "")
                                .replaceAll(".", "")
                                .trim();

                            controller.setBalance(int.parse(value));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffB89BC6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Start Tracking",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// DESCRIPTION
              ],
            ),
          ),
        ),
      ),
    );
  }
}
