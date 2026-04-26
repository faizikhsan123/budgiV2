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
        ),
      ),
    );
  }
}
