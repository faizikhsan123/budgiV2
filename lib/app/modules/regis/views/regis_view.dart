import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:budgi/app/modules/widgets/noRounded.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/regis_controller.dart';

class RegisView extends GetView<RegisController> {
  const RegisView({super.key});

  void _clearFields() {
    controller.nameC.clear();
    controller.emailC.clear();
    controller.passC.clear();
    controller.passReC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildCard(),
          _buildLoading(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            Color.fromARGB(255, 10, 57, 111),
            Color.fromARGB(255, 153, 196, 233),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Stack(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              onPressed: Get.back,
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 22,
              ),
              label: Text(
                'back'.tr,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: Get.height * 0.12,
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
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildNameField(),
                  _buildEmailField(),
                  _buildPasswordField(),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 32),
                  _buildSignUpButton(),
                  const SizedBox(height: 20),
                  _buildSignInLink(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            'hello_budies'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1D2E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'regis_subtitle'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel('full_name'.tr),
        buildTextField(
          hint: 'John Doe',
          controller: controller.nameC,
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel('email'.tr),
        buildTextField(
          hint: 'budgi21@gmail.com',
          controller: controller.emailC,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel('password'.tr),
        Obx(
          () => buildTextField(
            hint: '••••••••',
            controller: controller.passC,
            obscureText: controller.ishidepass.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.ishidepass.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
              onPressed: controller.ishidepass.toggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel('confirm_password'.tr),
        Obx(
          () => buildTextField(
            hint: '••••••••',
            controller: controller.passReC,
            obscureText: controller.ishidepassreentry.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.ishidepassreentry.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
              onPressed: controller.ishidepassreentry.toggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return noRounded(
      text: 'sign_up'.tr,
      onTap: controller.jalankanRegis,
    );
  }

  Widget _buildSignInLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'already_account'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.LOGIN);
              _clearFields();
            },
            child: Text(
              'sign_in'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1565C0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Obx(
      () => controller.isloading.value
          ? loading_overlay()
          : const SizedBox.shrink(),
    );
  }
}