import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class input_rupiah extends StatelessWidget {
  const input_rupiah({super.key, required this.amountC});

  final TextEditingController amountC;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: amountC,
      autocorrect: false,

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
        hintText: "Current balance",
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffBC9CC6), width: 2),
        ),
      ),
    );
  }
}
