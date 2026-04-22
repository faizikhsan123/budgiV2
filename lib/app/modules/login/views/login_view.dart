import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/modules/login/controllers/login_controller.dart';
import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  static const _blueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 10, 57, 111),
      Color.fromARGB(255, 153, 196, 233),
    ],
  );

  void _clearFields() {
    controller.emailC.clear();
    controller.passC.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(authC),
          _buildLoading(authC),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: _blueGradient),
            child: SafeArea(child: Align(alignment: Alignment.topLeft)),
          ),
        ),
        Expanded(flex: 5, child: Container(color: Colors.white)),
      ],
    );
  }

  Widget _buildContent(AuthController authC) {
    return SafeArea(
      child: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildEmailField(),
                    const SizedBox(height: 12),
                    _buildPasswordField(),
                    _buildForgotPassword(),
                    const SizedBox(height: 16),
                    _buildLoginButton(authC),
                    const SizedBox(height: 20),
                    _buildDivider(),
                    const SizedBox(height: 16),
                    _buildSocialLogin(authC),
                    const SizedBox(height: 20),
                    _buildSignup(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Welcome !',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Here you log in securely',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: const Color(0xFF6B6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return buildTextField(
      hint: 'Enter email',
      keyboardType: TextInputType.emailAddress,
      controller: controller.emailC,
      filled: true,
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => buildTextField(
        hint: 'Password',
        obscureText: controller.isHide.value,
        controller: controller.passC,
        filled: true,
        suffixIcon: IconButton(
          onPressed: controller.isHide.toggle,
          icon: Icon(
            controller.isHide.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.toNamed(Routes.RESET);
          _clearFields();
        },
        child: Text(
          'Forgot password?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1565C0),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthController authC) {
    return Column(
      children: [
        buildButtonPink(
          text: 'Log in',
          onTap: () {
            authC.loginForm(controller.emailC.text, controller.passC.text);
            _clearFields();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: const Color.fromARGB(255, 0, 0, 0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Sign in with',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        Expanded(child: Divider(color: const Color.fromARGB(255, 0, 0, 0))),
      ],
    );
  }

  Widget _buildSocialLogin(AuthController authC) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {}, // optional facebook login
          child: SvgPicture.network(
            'https://res.cloudinary.com/dzfi5acyl/image/upload/v1776827835/logos_facebook_vmtf1p.svg',
            width: 35,
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            authC.loginWithGoogle();
            _clearFields();
          },
          child: SvgPicture.network(
            'https://res.cloudinary.com/dzfi5acyl/image/upload/v1776827835/devicon_google_jsb43q.svg',
            width: 35,
          ),
        ),
      ],
    );
  }

  Widget _buildSignup() {
    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color.fromARGB(255, 70, 114, 223),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.REGIS);
                _clearFields();
              },
              child: Text(
                'Sign up',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading(AuthController authC) {
    return Obx(() {
      return authC.isloading.value
          ? loading_overlay()
          : const SizedBox.shrink();
    });
  }
}
