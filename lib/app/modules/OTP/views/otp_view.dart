// import 'package:budgi/app/controllers/auth_controller.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import '../controllers/otp_controller.dart';

// class OtpView extends GetView<OtpController> {
//   final otpC = TextEditingController();
//   final authC = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('OtpView'), centerTitle: true),
//       body: Center(
//         child: Column(
//           children: [
//             TextField(
//               keyboardType: TextInputType.number,
//               maxLength: 6,
//               controller: otpC,
//               decoration: InputDecoration(
//                 hintText: "Enter OTP",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             ElevatedButton(
//               onPressed: () {
//                 authC.sendForgotPasswordOtp(otpC.text);
//                 },
//               child: Text("Verify"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
