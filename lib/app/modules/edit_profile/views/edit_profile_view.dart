import 'package:budgi/app/modules/widgets/TextField.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
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
    String imageUrl =
        "https://ui-avatars.com/api/?name=${dataArgument['name']}&background=random&size=256";
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0535, 0.3931],
            colors: [Color.fromARGB(255, 221, 199, 154), Colors.white],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios, size: 30),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    ),

                                    buildLabel('Email'),
                                    buildTextField(
                                      controller: controller.emailC,
                                      hint: 'Email',
                                      readonly: true,
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
                                                  DateRangePickerSelectionMode
                                                      .single,
                                              showActionButtons: true,
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
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.05,
                                                ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
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
                                        textFieldController:
                                            controller.phoneTextC,
                                        keyboardType: TextInputType.number,
                                        formatInput: true,
                                        inputDecoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    GetBuilder<EditProfileController>(
                                      builder: (controller) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.pickedIMage == null
                                                ? "No image selected"
                                                : controller.pickedIMage!.path
                                                      .split('/')
                                                      .last,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Spacer(),
                                          TextButton(
                                            onPressed: () =>
                                                controller.selectImage(),
                                            child: Text(
                                              "Pilih File",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    Obx(
                                      () => SizedBox(
                                        width: Get.width,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                  Color.fromARGB(
                                                    255,
                                                    219,
                                                    188,
                                                    224,
                                                  ),
                                                ),
                                          ),
                                          // ✅ disable saat loading
                                          onPressed: controller.isloading.value
                                              ? null
                                              : () =>
                                                    controller.updateProfile(),
                                          // ✅ spinner saat loading
                                          child: controller.isloading.value
                                              ? const SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2.5,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : const Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
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
                      top: 100,
                      left: 160,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFD9B3E6),
                          border: Border.all(
                            color: const Color.fromARGB(255, 224, 219, 219),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child:
                              dataArgument['photo_url'] == null ||
                                  dataArgument['photo_url'] == ''
                              ? Image.network('${imageUrl}', fit: BoxFit.cover)
                              : Image.network(
                                  '${dataArgument['photo_url']}',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 70,
                      right: 145,
                      child: Container(
                        width: 80,
                        height: 80,
                        child:
                            dataArgument['photo_url'] == null ||
                                dataArgument['photo_url'] == ''
                            ? SizedBox()
                            : IconButton(
                                onPressed: () {
                                  controller.deleteImage();
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
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
    );
  }
}
