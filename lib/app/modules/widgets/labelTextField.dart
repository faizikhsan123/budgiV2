import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 15),
    child: Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        color: const Color.fromARGB(255, 45, 43, 43),
      ),
    ),
  );
}
