import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionItem(label: 'Analytics', assetPath: 'assets/icons/analytics.svg'),
        const SizedBox(width: 80),
        _ActionItem(label: 'History', assetPath: 'assets/icons/history.svg'),
        const SizedBox(width: 80),
        _ActionItem(label: 'Split Bill', assetPath: 'assets/icons/split_bill.svg'),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String label;
  final String assetPath;

  const _ActionItem({required this.label, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
