import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonPink extends StatelessWidget {
  const ButtonPink({
    super.key,
    required this.authC,
    required this.controller,
    required this.text,
    required this.onTap,
  });

  final AuthController authC;
  final String text;
  final LoginController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB695C0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
