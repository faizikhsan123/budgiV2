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

  void _clearFields() {
    controller.emailC.clear();
    controller.passC.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    return Scaffold(
      body: Stack(children: [_buildContent(authC), _buildLoading(authC)]),
    );
  }

  Widget _buildContent(AuthController authC) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 10, 57, 111),
                Color.fromARGB(255, 153, 196, 233),
              ],
            ),
          ),
        ),
        Positioned(
          top: Get.height * 0.2,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'welcome'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'login_subtitle'.tr,
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
      hint: 'enter_email'.tr,
      keyboardType: TextInputType.emailAddress,
      controller: controller.emailC,
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => buildTextField(
        hint: 'password'.tr,
        obscureText: controller.isHide.value,
        controller: controller.passC,
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
          'forgot_password'.tr,
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
    return buildButtonPink(
      text: 'log_in'.tr,
      onTap: () {
        authC.loginForm(controller.emailC.text, controller.passC.text);
        _clearFields();
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'sign_in_with'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSocialLogin(AuthController authC) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: SvgPicture.network(
            'https://res.cloudinary.com/dzfi5acyl/image/upload/v1776827835/logos_facebook_vmtf1p.svg',
            width: 35,
            placeholderBuilder: (_) => const SizedBox(width: 35, height: 35),
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
            placeholderBuilder: (_) => const SizedBox(width: 35, height: 35),
          ),
        ),
      ],
    );
  }

  Widget _buildSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'no_account'.tr,
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
            'sign_up'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1565C0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(AuthController authC) {
    return Obx(
      () => authC.isloading.value ? loading_overlay() : const SizedBox.shrink(),
    );
  }
}