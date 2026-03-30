import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  void _finishOnboarding() {
    final box = GetStorage();
    box.write('onboarding_done', true);
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          image: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 100),
            child: Center(
              child: Lottie.asset(
                'assets/lottie/intro.json',
                height: 200,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),

          titleWidget: Text(
            "Record Daily Transactions",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          bodyWidget: Text(
            textAlign: TextAlign.center,
            "Manage your income and expenses easily, practically, and quickly every day.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        PageViewModel(
          image: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 100),
            child: Center(
              child: Lottie.asset(
                'assets/lottie/Analytics.json',
                height: 200,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),

          titleWidget: Text(
            "Smart Financial Analysis",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          bodyWidget: Text(
            textAlign: TextAlign.center,
            "Understand your spending habits through accurate and easy-to-read statistical reports.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        PageViewModel(
          image: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 100),
            child: Center(
              child: Lottie.asset(
                'assets/lottie/bill.json',
                height: 200,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),

          titleWidget: Text(
            "Split Bills",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          bodyWidget: Text(
            textAlign: TextAlign.center,
            "Split bills automatically with friends by simply scanning a photo of your shopping receipt.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
      onDone: _finishOnboarding, // ✅ Tombol Done di halaman terakhir
      onSkip: _finishOnboarding, // ✅ Tombol Skip
      showSkipButton: true, // Tampilkan tombol Skip
      skip: Text(
        'Skip',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      next:  Icon(Icons.arrow_forward, size: 30),
      done: Text(
        'Start',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(8, 8),
        activeSize: const Size(20, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        activeColor: Color(0xFFBC9CC6),
        color: Colors.grey.shade300,
      ),
    );
  }
}
