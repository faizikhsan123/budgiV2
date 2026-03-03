import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';
import '../widgets/app_colors.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/transaction_group_card.dart';

class HomeView extends GetView<HomeController> {

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
            stops: [0.0, 0.13, 0.40],
            colors: [
              Color(0xFFE2B9A3),
              Color(0xFFEAC9B3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── User Greeting Row ──────────────────────────────
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/avatar.svg',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 13),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Faiz Ihsan Fajrul Falah',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.45,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Balance Card ──────────────────────────────────
                      const BalanceCard(),
                      const SizedBox(height: 28),

                      // ── Quick Actions ─────────────────────────────────
                      const QuickActionsRow(),
                      const SizedBox(height: 24),

                      // ── Recent Activity Header ────────────────────────
                      Text(
                        'Recent Activity',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                          letterSpacing: -0.30,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Friday Group ──────────────────────────────────
                      TransactionGroupCard(
                        dateLabel: 'Friday, 27 February 2026',
                        transactions: const [
                          TransactionData(
                            iconAsset: 'assets/icons/food.svg',
                            category: 'Food',
                            description: 'Geprek Bakar Cibus',
                            amount: 'Rp15.000',
                          ),
                          TransactionData(
                            iconAsset: 'assets/icons/transport.svg',
                            category: 'Transport',
                            description: 'Bensin Pertamax Turbo',
                            amount: 'Rp50.000',
                          ),
                          TransactionData(
                            iconAsset: 'assets/icons/income.svg',
                            category: 'Income',
                            description: 'Gaji bulan Februari',
                            amount: 'Rp2.000.000',
                            isIncome: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Thursday Group ────────────────────────────────
                      TransactionGroupCard(
                        dateLabel: 'Thursday, 26 February 2026',
                        transactions: const [
                          TransactionData(
                            iconAsset: 'assets/icons/food.svg',
                            category: 'Food',
                            description: 'Dubai Chewy Cookies',
                            amount: 'Rp35.000',
                          ),
                          TransactionData(
                            iconAsset: 'assets/icons/transport2.svg',
                            category: 'Transport',
                            description: 'Bensin Pertamax Turbo',
                            amount: 'Rp50.000',
                          ),
                          TransactionData(
                            iconAsset: 'assets/icons/income2.svg',
                            category: 'Income',
                            description: 'Gaji bulan Februari',
                            amount: 'Rp2.000.000',
                            isIncome: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ── Bottom Navigation Bar ─────────────────────────────────
              _HomeBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Home + Profile items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home
                _NavItem(
                  assetPath: 'assets/icons/nav_home.svg',
                  label: 'Home',
                  isActive: true,
                ),
                // Spacer for FAB
                const SizedBox(width: 56),
                // Profile
                _NavItem(
                  assetPath: 'assets/icons/nav_profile.svg',
                  label: 'Profile',
                  isActive: false,
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
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.assetPath,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryPurple : AppColors.navGray;
    return Column(
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
    );
  }
}
