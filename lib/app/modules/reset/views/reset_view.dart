import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../controllers/reset_controller.dart';

class ResetView extends GetView<ResetController> {
  const ResetView({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'forgot_password_title'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      const SizedBox(height: 90),

                      // ── LOTTIE PLACEHOLDER ────────────────────────
                      // TODO: Ganti dengan LottieBuilder.asset('assets/lottie/forgot_password.json')
                      Container(
                        width: double.infinity,
                        height: 250,
                        alignment: Alignment.center,
                        child: Lottie.asset('assets/lottie/forgot.json'),
                      ),

                      const SizedBox(height: 24),

                      // ── SUBTITLE ──────────────────────────────────
                      Text(
                        'reset_subtitle'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 245, 245, 248),
                          height: 1.55,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── EMAIL INPUT ───────────────────────────────
                      buildTextField(
                        hint: 'email_hint'.tr,
                        controller: controller.emailC,
                      ),

                      const SizedBox(height: 28),

                      buildButtonPink(
                        text: 'send_reset_link'.tr,
                        onTap: controller.sendResetEmail,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
