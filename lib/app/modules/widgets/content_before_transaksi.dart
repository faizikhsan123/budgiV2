import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:google_fonts/google_fonts.dart';


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
          "Add ${rupiah.convertToRupiah(number)} to your $text ",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 3, 3, 3),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
