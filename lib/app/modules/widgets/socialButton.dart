import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Socialbutton extends StatelessWidget {
  Socialbutton({
    super.key,
    required this.item,
    required this.text,
    required this.onTap,
    required this.image,
    required this.fontsize,
  });

  // final AuthController authC;
  final String text;
  // final LoginController controller;
  final VoidCallback onTap;
  final String image;
  final double fontsize;

  double item = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              image,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            SizedBox(width: item),
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: fontsize,

                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 253, 253, 253),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
