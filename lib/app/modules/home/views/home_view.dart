import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/quick_actions_row.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.streamProfile(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (!asyncSnapshot.hasData) {
                      return const Center(child: Text("Data Is Empty"));
                    }

                    final data = asyncSnapshot.data!;
                    final rupiah = Rupiah();
                    final String imageUrl =
                        "https://api.dicebear.com/9.x/initials/png?seed=${data['name']}";
                    final String photoUrl = (data['photo_url'] ?? '').isEmpty
                        ? imageUrl
                        : data['photo_url'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // ── Header: Avatar + Greeting + Profile Icon ──────
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['name']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1D2E),
                                    ),
                                  ),
                                  Text(
                                    'Welcome Back!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_outline_rounded,
                                size: 20,
                                color: Color(0xFF1A1D2E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ── Expense & Income Summary Cards ────────────────
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.streamTransaction(),
                          builder: (context, snap) {
                            // Hitung total expense & income dari 5 transaksi terakhir
                            // (opsional: bisa dikembangkan lebih lanjut di controller)
                            return Row(
                              children: [
                                _SummaryCard(
                                  label: 'Expenses',
                                  // Placeholder — ganti dengan nilai real dari stream
                                  amount: 'Rp. 21,000',
                                  isExpense: true,
                                ),
                                const SizedBox(width: 12),
                                _SummaryCard(
                                  label: 'Income',
                                  amount: '\$11.000',
                                  isExpense: false,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // ── Balance Card ──────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 28,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A1D2E),
                                Color(0xFF2D3561),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2D3561).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Balance',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                rupiah.convertToRupiah('${data['balance']}'),
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Category Header ───────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1D2E),
                              ),
                            ),
                            const Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── Quick Actions / Category Row ──────────────────
                        QuickActionsRow(),
                        const SizedBox(height: 24),

                        // ── Transactions Header ───────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1D2E),
                              ),
                            ),
                            const Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // ── Transaction List ──────────────────────────────
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.streamTransaction(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return SizedBox(
                                width: double.infinity,
                                height: 180,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 48,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "No Transactions Yet",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Your transactions will appear here",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final docs = snapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final doc = docs[index];

                                return StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>
                                >(
                                  stream: controller.streamTransactionItem(
                                    doc.id,
                                  ),
                                  builder: (context, itemSnap) {
                                    if (!itemSnap.hasData ||
                                        itemSnap.data!.docs.isEmpty) {
                                      return const SizedBox.shrink();
                                    }

                                    final items = itemSnap.data!.docs;

                                    return Column(
                                      children: List.generate(items.length, (i) {
                                        final item = items[i];
                                        final bool isIncome =
                                            item['category']
                                                .toString()
                                                .toLowerCase() ==
                                            'income';

                                        return GestureDetector(
                                          onTap: () => Get.toNamed(
                                            Routes.CRUD,
                                            arguments: {
                                              ...item.data(),
                                              'id': item.id,
                                            },
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                // Icon
                                                Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFF5F6FA,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: SvgPicture.network(
                                                    item['icon'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),

                                                // Label + date
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item['category'],
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                0xFF1A1D2E,
                                                              ),
                                                            ),
                                                      ),
                                                      if (item['notes'] !=
                                                              null &&
                                                          item['notes']
                                                              .toString()
                                                              .trim()
                                                              .isNotEmpty)
                                                        Text(
                                                          item['notes'],
                                                          style:
                                                              GoogleFonts.poppins(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .grey[500],
                                                              ),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      Text(
                                                        DateFormat(
                                                          'd MMMM yyyy',
                                                        ).format(
                                                          DateFormat(
                                                            "d-M-yyyy",
                                                          ).parse(doc['date']),
                                                        ),
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 11,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Amount
                                                Text(
                                                  isIncome
                                                      ? "+${rupiah.convertToRupiah('${item['amount']}')}"
                                                      : "-${rupiah.convertToRupiah('${item['amount']}')}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: isIncome
                                                        ? const Color(
                                                            0xFF2ECC71,
                                                          )
                                                        : const Color(
                                                            0xFFE74C3C,
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ── Bottom Navigation Bar ─────────────────────────────────────
            bottom_navbar(pageC: pageC),
          ],
        ),
      ),
    );
  }
}

// ── Summary Card Widget ──────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final String amount;
  final bool isExpense;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isExpense
                ? [const Color(0xFF3D5AF1), const Color(0xFF5B6EF5)]
                : [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isExpense
                      ? const Color(0xFF3D5AF1)
                      : const Color(0xFF8B5CF6))
                  .withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  amount,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}