import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  final dataArgument = Get.arguments as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
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
                colors: [Color.fromARGB(255, 203, 186, 208), Colors.white],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_outlined, size: 30),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 110,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 238, 235, 235),
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
                                          dataArgument['name'],
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          dataArgument['email'],
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 24),

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
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                child: SfDateRangePicker(
                                                  controller: controller.dateC,
                                                  selectionMode:
                                                      DateRangePickerSelectionMode
                                                          .single,
                                                  showActionButtons: true,
                                                  initialSelectedDate: null,
                                                  todayHighlightColor:
                                                      Colors.transparent,
                                                  showNavigationArrow: true,
                                                  selectionColor: Color(
                                                    0xFFBC9CC6,
                                                  ),
                                                  showTodayButton: false,
                                                  onCancel: () => Get.back(),
                                                  onSubmit: (obj) {
                                                    DateTime date =
                                                        obj as DateTime;

                                                    controller
                                                            .nilaiTanggal
                                                            .value =
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      controller
                                                              .nilaiTanggal
                                                              .value
                                                              .isEmpty
                                                          ? "Select Date"
                                                          : controller
                                                                .nilaiTanggal
                                                                .value,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.15,
                                                ),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                          child: InternationalPhoneNumberInput(
                                            onInputChanged:
                                                (PhoneNumber number) {
                                                  controller.phoneC = number;
                                                  print(number.phoneNumber);
                                                },
                                            selectorConfig:
                                                const SelectorConfig(
                                                  selectorType:
                                                      PhoneInputSelectorType
                                                          .DROPDOWN,
                                                  showFlags: true,
                                                ),
                                            initialValue: controller.phoneC,
                                            textFieldController:
                                                controller.phoneTextC,
                                            keyboardType: TextInputType.number,
                                            formatInput: true,
                                            inputDecoration:
                                                const InputDecoration(
                                                  border: InputBorder.none,
                                                  isCollapsed: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        vertical: 18,
                                                      ),
                                                ),
                                          ),
                                        ),

                             

                                        SizedBox(height: 30),

                                        buildButtonPink(
                                          text: 'Save',
                                          onTap: () =>
                                              controller.updateProfile(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: 70,
                          left: 150,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFD9B3E6),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD9B3E6),
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: const Color(0xFFD9B3E6),
                                  blurRadius: 2,
                                  offset: const Offset(2, 0),
                                ),
                                BoxShadow(
                                  color: const Color(0xFFD9B3E6),
                                  blurRadius: 2,
                                  offset: const Offset(-2, 0),
                                ),
                                BoxShadow(
                                  color: const Color(0xFFD9B3E6),
                                  blurRadius: 2,
                                  offset: const Offset(0, -1),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child:
                                  dataArgument['photo_url'] == null ||
                                      dataArgument['photo_url'] == ''
                                  ? Image.network(
                                      '${imageUrl}',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      '${dataArgument['photo_url']}',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 90,
                          right: 160,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xFFE8D9EC),
                              border: Border.all(
                                color: Color(0xFFD9B3E6),
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  Container(
                                    height:
                                        dataArgument['photo_url'] == null ||
                                            dataArgument['photo_url'] == ''
                                        ? 120
                                        : 175,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 30),
                                              Text(
                                                "Profile Photo",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                    ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.cancel_outlined,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                                ),
                                                onPressed: () => Get.back(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.purple,
                                                ),
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
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              0,
                                                              0,
                                                              0,
                                                            ),
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
                                                  icon: Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () =>
                                                      controller.deleteImage(),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      controller.deleteImage(),
                                                  child: Text(
                                                    "Delete Image",
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
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
                              icon: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Color.fromARGB(255, 213, 168, 228),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay full screen
          Obx(
            () => controller.isloading.value ? loading_overlay() : SizedBox(),
          ),
        ],
      ),
    );
  }
}
