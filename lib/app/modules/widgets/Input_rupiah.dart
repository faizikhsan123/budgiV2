import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class input_rupiah extends StatelessWidget {
  const input_rupiah({
    super.key,
    required this.amountC,
    required this.hintText,
  });

  final TextEditingController amountC;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.7,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: amountC,
        autocorrect: false,
        textAlign: TextAlign.center,

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CurrencyTextInputFormatter.currency(
            maxValue: 1000000000000,
            locale: 'id',
            decimalDigits: 0,
            symbol: 'Rp',
          ),
        ],
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[400],
          ),

          // filled: true,
          // fillColor: const Color.fromARGB(255, 255, 255, 255),

          // contentPadding: const EdgeInsets.symmetric(
          //   horizontal: 10,
          //   vertical: 18,
          // ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: const BorderSide(color: Color.fromARGB(255, 215, 204, 219), width: 2),
          // ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide.none,
          // ),
          // isDense: true,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: const BorderSide(  color: Color.fromARGB(255, 19, 91, 173), width: 2),
          // ),
        ),
      ),
    );
  }
}
