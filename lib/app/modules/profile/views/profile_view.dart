import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
              const SizedBox(height: 24),

              // ── Main Content: avatar overlaps white card ─────────────────
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // White card (starts 40px from Stack top so avatar overlaps)
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
                                padding:
                                    const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Edit Profile button aligned right
                                    SizedBox(
                                      height: 48,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () => Get.toNamed(
                                              Routes.EDIT_PROFILE),
                                          child: const _EditProfileButton(),
                                        ),
                                      ),
                                    ),

                                    // Full name
                                    Text(
                                      'Faiz  Ihsan Fajrul Falah',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                        letterSpacing: -0.45,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Email
                                    Text(
                                      'faizjrul@gmail.com',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textDark,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 24),

                                    // ── Form Fields ──────────────────────
                                    const _ProfileFormField(
                                      label: 'Full Name',
                                      value: 'Faiz Ihsan Fajrul Falah',
                                    ),
                                    const SizedBox(height: 16),
                                    const _ProfileFormField(
                                      label: 'Email',
                                      value: 'faizjrul@gmail.com',
                                    ),
                                    const SizedBox(height: 16),
                                    const _DateFormField(
                                      label: 'Birth of date',
                                      value: '24/07/2005',
                                    ),
                                    const SizedBox(height: 16),
                                    const _PhoneFormField(
                                      label: 'Phone Number',
                                      value: '+62 821-726-0592',
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Fixed bottom nav
                            const _ProfileBottomNavBar(),
                          ],
                        ),
                      ),
                    ),

                    // Avatar overlapping gradient + card
                    Positioned(
                      top: 0,
                      left: 24,
                      child: SvgPicture.asset(
                        'assets/icons/profile_avatar.svg',
                        width: 80,
                        height: 80,
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

// ── Edit Profile Pill Button ───────────────────────────────────────────────────

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAF7),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        'Edit Profile',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.deepPurple,
        ),
      ),
    );
  }
}

// ── Generic Text Form Field ────────────────────────────────────────────────────

class _ProfileFormField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileFormField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 2),
        _InputContainer(
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
      ],
    );
  }
}

// ── Date of Birth Field ────────────────────────────────────────────────────────

class _DateFormField extends StatelessWidget {
  final String label;
  final String value;

  const _DateFormField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 2),
        _InputContainer(
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

class _PhoneFormField extends StatelessWidget {
  final String label;
  final String value;

  const _PhoneFormField({required this.label, required this.value});

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
              // Country flag + chevron section (62px wide)
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

// ── Shared Input Container ─────────────────────────────────────────────────────

class _InputContainer extends StatelessWidget {
  final Widget child;

  const _InputContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

// ── Shared Field Label ─────────────────────────────────────────────────────────

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

// ── Bottom Navigation Bar ──────────────────────────────────────────────────────

class _ProfileBottomNavBar extends StatelessWidget {
  const _ProfileBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Home + Profile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavItem(
                      assetPath: 'assets/icons/nav_home.svg',
                      label: 'Home',
                      isActive: false,
                      onTap: () => Get.offAllNamed('/home'),
                    ),
                    const SizedBox(width: 56),
                    _NavItem(
                      assetPath: 'assets/icons/nav_profile.svg',
                      label: 'Profile',
                      isActive: true,
                    ),
                  ],
                ),
              ),
              // Center FAB
              Positioned(
                top: -20,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPurple,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.40),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child:
                        const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Nav Item ──────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.assetPath,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryPurple : AppColors.navGray;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
