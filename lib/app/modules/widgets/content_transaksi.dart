import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class content extends StatelessWidget {
  const content({
    super.key,
    required this.rupiah,
    required this.number,
    required this.text,
  });

  final Rupiah rupiah;
  final int? number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset('assets/lottie/Complete.json', height: 100),

        const SizedBox(height: 10),

        Text(
          "All set!",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        Text(
          " ${rupiah.convertToRupiah(number)} $text",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            
            fontWeight: FontWeight.w400,
            color: const Color.fromRGBO(52, 52, 52, 1),             
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: 150,
          height: 45,
          child: OutlinedButton(
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFBC9CC6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Return Home",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
