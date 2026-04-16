import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/regis_controller.dart';

class RegisView extends GetView<RegisController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 243, 242, 244),
                  Color.fromARGB(255, 243, 242, 244),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Text(
                      "Sign up",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Create your account!",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color.fromARGB(255, 45, 43, 43),
                      ),
                    ),
                    const SizedBox(height: 20),

                    buildLabel("Complete Name"),

                    buildTextField(
                      hint: "John Doe",
                      controller: controller.nameC,
                      filled: true,
                      keyboardType: TextInputType.name,
                    ),

                    buildLabel("Email Address"),
                    buildTextField(
                      hint: "Budgi21@gmail.com",
                      controller: controller.emailC,
                      filled: true,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    

              

                    buildLabel("Set Password"),
                    Obx(
                      () => buildTextField(
                        controller: controller.passC,
                        hint: "********",
                        filled: true,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.ishidepass.toggle();
                          },
                          icon: controller.ishidepass.value == true
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),

                        obscureText: controller.ishidepass.value,
                      ),
                    ),

                    buildLabel("Re-Enter Password"),

                    Obx(
                      () => buildTextField(
                        controller: controller.passReC,
                        hint: "********",
                        filled: true,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.ishidepassreentry.toggle();
                          },
                          icon: controller.ishidepassreentry.value == true
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),

                        obscureText: controller.ishidepassreentry.value,
                      ),
                    ),

                    const SizedBox(height: 30),

                    buildButtonPink(
                      text: "Register",
                      onTap: () async {
                        await controller.jalankanRegis();

                        controller.passC.clear();
                        controller.passReC.clear();
                      },
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(Routes.LOGIN),
                            child: Text(
                              "Login",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
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
          ),
          // LOADING OVERLAY
          Obx(() {
            if (!controller.isloading.value) return const SizedBox();

            return loading_overlay();
          }),
        ],
      ),
    );
  }
}
