import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class TransactionItem extends StatelessWidget {
  final String iconAsset;
  final String category;
  final String description;
  final String amount;
  final bool isIncome;

  const TransactionItem({
    super.key,
    required this.iconAsset,
    required this.category,
    required this.description,
    required this.amount,
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(iconAsset, width: 32, height: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    letterSpacing: -0.30,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                    letterSpacing: -0.30,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          amount,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isIncome ? AppColors.incomeGreen : AppColors.expenseRed,
            letterSpacing: -0.30,
          ),
        ),
      ],
    );
  }
}
