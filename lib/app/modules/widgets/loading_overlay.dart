import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class loading_overlay extends StatelessWidget {
  const loading_overlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Lottie.asset('assets/lottie/load.json'),
        ),
      ),
    );
  }
}
