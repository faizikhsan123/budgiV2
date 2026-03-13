import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/modules/login/controllers/login_controller.dart';
import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/socialButton.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  RxBool isHide = true.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFECE6F2), Color.fromARGB(255, 255, 255, 255)],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),

                            /// LOGO
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: Image.network(
                                'https://res.cloudinary.com/dzfi5acyl/image/upload/v1773415779/budgi_B_D_bentuk_babi_zyclve.png',
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// TITLE
                            Text(
                              "Masuk ke Akun\nAnda",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff1A1C1E),
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// SUBTITLE
                            Text(
                              "Masukkan email dan kata sandi\nAnda untuk masuk.",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff1A1C1E),
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// EMAIL
                            buildTextField(
                              hint: 'budgi@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                              controller: controller.emailC,
                              filled: true,
                            ),

                            const SizedBox(height: 15),

                            /// PASSWORD
                            Obx(
                              () => buildTextField(
                                hint: '*******',
                                keyboardType: TextInputType.text,
                                obscureText: controller.isHide.value,
                                controller: controller.passC,
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.isHide.value =
                                        !controller.isHide.value;
                                  },
                                  icon: Icon(
                                    controller.isHide.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            const SizedBox(height: 10),

                            /// LOGIN BUTTON
                            ButtonPink(
                              authC: authC,
                              controller: controller,
                              text: "Masuk",
                              onTap: () {
                                authC.loginFOrm(
                                  controller.emailC.text,
                                  controller.passC.text,
                                );
                                controller.emailC.clear();
                                controller.passC.clear();
                              },
                            ),

                            const SizedBox(height: 20),

                            /// DIVIDER
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.grey[300]),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Atau",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color.fromARGB(
                                        255,
                                        103,
                                        96,
                                        96,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey[300]),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            /// GOOGLE
                            Socialbutton(
                              fontsize: 16,
                              image:
                                  "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773417040/Google_Icon_fbdggy.png",
                              // authC: authC.loginFacebook(),
                              text: "Masuk dengan Google",
                              // icon: Icons.g_mobiledata,
                              onTap: () {
                                authC.loginWithGoogle();
                              },
                              item: 15,
                            ),

                            const SizedBox(height: 15),

                            /// FACEBOOK
                            Socialbutton(
                              fontsize: 14,
                              item: 20,
                              image:
                                  "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773417026/logos_facebook_ti0ibh.png",
                              text: "Masuk dengan Facebook",
                              // icon: Icons.facebook,
                              onTap: () {
                                authC.loginFacebook();
                              },
                            ),

                            const SizedBox(height: 90),

                            /// REGISTER
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Belum punya akun? "),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.REGIS);
                                    },
                                    child: const Text(
                                      "Daftar",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        /// LOADING OVERLAY
        Obx(() {
          if (!authC.isloading.value) return const SizedBox();

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
        }),
      ],
    );
  }
}
