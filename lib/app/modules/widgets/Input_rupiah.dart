import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class input_rupiah extends StatelessWidget {
  const input_rupiah({super.key, required this.amountC,required this.hintText});

  final TextEditingController amountC;
  final String hintText;

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
        hintText: hintText,
        
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 215, 204, 219), width: 2),
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
