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
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow:  [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: TextField(
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        hintText: hint,
        hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200),

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
    ),
  );
}
