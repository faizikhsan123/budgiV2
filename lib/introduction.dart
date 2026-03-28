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
            margin: EdgeInsets.only(top: 200),
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
            "Catat Transaksi Harian",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          bodyWidget: Text(
            textAlign: TextAlign.center,
            "Kelola pemasukan dan pengeluaran Anda dengan mudah, praktis, dan cepat setiap harinya.",
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
            margin: EdgeInsets.only(top: 200),
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
            "Analisa keuangan Cerdas",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          bodyWidget: Text(
            textAlign: TextAlign.center,
            "Pahami kebiasaan pengeluaran Anda melalui laporan statistik yang akurat dan mudah dibaca.",
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
            margin: EdgeInsets.only(top: 200),
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
            "Split Bill Scan",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          bodyWidget: Text(
            textAlign: TextAlign.center,
            "Bagi tagihan secara otomatis bersama teman hanya dengan memindadi foto struk berlanja anda.",
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
        'Lewati',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      next:  Icon(Icons.arrow_forward, size: 30),
      done: Text(
        'Mulai',
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
