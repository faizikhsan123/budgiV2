import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class contentBefore extends StatelessWidget {
  const contentBefore({
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
        Text(
          '${'add_to'.tr} ${rupiah.convertToRupiah(number)} ${'to_your'.tr} $text',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 3, 3, 3),
          ),
        ),
        const SizedBox(height: 0),
      ],
    );
  }
}