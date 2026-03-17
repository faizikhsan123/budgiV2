import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

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
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 194, 170, 201),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0535, 0.3931],
           
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: controller.streamUser(),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = asyncSnapshot.data!;

                  String imageUrl =
                      "https://ui-avatars.com/api/?name=${user['name']}&background=random&size=256";

                  return Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // CARD PUTIH
                        Positioned(
                          top: 150,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 245, 242, 242),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFBC9CC6),
                                  blurRadius: 4,
                                  offset: Offset(2, -1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.fromLTRB(
                                      24,
                                      60,
                                      24,
                                      24,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user['name']}',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark,
                                          ),
                                        ),

                                        const SizedBox(height: 2),

                                        Text(
                                          '${user['email']}',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textDark,
                                          ),
                                        ),

                                        const SizedBox(height: 24),

                                        buildLabel('Full Name'),
                                        buildTextField(
                                           filled: true,
                                          readonly: true,
                                          hint: '${user['name']}',
                                        ),

                                        buildLabel('Email'),
                                        buildTextField(
                                          filled: true,
                                          readonly: true,
                                          hint: '${user['email']}',
                                        ),

                                        buildLabel("Date of Birth"),

                                        Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                         
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${user['tanggal_lahir']}",
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
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

                                        buildTextField(
                                          readonly: true,
                                          filled: true,
                                          hint: '${user['phone']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // AVATAR PROFILE
                        Positioned(
                          top: 110,
                          left: 24,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFD9B3E6),
                              border: Border.all(
                                color: const Color(0xFFD9B3E6),
                                width: 3,
                              ),
                            ),
                            child: ClipOval(
                              child:
                                  user['photo_url'] == null ||
                                      user['photo_url'] == ''
                                  ? Image.network(
                                      '${imageUrl}',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      '${user['photo_url']}',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        // BUTTON EDIT PROFILE
                        Positioned(
                          top: 170,
                          right: 24,
                          child: GestureDetector(
                            onTap: () => Get.toNamed(
                              Routes.EDIT_PROFILE,
                              arguments: user.data(),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5EAF7),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // BOTTOM NAVBAR
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
