import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/Input_rupiah_transaksi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/complete_balance_controller.dart';

class CompleteBalanceView extends GetView<CompleteBalanceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 153, 196, 233),
              Color.fromARGB(255, 60, 96, 138),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   width: 100,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Image.network(
                //     'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774848306/Stroke_Putih_y8ugnb.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),
                // const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'welcome_budgi'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 24,
                        ),
                      ),
                      Center(
                        child: Text(
                          'welcome_2'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'balance_subtitle'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      input_rupiah_transaksi(
                        amountC: controller.balance,
                        hintText: 'Rp ',
                      ),

                      const SizedBox(height: 20),
                      buildButtonPink(
                        text: 'start_tracking'.tr,
                        onTap: () {
                          final value = controller.balance.text
                              .replaceAll('Rp', '')
                              .replaceAll('.', '')
                              .trim();

                          if (value.isEmpty) {
                            Get.snackbar(
                              'failed'.tr,
                              'balance_required'.tr,
                              backgroundColor: Colors.red.shade50,
                              colorText: Colors.red.shade900,
                            );
                            return;
                          }
                          controller.setBalance(int.tryParse(value) ?? 0);
                        },
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'balance_subtitle_2'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                          
                        ),
                        textAlign: TextAlign.center,
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
