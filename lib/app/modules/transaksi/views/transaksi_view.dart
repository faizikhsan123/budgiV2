import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/transaksi_controller.dart';

class TransaksiView extends GetView<TransaksiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBC9CC6),
                  ),
                ),
              ),
              Text(
                "New Transaction",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 80),
            ],
          ),
          SizedBox(height: 40),
          Container(
            height: 50,
            width: 220,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFBC9CC6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Expense",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                Container(height: 30, width: 1, color: Colors.white),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Income",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          Container(
            width: 50,
            child: TextField(
              cursorColor: const Color.fromARGB(255, 122, 120, 120),
              autocorrect: false,
                     
              
            ),
          ),
        ],
      ),
    );
  }
}
