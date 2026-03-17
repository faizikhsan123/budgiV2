import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
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
        decoration: const BoxDecoration(color: Color.fromARGB(246, 255, 255, 255)),
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
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border(
                                top: BorderSide(
                                  color: const Color(0xFFBC9CC6),
                                  width: 3,
                                ),
                                bottom: BorderSide(
                                  color: const Color(0xFFBC9CC6),
                                  width: 3,
                                ),
                                left: BorderSide(
                                  color: const Color(0xFFBC9CC6),
                                  width: 3,
                                ),
                                right: BorderSide(
                                  color: const Color(0xFFBC9CC6),
                                  width: 3,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 1,
                                  offset: Offset(1, 3),
                                ),
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 1,
                                  offset: Offset(-1, 1),
                                ),
                              ],

                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFBC9CC6),
                                  Color.fromARGB(255, 221, 213, 226),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Your Balance',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      letterSpacing: -0.30,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 30,
                                  ),
                                  child: Text(
                                    '${rupiah.convertToRupiah('${data['balance']}')}',
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

                          SizedBox(height: 28),

                          // ── Quick Actions ─────────────────────────────────
                          QuickActionsRow(),
                          SizedBox(height: 24),

                          // ── Recent Activity Header ────────────────────────
                          Text(
                            'Recent Activity',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
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
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border(
                                        top: BorderSide(
                                          color: const Color(0xFFBC9CC6),
                                          width: 0.8,
                                        ),
                                        bottom: BorderSide(
                                          color: const Color(0xFFBC9CC6),
                                          width: 0.8,
                                        ),
                                        left: BorderSide(
                                          color: const Color(0xFFBC9CC6),
                                          width: 0.8,
                                        ),
                                        right: BorderSide(
                                          color: const Color(0xFFBC9CC6),
                                          width: 0.8,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFBC9CC6),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFFBC9CC6),
                                          blurRadius: 3,
                                          offset: const Offset(0, -1),
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFFBC9CC6),
                                          blurRadius: 3,
                                          offset: const Offset(1, 0),
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFFBC9CC6),
                                          blurRadius: 3,
                                          offset: const Offset(-1, 0),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// DATE
                                        Text(
                                          DateFormat(
                                            'EEEE, d MMMM yyyy',
                                          ).format(
                                            DateFormat(
                                              "d-M-yyyy",
                                            ).parse(doc['date']),
                                          ),
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[900],
                                          ),
                                        ),

                                        const SizedBox(height: 10),
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
                                              return const Text(
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

                                                bool isIncome =
                                                    item['category'] ==
                                                    'income';

                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading: Container(
                                                        width: 42,
                                                        height: 42,

                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8,
                                                              ),
                                                          child: Image.network(
                                                            item['icon'],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),

                                                      title: Text(
                                                        item['category'],
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                            ),
                                                      ),

                                                      subtitle: Text(
                                                        item['notes'],
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[900],
                                                            ),
                                                      ),

                                                      trailing: Text(
                                                        isIncome
                                                            ? "+ ${rupiah.convertToRupiah('${item['amount']}')}"
                                                            : "-${rupiah.convertToRupiah('${item['amount']}')}",
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: isIncome
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                            ),
                                                      ),
                                                    ),

                                                    if (i !=
                                                        dataItem.docs.length -
                                                            1)
                                                      Divider(
                                                        height: 16,
                                                        thickness: 1,
                                                        color: Color(
                                                          0xFFBC9CC6,
                                                        ),
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
