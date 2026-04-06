import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 130, //mengatur lebar widget sebesar 80% dari lebar layar
              child: Image.network(
                'https://res.cloudinary.com/dzfi5acyl/image/upload/q_auto/f_auto/v1774848306/Stroke_Putih_y8ugnb.png',
                filterQuality: FilterQuality.high,
              ),
            ),
            Text(
              'Budgi',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 146, 105, 158),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
