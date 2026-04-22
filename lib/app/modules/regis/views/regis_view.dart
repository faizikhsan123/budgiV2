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
          // ── Background gradient biru ──────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 10, 57, 111),
                  Color.fromARGB(255, 153, 196, 233),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                // ── Back button ─────────────────────────────────────────
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    label: Text(
                      'Back',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // ── White card sheet ────────────────────────────────────
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
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
                              style: GoogleFonts.poppins(
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
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Full Name
                          _buildLabel('Full Name'),
                          _buildField(
                            hint: 'John Doe',
                            controller: controller.nameC,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 16),

                          // Email
                          _buildLabel('Email'),
                          _buildField(
                            hint: 'budgi21@gmail.com',
                            controller: controller.emailC,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),

                          // Password
                          _buildLabel('Password'),
                          Obx(
                            () => _buildField(
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
                          const SizedBox(height: 16),

                          // Confirm Password
                          _buildLabel('Confirm Password'),
                          Obx(
                            () => _buildField(
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

                          // Sign Up Button
                          // SizedBox(
                          //   width: double.infinity,
                          //   height: 52,
                          //   child: ElevatedButton(
                          //     onPressed: () async {
                          //       await controller.jalankanRegis();
                          //     },

                          //     style: ElevatedButton.styleFrom(
                          //      foregroundColor: Colors.white,

                          //       elevation: 0,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(14),
                          //       ),
                          //     ),
                          //     child: Text(
                          //       'Sign up',
                          //       style: GoogleFonts.poppins(
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                                  style: GoogleFonts.poppins(
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
                                    style: GoogleFonts.poppins(
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
          ),

          // ── Loading overlay ─────────────────────────────────────────────
          Obx(() {
            if (!controller.isloading.value) return const SizedBox.shrink();
            return loading_overlay();
          }),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1D2E),
        ),
      ),
    );
  }

  Widget _buildField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1A1D2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D5AF1), width: 1.5),
        ),
      ),
    );
  }
}
