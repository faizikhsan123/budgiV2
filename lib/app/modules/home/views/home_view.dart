import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/quick_actions_row.dart';
import '../../widgets/transaction_group_card.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
  final pageC = Get.find<PageIndexController>();
  final FirebaseAuth auth = FirebaseAuth.instance;
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
            colors: [Color(0xFFE2B9A3), Color(0xFFEAC9B3), Colors.white],
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
              ConvexAppBar(
                //widget bottom navbar
               
                backgroundColor: const Color.fromARGB(255, 189, 157, 195),
                initialActiveIndex: pageC.CurrentIndex.value, //index active
                items: [
                  TabItem(icon: Icons.home, title: 'Home'),
                  TabItem(icon: Icons.add, title: 'Add'),
                  TabItem(icon: Icons.person, title: 'Pofile'),
                ],
                onTap: (index) {
                  pageC.changePage(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
