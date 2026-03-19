import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      fillColor: const Color.fromARGB(255, 255, 255, 255),
      filled: filled ?? false,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),

      hintText: hint,
      hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffBC9CC6), width: 2),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      suffixIconConstraints: const BoxConstraints(minHeight: 55, minWidth: 55),
    ),
  );
}
