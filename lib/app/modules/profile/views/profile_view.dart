import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/TextFIeldIsi.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  final authC = Get.find<AuthController>();

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

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          /// 🔥 AVATAR AREA
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 60, bottom: 0),
                            child: Center(
                              child: Container(
                                width: 110,
                                height: 110,
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
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child:
                                      user['photo_url'] == null ||
                                          user['photo_url'] == ''
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          user['photo_url'],
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),

                          /// 🔥 CARD
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height - 200,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F2F7),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                28,
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
                                          arguments: {
                                            "name": user.data()?['name'] ?? '',
                                            "email":
                                                user.data()?['email'] ?? '',
                                            "photo_url":
                                                user.data()?['photo_url'] ?? '',
                                          },
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3E5F5),
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: Text(
                                            "Edit Profile",
                                            style: GoogleFonts.plusJakartaSans(
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

                                  const SizedBox(height: 30),

                                  /// 🔥 LOGOUT BUTTON
                                  GestureDetector(
                                    onTap: () {
                                      Get.defaultDialog(
                                        title: "",
                                        titleStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A2E),
                                        ),
                                        radius: 16,
                                        content: Column(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xFFFFEEEE),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFFCCCC,
                                                  ),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.logout_rounded,
                                                color: Color(0xFFE53935),
                                                size: 28,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              "Logout",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1A1A2E),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Are you sure want to logout?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500],
                                                height: 1.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                        cancel: SizedBox(
                                          width: 250,
                                          child: OutlinedButton(
                                            onPressed: () => Get.back(),
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 13,
                                                  ),
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                  255,
                                                  182,
                                                  182,
                                                  182,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        confirm: SizedBox(
                                          width: 250,
                                          child: ElevatedButton(
                                            onPressed: () => authC.signOut(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFE53935,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 13,
                                                  ),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              "Yes, Logout",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(14),
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
                                            style: GoogleFonts.plusJakartaSans(
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
                        ],
                      ),
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
