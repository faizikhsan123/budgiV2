import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class cancel_transaksi extends StatelessWidget {
  const cancel_transaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8,),
        Container(
          width: 110,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromARGB(255, 201, 191, 204)),
          ),
          child: TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}