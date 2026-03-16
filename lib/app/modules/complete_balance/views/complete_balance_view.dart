import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/Input_rupiah.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/complete_balance_controller.dart';

class CompleteBalanceView extends GetView<CompleteBalanceController> {
  const CompleteBalanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 243, 241, 241),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ICON / IMAGE
                Container(
                  width: 100,
                  child: Image.network(
                    'https://res.cloudinary.com/dzfi5acyl/image/upload/v1773415779/budgi_B_D_bentuk_babi_zyclve.png',
                    fit: BoxFit.cover,
                  ),
                  decoration: BoxDecoration(
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
                      Text(
                        "Welcome to Budgi! 👋",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 7, 7, 7),
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Start by adding your current balance.You can update it anytime as you record income or expenses.",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color.fromARGB(255, 7, 7, 7),
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 20),

                      input_rupiah(
                        amountC: controller.balance,
                        hintText: "Current Balance",
                      ),

                      const SizedBox(height: 20),

                      /// BUTTON
                      buildButtonPink(
                        text: 'Start Tracking',
                        onTap: () {
                          String value = controller.balance.text
                              .replaceAll("Rp", "")
                              .replaceAll(".", "")
                              .trim();
                          controller.setBalance(int.parse(value));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
