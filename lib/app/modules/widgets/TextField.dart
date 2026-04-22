import 'package:flutter/material.dart';

Widget buildTextField({
  required String hint,
  TextEditingController? controller,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  bool? readonly,
  bool? filled,
  Function(String)? onchange,
}) {
  return TextField(
    controller: controller,
    readOnly: readonly ?? false,
    autocorrect: false,
    obscureText: obscureText,
    keyboardType: keyboardType,
    onChanged: onchange,

    decoration: InputDecoration(
      fillColor: const Color.fromARGB(255, 245, 244, 244),
      filled: filled ?? false,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 215, 204, 219),
          width: 2,
        ),
      ),

      hintText: hint,
      hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 19, 91, 173),
          width: 1,
        ),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      suffixIconConstraints: const BoxConstraints(minHeight: 55, minWidth: 55),
    ),
  );
}
