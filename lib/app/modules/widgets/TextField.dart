import 'package:flutter/material.dart';

Widget buildTextField({
  required String hint,
  TextEditingController? controller,
  bool obscureText = false,
  Widget? suffixIcon,
  // VoidCallback? onSuffixTap,
  TextInputType? keyboardType,
  bool? readonly,
}) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    ),
    child: TextField(
      controller: controller,
      readOnly: readonly ?? false,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(
          minHeight: 55,
          minWidth: 55,
        ),
      ),
    ),
  );
}
