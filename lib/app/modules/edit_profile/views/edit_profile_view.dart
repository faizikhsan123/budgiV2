import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  final dataArgument = Get.arguments as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.22;
    final cameraSize = avatarSize * 0.38;

    String imageUrl =
        "https://ui-avatars.com/api/?name=${dataArgument['name']}&background=random&size=256";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 218, 206, 222), Colors.white],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24,
                      ),
                    ),
                  ),

                  // ✅ Avatar + nama + email di tengah, di area gradient
                  Center(
                    child: Column(
                      children: [
                        // Avatar + kamera
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Foto profil
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFD9B3E6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFD9B3E6),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: dataArgument['photo_url'] == null ||
                                        dataArgument['photo_url'] == ''
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        dataArgument['photo_url'],
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),

                            // ✅ Kamera pojok kanan bawah avatar
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      height: dataArgument['photo_url'] ==
                                                  null ||
                                              dataArgument['photo_url'] == ''
                                          ? 120
                                          : 175,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const SizedBox(width: 30),
                                                Text(
                                                  "Profile Photo",
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.cancel_outlined),
                                                  onPressed: () => Get.back(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.image,
                                                      color: Colors.purple),
                                                  onPressed: () async {
                                                    await controller
                                                        .selectImage();
                                                    Get.back();
                                                  },
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await controller
                                                        .selectImage();
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    "Gallery",
                                                    style: GoogleFonts
                                                        .plusJakartaSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (dataArgument['photo_url'] !=
                                                    null &&
                                                dataArgument['photo_url'] != '')
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.red),
                                                    onPressed: () => controller
                                                        .deleteImage(),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => controller
                                                        .deleteImage(),
                                                    child: Text(
                                                      "Delete Image",
                                                      style: GoogleFonts
                                                          .plusJakartaSans(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: cameraSize,
                                  height: cameraSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xFFE8D9EC),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: cameraSize * 0.55,
                                    color: const Color(0xFFBC9CC6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ✅ Nama di bawah avatar, tengah
                        Text(
                          dataArgument['name'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // ✅ Email di bawah nama, tengah
                        Text(
                          dataArgument['email'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // ✅ White card mulai di bawah nama/email — tidak terlalu tinggi
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 246, 244, 244),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFBC9CC6),
                            blurRadius: 4,
                            offset: Offset(2, -1),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel('Full Name'),
                            buildTextField(
                              controller: controller.nameC,
                              hint: 'Full name',
                              filled: true,
                            ),

                            buildLabel('Email'),
                            buildTextField(
                              controller: controller.emailC,
                              hint: 'Email',
                              readonly: true,
                              filled: true,
                            ),

                            buildLabel("Birth of date"),

                            InkWell(
                              onTap: () => Get.dialog(
                                Dialog(
                                  child: Container(
                                    height: 400,
                                    padding: const EdgeInsets.all(10),
                                    child: SfDateRangePicker(
                                      controller: controller.dateC,
                                      selectionMode:
                                          DateRangePickerSelectionMode.single,
                                      showActionButtons: true,
                                      initialSelectedDate: null,
                                      todayHighlightColor: Colors.transparent,
                                      showNavigationArrow: true,
                                      selectionColor: const Color(0xFFBC9CC6),
                                      showTodayButton: false,
                                      onCancel: () => Get.back(),
                                      onSubmit: (obj) {
                                        DateTime date = obj as DateTime;
                                        controller.nilaiTanggal.value =
                                            "${date.day}/${date.month}/${date.year}";
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              child: Obx(
                                () => Container(
                                  height: 55,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.nilaiTanggal.value.isEmpty
                                              ? "Select Date"
                                              : controller.nilaiTanggal.value,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            buildLabel("Phone Number"),

                            Container(
                              height: 55,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  controller.phoneC = number;
                                  print(number.phoneNumber);
                                },
                                selectorConfig: const SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.DROPDOWN,
                                  showFlags: true,
                                ),
                                initialValue: controller.phoneC,
                                textFieldController: controller.phoneTextC,
                                keyboardType: TextInputType.number,
                                formatInput: true,
                                inputDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 18),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            buildButtonPink(
                              text: 'Save',
                              onTap: () => controller.updateProfile(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          Obx(
            () => controller.isloading.value
                ? loading_overlay()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}