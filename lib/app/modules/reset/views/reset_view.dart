import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reset_controller.dart';

class ResetView extends GetView<ResetController> {
  const ResetView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [

          /// ── GRADIENT BACKGROUND ──
          const _TopGradient(),

          /// ── BACK BUTTON ──
          const _BackButton(),

          /// ── MAIN CONTENT ──
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 80),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: _cardDecoration,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// ── TITLE ──
                          Text(
                            'Forgot\nPassword?',
                            style: _titleStyle,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Enter your email to receive reset link',
                            style: _subtitleStyle,
                          ),

                          const SizedBox(height: 32),

                          /// ── EMAIL FIELD ──
                          const _Label(text: 'Email'),
                          const SizedBox(height: 8),

                          TextField(
                            controller: controller.emailC,
                            keyboardType: TextInputType.emailAddress,
                            style: _inputTextStyle,
                            decoration: _inputDecoration(
                              hint: 'Enter your email',
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// ── BUTTON ──
                          Obx(() => SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.sendResetEmail,
                                  style: _buttonStyle,
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Send Reset Link',
                                          style: _buttonTextStyle,
                                        ),
                                ),
                              )),

                          const SizedBox(height: 20),

                          /// ── BACK TO LOGIN ──
                          Center(
                            child: GestureDetector(
                              onTap: Get.back,
                              child: RichText(
                                text: TextSpan(
                                  style: _subtitleStyle,
                                  children: [
                                    const TextSpan(
                                        text: 'Remember your password? '),
                                    TextSpan(
                                      text: 'Sign in',
                                      style: _linkStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────
/// COMPONENTS (biar reusable & ringan)
/// ─────────────────────────────────────────

class _TopGradient extends StatelessWidget {
  const _TopGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B5CE6), Color(0xFF1A3FA8)],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: Get.back,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'Back',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF374151),
      ),
    );
  }
}

/// ─────────────────────────────────────────
/// STYLES (biar tidak redundant)
/// ─────────────────────────────────────────

final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(28),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ],
);

final _titleStyle = GoogleFonts.plusJakartaSans(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  color: const Color(0xFF1A1A2E),
  height: 1.2,
);

final _subtitleStyle = GoogleFonts.plusJakartaSans(
  fontSize: 13,
  color: Colors.grey,
  height: 1.5,
);

final _inputTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 14,
);

InputDecoration _inputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.plusJakartaSans(
      color: Colors.grey[400],
      fontSize: 14,
    ),
    filled: true,
    fillColor: const Color(0xFFF5F7FF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF2B5CE6),
        width: 1.5,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
  );
}

final _buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF2B5CE6),
  disabledBackgroundColor: const Color(0xFF2B5CE6).withOpacity(0.5),
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
);

final _buttonTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

final _linkStyle = GoogleFonts.plusJakartaSans(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: const Color(0xFF2B5CE6),
);