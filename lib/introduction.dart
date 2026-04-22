import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _finishOnboarding() {
    GetStorage().write('onboarding_done', true);
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        _buildPage(
          lottie: 'assets/lottie/intro.json',
          title: 'Record Daily Transaction',
          body:
              'Take full control of your daily finances with accurate and effortless tracking.',
        ),
        _buildPage(
          lottie: 'assets/lottie/Analytics.json',
          title: 'Smart Financial Analysis',
          body:
              'Understand your spending habits through accurate and easy-to-read statistical reports.',
        ),
        _buildPage(
          lottie: 'assets/lottie/bill.json',
          title: 'Split Bills',
          body:
              'Split bills automatically with friends by simply scanning a photo of your shopping receipt.',
        ),
      ],
      onDone: _finishOnboarding,
      onSkip: _finishOnboarding,
      showSkipButton: true,

      // ── Skip ──
      skip: Text(
        'Skip',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: const Color(0xFF3D5AF1),
        ),
      ),

      // ── Next ──
      next: Text(
        'Next',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: const Color(0xFF3D5AF1),
        ),
      ),

      // ── Done ──
      done: Text(
        'Start',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: const Color(0xFF3D5AF1),
        ),
      ),

      // ── Dots ──
      dotsDecorator: DotsDecorator(
        size: const Size(8, 8),
        activeSize: const Size(22, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        activeColor: const Color(0xFF3D5AF1),
        color: const Color(0xFFD0D5F5),
        spacing: const EdgeInsets.symmetric(horizontal: 4),
      ),

      // ── Controls style ──
      skipOrBackFlex: 1,
      nextFlex: 1,
      controlsMargin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      controlsPadding: EdgeInsets.zero,

      baseBtnStyle: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  PageViewModel _buildPage({
    required String lottie,
    required String title,
    required String body,
  }) {
    return PageViewModel(
      decoration: const PageDecoration(
        pageColor: Colors.white,
        imagePadding: EdgeInsets.only(top: 60, bottom: 0),
        titlePadding: EdgeInsets.only(top: 32, bottom: 12),
        bodyPadding: EdgeInsets.symmetric(horizontal: 24),
        contentMargin: EdgeInsets.zero,
      ),
      image: _buildImage(lottie),
      titleWidget: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1D2E),
          height: 1.3,
        ),
      ),
      bodyWidget: Text(
        body,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[500],
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildImage(String assetPath) {
    return Lottie.asset(
      assetPath,
      height: 280,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}