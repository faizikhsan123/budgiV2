import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class input_rupiah_transaksi extends StatelessWidget {
  const input_rupiah_transaksi({
    super.key,
    required this.amountC,
    required this.hintText,
  });

  final TextEditingController amountC;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: amountC,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyTextInputFormatter.currency(
          maxValue: 1000000000000,
          locale: 'id',
          decimalDigits: 0,
          symbol: 'Rp ',
        ),
      ],

      decoration: InputDecoration(
        fillColor: const Color.fromARGB(255, 245, 244, 244),
        filled: true,
        hintText: hintText,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Color(0xFF000000),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 119, 255),
            width: 1,
          ),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 55,
          minWidth: 55,
        ),
      ),
    );
  }
}
