import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class QuickActionsRow extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionItem(
          label: 'Analytics',
          assetPath: 'assets/icons/analytics.svg',
          onTap: () => Get.toNamed(Routes.ANALYTICS),
        ),
        const SizedBox(width: 70),
        _ActionItem(
          label: 'History',
          assetPath: 'assets/icons/history.svg',
          onTap: () => Get.toNamed(Routes.HISTORY),
        ),
        const SizedBox(width: 70),
        _ActionItem(
          label: 'Coming Soon',
          assetPath: 'assets/icons/history.svg',
          onTap: () {
          // Get.toNamed(Routes.SCAN);
          print("otw");
          },
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String label;
  final String assetPath;
  final void Function()? onTap;

  const _ActionItem({
    required this.label,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            SvgPicture.asset(assetPath, width: 40, height: 40),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
