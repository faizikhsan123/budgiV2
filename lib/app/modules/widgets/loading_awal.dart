import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class loading_awal extends StatelessWidget {
  const loading_awal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Lottie.asset('assets/lottie/load.json'),
        ),
    );
  }
}
