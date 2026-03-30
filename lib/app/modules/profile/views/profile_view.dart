import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/TextFIeldIsi.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEADCF0), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.streamUser(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final user = snapshot.data!;
                    String imageUrl =
                        "https://ui-avatars.com/api/?name=${user['name']}&background=random&size=256";

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        /// 🔥 CARD
                        Positioned(
                          top: 180,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F2F7),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28),
                                topRight: Radius.circular(28),
                              ),
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                70,
                                24,
                                24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 🔥 HEADER NAME + EDIT
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['name'],
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            user['email'],
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => Get.toNamed(
                                          Routes.EDIT_PROFILE,
                                          arguments: user.data(),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3E5F5),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            "Edit",
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),

                                  /// 🔥 FORM SECTION
                                  buildLabel('Full Name'),
                                  TextFiledIsi(
                                    filled: true,
                                    readonly: true,
                                    hint: user['name'],
                                  ),

                                  buildLabel('Email'),
                                  TextFiledIsi(
                                    filled: true,
                                    readonly: true,
                                    hint: user['email'],
                                  ),

                                  buildLabel("Date of Birth"),
                                  Container(
                                    height: 55,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.03),
                                          blurRadius: 6,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user['tanggal_lahir'],
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),

                                  buildLabel("Phone Number"),
                                  TextFiledIsi(
                                    readonly: true,
                                    filled: true,
                                    hint: user['phone'],
                                  ),

                                  const SizedBox(height: 30),

                                  /// 🔥 LOGOUT BUTTON (CLEAN)
                                  GestureDetector(
                                    onTap: () {
                                      // controller.logout(); // 🔥 pastikan ada di controller
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.logout,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Logout",
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// 🔥 AVATAR (OVERLAY)
                        Positioned(
                          top: 120,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: ClipOval(
                                child: user['photo_url'] == null ||
                                        user['photo_url'] == ''
                                    ? Image.network(imageUrl,
                                        fit: BoxFit.cover)
                                    : Image.network(user['photo_url'],
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              bottom_navbar(pageC: pageC),
            ],
          ),
        ),
      ),
    );
  }
}