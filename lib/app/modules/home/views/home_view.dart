import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
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
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(246, 255, 255, 255),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamProfile(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!asyncSnapshot.hasData) {
                        return const Center(child: Text("Data Is Empty"));
                      }

                      var data = asyncSnapshot.data!;
                      var rupiah = Rupiah();
                      String imageUrl =
                          "https://api.dicebear.com/9.x/initials/png?seed=${data['name']}";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // ── HEADER ──
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: data['photo_url'] == null ||
                                            data['photo_url'] == ""
                                        ? NetworkImage(imageUrl)
                                        : NetworkImage(data['photo_url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 13),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Builder(builder: (context) {
                                    final hour = DateTime.now().hour;
                                    String greeting;
                                    if (hour >= 4 && hour < 10) {
                                      greeting = 'Good Morning';
                                    } else if (hour >= 10 && hour < 15) {
                                      greeting = 'Good Afternoon';
                                    } else if (hour >= 15 && hour < 18) {
                                      greeting = 'Good Evening';
                                    } else {
                                      greeting = 'Good Night';
                                    }
                                    return Text(greeting,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textDark,
                                          letterSpacing: 1.0,
                                        ));
                                  }),
                                  const SizedBox(height: 4),
                                  Text('${data['name']}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                        letterSpacing: -0.45,
                                      )),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── BALANCE CARD ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFFBC9CC6), width: 1),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1,
                                    offset: Offset(0, 1)),
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1,
                                    offset: Offset(1, 3)),
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1,
                                    offset: Offset(-1, 1)),
                              ],
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFBC9CC6),
                                  Color.fromARGB(255, 221, 213, 226),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Your Balance',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: -0.30,
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Text(
                                    rupiah.convertToRupiah(
                                        '${data['balance']}'),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                      letterSpacing: -0.75,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Quick Actions ──
                          QuickActionsRow(),
                          const SizedBox(height: 24),

                          // ── Recent Activity ──
                          Text('Recent Activity',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                                letterSpacing: -0.30,
                              )),
                          const SizedBox(height: 10),

                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: controller.streamRecentTransactions(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: Center(
                                      child: Text("No transactions yet")),
                                );
                              }

                              // Group by tanggal di Flutter — tidak perlu nested stream
                              final grouped = controller
                                  .groupByDate(snapshot.data!.docs);
                              final dates = grouped.keys.toList();

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dates.length,
                                itemBuilder: (context, index) {
                                  final date = dates[index];
                                  final items = grouped[date]!;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: const Color(0xFFBC9CC6),
                                          width: 0.8),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0xFFBC9CC6),
                                            blurRadius: 3,
                                            offset: Offset(0, 1)),
                                        BoxShadow(
                                            color: Color(0xFFBC9CC6),
                                            blurRadius: 3,
                                            offset: Offset(0, -1)),
                                        BoxShadow(
                                            color: Color(0xFFBC9CC6),
                                            blurRadius: 3,
                                            offset: Offset(1, 0)),
                                        BoxShadow(
                                            color: Color(0xFFBC9CC6),
                                            blurRadius: 3,
                                            offset: Offset(-1, 0)),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // DATE HEADER
                                        Text(
                                          DateFormat('EEEE, d MMMM yyyy')
                                              .format(DateFormat("d-M-yyyy")
                                                  .parse(date)),
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // ITEMS
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: items.length,
                                          separatorBuilder: (_, __) =>
                                              const Divider(
                                                  height: 16,
                                                  thickness: 1,
                                                  color: Color(0xFFBC9CC6)),
                                          itemBuilder: (context, i) {
                                            final item = items[i];
                                            final bool isIncome =
                                                item['type'] == 'income';

                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: SizedBox(
                                                width: 42,
                                                height: 42,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: SvgPicture.network(
                                                    item['icon'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                item['category'],
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: (item['notes'] ==
                                                          null ||
                                                      item['notes']
                                                          .toString()
                                                          .trim()
                                                          .isEmpty)
                                                  ? null
                                                  : Text(
                                                      item['notes'],
                                                      style: GoogleFonts
                                                          .plusJakartaSans(
                                                        fontSize: 12,
                                                        color: Colors.grey[900],
                                                      ),
                                                    ),
                                              trailing: Text(
                                                isIncome
                                                    ? "+ ${rupiah.convertToRupiah('${item['amount']}')}"
                                                    : "- ${rupiah.convertToRupiah('${item['amount']}')}",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: isIncome
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
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

              // ── Bottom Nav ──
              bottom_navbar(pageC: pageC),
            ],
          ),
        ),
      ),
    );
  }
}