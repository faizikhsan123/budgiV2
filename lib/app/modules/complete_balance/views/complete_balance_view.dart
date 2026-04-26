import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/Input_rupiah.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/complete_balance_controller.dart';

class CompleteBalanceView extends GetView<CompleteBalanceController> {
  const CompleteBalanceView({super.key});

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
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774848306/Stroke_Putih_y8ugnb.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome_budgi'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 7, 7, 7),
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'balance_subtitle'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color.fromARGB(255, 7, 7, 7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      input_rupiah(
                        amountC: controller.balance,
                        hintText: 'Rp 0.00',
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