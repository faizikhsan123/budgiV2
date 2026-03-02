import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'transaction_item.dart';

class TransactionData {
  final String iconAsset;
  final String category;
  final String description;
  final String amount;
  final bool isIncome;

  const TransactionData({
    required this.iconAsset,
    required this.category,
    required this.description,
    required this.amount,
    this.isIncome = false,
  });
}

class TransactionGroupCard extends StatelessWidget {
  final String dateLabel;
  final List<TransactionData> transactions;

  const TransactionGroupCard({
    super.key,
    required this.dateLabel,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dividerLavender.withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateLabel,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.textDark,
              letterSpacing: -0.30,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(transactions.length, (index) {
            final tx = transactions[index];
            return Column(
              children: [
                TransactionItem(
                  iconAsset: tx.iconAsset,
                  category: tx.category,
                  description: tx.description,
                  amount: tx.amount,
                  isIncome: tx.isIncome,
                ),
                if (index < transactions.length - 1) ...[
                  const SizedBox(height: 10),
                  Divider(
                    color: AppColors.dividerLavender,
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}
