import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/app_colors.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0535, 0.3931],
            colors: [AppColors.peachTop, Colors.white],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back Arrow ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(
                    'assets/icons/back_arrow.svg',
                    width: 20,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textDark,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Main Content: centered avatar overlaps white card ─────────
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // White card (offset 40px so avatar overlaps from above)
                    Positioned(
                      top: 40,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFBC9CC6),
                              blurRadius: 4,
                              offset: Offset(2, -1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Scrollable form content
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(
                                    24, 86, 24, 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ── Form Fields ──────────────────────
                                    _EditFormField(
                                      label: 'Full Name',
                                      initialValue: 'Faiz Ihsan Fajrul Falah',
                                    ),
                                    const SizedBox(height: 16),
                                    _EditFormField(
                                      label: 'Email',
                                      initialValue: 'faizjrul@gmail.com',
                                    ),
                                    const SizedBox(height: 16),
                                    const _DateEditField(
                                      label: 'Birth of date',
                                      value: '24/07/2005',
                                    ),
                                    const SizedBox(height: 16),
                                    const _PhoneEditField(
                                      label: 'Phone Number',
                                      value: '+62 821-726-0592',
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ── Save Button ───────────────────────────────
                            const _SaveButton(),
                          ],
                        ),
                      ),
                    ),

                    // ── Avatar with camera badge (centered) ───────────────
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 88,
                          height: 88,
                          child: Stack(
                            children: [
                              // Main avatar
                              SvgPicture.asset(
                                'assets/icons/profile_avatar.svg',
                                width: 80,
                                height: 80,
                              ),
                              // Camera badge at bottom-right
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: SvgPicture.asset(
                                  'assets/icons/camera_badge.svg',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Editable Text Form Field ───────────────────────────────────────────────────

class _EditFormField extends StatefulWidget {
  final String label;
  final String initialValue;

  const _EditFormField({required this.label, required this.initialValue});

  @override
  State<_EditFormField> createState() => _EditFormFieldState();
}

class _EditFormFieldState extends State<_EditFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(widget.label),
        const SizedBox(height: 2),
        TextField(
          controller: _controller,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.primaryPurple,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Date of Birth Field (read-only with calendar icon) ────────────────────────

class _DateEditField extends StatelessWidget {
  final String label;
  final String value;

  const _DateEditField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.inputBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3DE4E5E7),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              SvgPicture.asset(
                'assets/icons/calendar.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFACB5BB),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Phone Number Field ─────────────────────────────────────────────────────────

class _PhoneEditField extends StatelessWidget {
  final String label;
  final String value;

  const _PhoneEditField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.inputBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3DE4E5E7),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Country flag section (62px wide)
              Container(
                width: 62,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.inputBorder),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/country_flag.svg',
                    width: 46,
                    height: 28,
                  ),
                ),
              ),
              // Phone number text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    value,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Field Label ────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.labelGray,
        letterSpacing: -0.24,
      ),
    );
  }
}

// ── Save Button ────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(36, 16, 36, 24),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Save',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
