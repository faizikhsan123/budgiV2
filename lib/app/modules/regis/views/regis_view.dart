import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:budgi/app/modules/widgets/noRounded.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/regis_controller.dart';

class RegisView extends GetView<RegisController> {
  const RegisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient biru ──────────────────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Color.fromARGB(255, 10, 57, 111),
                  Color.fromARGB(255, 153, 196, 233),
                ],
              ),
            ),
          ),

          // ── White card — sama strukturnya dengan LoginView ────────
          Stack(
            children: [
              // Back button di area biru
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    label: Text(
                      'Back',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // White card dari 20% ke bawah
              Positioned(
                top: Get.height * 0.12,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Center(
                          child: Text(
                            'Hello, budies!',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1D2E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            "please sign up if u don't have account",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Full Name
                        buildLabel('Full Name'),
                        buildTextField(
                          hint: 'John Doe',
                          controller: controller.nameC,
                          keyboardType: TextInputType.name,
                        ),
                

                        // Email
                        buildLabel('Email'),
                        buildTextField(
                          hint: 'budgi21@gmail.com',
                          controller: controller.emailC,
                          keyboardType: TextInputType.emailAddress,
                        ),
                     

                        // Password
                        buildLabel('Password'),
                        Obx(
                          () => buildTextField(
                            hint: '••••••••',
                            controller: controller.passC,
                            obscureText: controller.ishidepass.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.ishidepass.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                              onPressed: controller.ishidepass.toggle,
                            ),
                          ),
                        ),
                      

                        // Confirm Password
                        buildLabel('Confirm Password'),
                        Obx(
                          () => buildTextField(
                            hint: '••••••••',
                            controller: controller.passReC,
                            obscureText: controller.ishidepassreentry.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.ishidepassreentry.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                              onPressed: controller.ishidepassreentry.toggle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        noRounded(
                          text: 'Sign up',
                          onTap: () async {
                            await controller.jalankanRegis();
                          },
                        ),
                        const SizedBox(height: 20),

                        // Login link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have account? ',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.LOGIN);
                                  controller.nameC.clear();
                                  controller.emailC.clear();
                                  controller.passC.clear();
                                  controller.passReC.clear();
                                },
                                child: Text(
                                  'Sign in',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1565C0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Loading overlay ───────────────────────────────────────
          Obx(() {
            if (!controller.isloading.value) return const SizedBox.shrink();
            return loading_overlay();
          }),
        ],
      ),
    );
  }
}
