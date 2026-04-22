import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_CategoryData> categories = [
      _CategoryData(
        label: 'Analytics',
        assetPath: 'assets/icons/analytics.svg',
        color: const Color(0xFFFF6B35),
        onTap: () => Get.toNamed(Routes.ANALYTICS),
      ),
      _CategoryData(
        label: 'History',
        assetPath: 'assets/icons/history.svg',
        color: const Color(0xFF4CAF50),
        onTap: () => Get.toNamed(Routes.HISTORY),
      ),
      _CategoryData(
        label: 'Coming Soon',
        assetPath: 'assets/icons/scan.svg',
        color: const Color(0xFF2196F3),
        onTap: () {},
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories
          .map((cat) => _CategoryItem(data: cat))
          .toList(),
    );
  }
}

class _CategoryData {
  final String label;
  final String assetPath;
  final Color color;
  final VoidCallback onTap;

  const _CategoryData({
    required this.label,
    required this.assetPath,
    required this.color,
    required this.onTap,
  });
}

class _CategoryItem extends StatelessWidget {
  final _CategoryData data;

  const _CategoryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: data.color.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(
              data.assetPath,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1D2E),
            ),
          ),
        ],
      ),
    );
  }
}