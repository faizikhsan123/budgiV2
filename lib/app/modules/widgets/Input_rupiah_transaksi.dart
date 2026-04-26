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
      autocorrect: false,
      textAlign: TextAlign.right,

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
        hintText: hintText,
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
