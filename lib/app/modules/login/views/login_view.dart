import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/modules/login/controllers/login_controller.dart';
import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:budgi/app/modules/widgets/socialButton.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          /// LOGO
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774848306/Stroke_Putih_y8ugnb.png',
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// TITLE
                          Text(
                            "Sign In To Your\nAccount",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 10),
                          /// SUBTITLE
                          Text(
                            "Enter your email and password \nto sign in.",
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

                          Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.RESET);
                                  controller.emailC.clear();
                                  controller.passC.clear();
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.plusJakartaSans(
                                     fontWeight: FontWeight.w700,
                                     fontSize: 14,
                                    color: const Color.fromARGB(255, 0, 128, 248),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          const SizedBox(height: 10),

                          /// LOGIN BUTTON
                          buildButtonPink(
                            // authC: authC,
                            // controller: controller,
                            text: "Start Now",
                            onTap: () {
                              authC.loginForm(
                                controller.emailC.text,
                                controller.passC.text,
                              );
                              controller.emailC.clear();
                              controller.passC.clear();
                            },
                          ),

                          const SizedBox(height: 15),

                          /// DIVIDER
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Or",
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
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// GOOGLE
                          Socialbutton(
                            fontsize: 16,
                            image:
                                "https://res.cloudinary.com/dzfi5acyl/image/upload/v1773417040/Google_Icon_fbdggy.png",

                            // authC: authC.loginFacebook(),
                            text: "Continue With Google",
                            // icon: Icons.g_mobiledata,
                            onTap: () {
                              authC.loginWithGoogle();
                              controller.emailC.clear();
                              controller.passC.clear();
                            },
                            item: 10,
                          ),

                          const SizedBox(height: 15),

                          const SizedBox(height: 30),

                          /// REGISTER
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Doesn't have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.REGIS);
                                    controller.emailC.clear();
                                    controller.passC.clear();
                                  },
                                  child: const Text(
                                    " Sign Up",
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

        /// LOADING OVERLAY
        Obx(() {
          if (!authC.isloading.value) return const SizedBox();
          return loading_overlay();
        }),
      ],
    );
  }
}
