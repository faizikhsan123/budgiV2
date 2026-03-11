import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
        decoration: const BoxDecoration(color: Color(0xF6F6F6F6)),
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
                        return Center(child: Text("Data belum ada"));
                      }

                      var data = asyncSnapshot.data!;
                      var rupiah = Rupiah();
                      String imageUrl =
                          "https://ui-avatars.com/api/?name=${data['name']}&background=random&size=256";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image:
                                        data['photo_url'] == null ||
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
                                    '${data['name']}',
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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFDAC2E5), Color(0xFFBD9AC4)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPurple.withOpacity(
                                    0.25,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Total Balance',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textMutedPurple,
                                      letterSpacing: -0.30,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 44),
                                Text(
                                  '${rupiah.convertToRupiah('${data['balance']}')}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                    letterSpacing: -0.75,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Expense: Rp*****',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                    Text(
                                      'Income: Rp****',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 28),

                          // ── Quick Actions ─────────────────────────────────
                          QuickActionsRow(),
                          SizedBox(height: 24),

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
                          SizedBox(height: 10),

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
                                  height: 200,
                                  child: const Center(
                                    child: Text(
                                      "Transaksi belum ada",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              var dataPerhari = snapshot.data!;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dataPerhari.docs.length,
                                itemBuilder: (context, index) {
                                  var doc = dataPerhari.docs[index];
                                  String docId = doc.id;

                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        214,
                                        212,
                                        206,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // TANGGAL
                                        Text(
                                          "${doc['date']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(height: 8),

                                        // STREAM ITEMS
                                        StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>
                                        >(
                                          stream: controller
                                              .streamTransactionItem(docId),
                                          builder: (context, itemSnapshot) {
                                            if (itemSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            if (!itemSnapshot.hasData) {
                                              return Text(
                                                "Belum ada transaksi",
                                              );
                                            }

                                            var dataItem = itemSnapshot.data!;

                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: dataItem.docs.length,
                                              itemBuilder: (context, i) {
                                                var item = dataItem.docs[i];

                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                              item['icon'],
                                                            ),
                                                      ),
                                                      title: Text(
                                                        item['category'],
                                                      ),
                                                      subtitle: Text(
                                                        item['notes'],
                                                      ),
                                                      trailing: Text(
                                                        '${rupiah.convertToRupiah('${item['amount']}')}',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              item['category'] ==
                                                                  'income'
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 1,
                                                      height: 0,
                                                    ),
                                                  ],
                                                );
                                              },
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
                        ],
                      );
                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.logout();
        },
        child: const Icon(Icons.logout_outlined),
      ),
    );
  }
}
