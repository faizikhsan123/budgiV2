import 'package:budgi/app/bahasa/category_helper.dart';
import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:budgi/app/modules/widgets/loading_awal.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import '../../widgets/quick_actions_row.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
  final pageC = Get.find<PageIndexController>();
  final box = GetStorage();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final rupiah = Rupiah();
    final hour = DateTime.now().hour;
    final String greeting = hour < 12
        ? 'good_morning'.tr
        : hour < 15
        ? 'good_afternoon'.tr
        : hour < 18
        ? 'good_evening'.tr
        : 'good_night'.tr;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── HEADER ────────────────────────────
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamProfile(),
                      builder: (context, profileSnap) {
                        if (!profileSnap.hasData) {
                          return const SizedBox(
                            height: 60,
                            child: Center(child: loading_awal()),
                          );
                        }
                        final data = profileSnap.data!;
                        final String photoUrl =
                            (data['photo_url'] ?? '').isEmpty
                            ? 'https://api.dicebear.com/9.x/initials/png?seed=${data['name']}'
                            : data['photo_url'] as String;
                        return _buildHeader(data, photoUrl, greeting);
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── SUMMARY CARDS ─────────────────────
                    _buildSummaryCards(rupiah),

                    const SizedBox(height: 16),

                    // ── BALANCE CARD ──────────────────────
                    // Pisah dari StreamBuilder profile supaya
                    // Obx tidak bentrok dengan stream rebuild
                    _buildBalanceCard(rupiah),

                    const SizedBox(height: 24),

                    QuickActionsRow(),

                    const SizedBox(height: 24),

                    Text(
                      'recent_activity'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1D2E),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── TRANSACTION LIST ──────────────────
                    _buildTransactionList(rupiah),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            bottom_navbar(pageC: pageC),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    DocumentSnapshot<Map<String, dynamic>> data,
    String photoUrl,
    String greeting,
  ) {
    return Row(
      children: [
        CircleAvatar(radius: 24, backgroundImage: NetworkImage(photoUrl)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data['name']}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1D2E),
                ),
              ),
              Text(
                greeting,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.PROFILE);
            pageC.changePage(2);
          },
          child: Container(
            width: 44,
            height: 44,
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
              size: 22,
              color: Color(0xFF09197A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(Rupiah rupiah) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.streamAllItems(),
      builder: (context, allSnap) {
        double totalExpense = 0;
        double totalIncome = 0;

        if (allSnap.hasData) {
          for (final doc in allSnap.data!.docs) {
            final d = doc.data();
            final type = (d['type'] ?? '').toString().toLowerCase();
            final amount = (d['amount'] as num?)?.toDouble() ?? 0;
            if (type == 'income') {
              totalIncome += amount;
            } else {
              totalExpense += amount;
            }
          }
        }

        return Row(
          children: [
            _SummaryCard(
              label: 'expenses'.tr,
              amount: rupiah.convertToRupiah('${totalExpense.toInt()}'),
              isExpense: true,
            ),
            const SizedBox(width: 12),
            _SummaryCard(
              label: 'income'.tr,
              amount: rupiah.convertToRupiah('${totalIncome.toInt()}'),
              isExpense: false,
            ),
          ],
        );
      },
    );
  }

  // ── Balance Card — pakai StreamBuilder sendiri, tidak nested ──
  Widget _buildBalanceCard(Rupiah rupiah) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: controller.streamProfile(),
      builder: (context, snap) {
        final balance = snap.hasData ? '${snap.data!['balance'] ?? 0}' : '0';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1D2E), Color(0xFF2D3561)],
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
                'balance'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              // Obx hanya untuk toggle hide/show — tidak baca data stream
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.balance.value
                          ? '*****'
                          : rupiah.convertToRupiah(balance),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFFBC4),
                        letterSpacing: -0.5,
                      ),
                    ),
                    IconButton(
                      onPressed: controller.hidebalance,
                      icon: Icon(
                        controller.balance.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: const Color(0xFFFFFBC4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionList(Rupiah rupiah) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.streamTransaction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const _EmptyTransactions();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.streamTransactionItem(doc.id),
              builder: (context, itemSnap) {
                if (!itemSnap.hasData || itemSnap.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }
                final items = itemSnap.data!.docs;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Text(
                          _formatDate(doc['date']),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Colors.grey[200],
                      ),
                      ...List.generate(items.length, (i) {
                        final item = items[i];
                        final d = item.data();
                        final bool isIncome =
                            (d['type'] ?? '').toString().toLowerCase() ==
                            'income';
                        final bool isLast = i == items.length - 1;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.network(
                                      d['icon'] ?? '',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translateCategory(
                                            d['category'] ?? '',
                                          ),
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF030303),
                                          ),
                                        ),
                                        if ((d['notes'] ?? '')
                                            .toString()
                                            .trim()
                                            .isNotEmpty)
                                          Text(
                                            d['notes'],
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              color: Colors.grey[500],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        isIncome
                                            ? '+${rupiah.convertToRupiah('${d['amount']}')}'
                                            : '-${rupiah.convertToRupiah('${d['amount']}')}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isIncome
                                              ? const Color(0xFF2ECC71)
                                              : const Color(0xFFE74C3C),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTapDown: (details) => _showPopupMenu(
                                          context,
                                          details.globalPosition,
                                          d,
                                          item.id,
                                        ),
                                        child: const Icon(
                                          Icons.more_vert_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Colors.grey[100],
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showPopupMenu(
    BuildContext context,
    Offset position,
    Map<String, dynamic> item,
    String docId,
  ) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      items: [
        PopupMenuItem<String>(
          value: 'detail',
          child: Text(
            'view_details'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF1A1D2E),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'edit',
          child: Text(
            'update'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF3D5AF1),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            'delete'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFFE74C3C),
            ),
          ),
        ),
      ],
    );

    if (result == null) return;

    switch (result) {
      case 'detail':
        Get.toNamed(Routes.DETAIL, arguments: {...item, 'id': docId});
      case 'edit':
        Get.toNamed(Routes.EDIT_TRANSAKSI, arguments: {...item, 'id': docId});
      case 'delete':
        controller.deleteData(item['date'] ?? '', docId);
    }
  }

  String _formatDate(dynamic rawDate) {
    if (rawDate == null || rawDate.toString().isEmpty) return '';
    try {
      return DateFormat('d-M-yyyy')
          .format(DateFormat('d-M-yyyy').parse(rawDate.toString()));
    } catch (_) {
      return rawDate.toString();
    }
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'no_transactions'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'no_transactions_sub'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isExpense
                ? [
                    const Color(0xFF131A63),
                    const Color.fromARGB(255, 90, 101, 182),
                  ]
                : [
                    const Color.fromARGB(255, 164, 125, 255),
                    const Color.fromARGB(255, 189, 173, 237),
                  ],
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                color: isExpense
                    ? const Color(0xFF131A63)
                    : const Color.fromARGB(255, 164, 125, 255),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    amount,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}