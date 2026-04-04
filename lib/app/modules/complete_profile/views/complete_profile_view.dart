import 'package:budgi/app/modules/widgets/ButtonPink.dart';
import 'package:budgi/app/modules/widgets/labelTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/complete_profile_controller.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ biar scaffold otomatis naik saat keyboard muncul
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(252, 255, 255, 255),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            // ✅ ganti Column biasa ke SingleChildScrollView
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  /// TITLE
                  Text(
                    "Complete Your Personal\n Information",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 32,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Please fill the form below to complete your personal information",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color.fromARGB(255, 84, 82, 82),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// BIRTH DATE LABEL
                  buildLabel('Birth Date'),

                  const SizedBox(height: 5),

                  /// BIRTH DATE FIELD
                  InkWell(
                    onTap: () => Get.dialog(
                      Dialog(
                        child: Container(
                          height: 400,
                          padding: const EdgeInsets.all(10),
                          child: SfDateRangePicker(
                            controller: controller.dateC,
                            selectionMode: DateRangePickerSelectionMode.single,
                            minDate: DateTime(1990),
                            initialSelectedDate: null,
                            maxDate: DateTime(2016),
                            selectionColor: Color(0xFFBC9CC6),

                            todayHighlightColor: Colors.transparent,
                            showNavigationArrow: true,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                    ? "Select your birth date"
                                    : controller.nilaiTanggal.value,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: controller.nilaiTanggal.value.isEmpty
                                      ? Colors.grey.shade500
                                      : Colors.black,
                                  fontWeight:
                                      controller.nilaiTanggal.value.isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.w500,
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
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// PHONE LABEL
                  buildLabel('Phone Number'),

                  const SizedBox(height: 5),

                  /// PHONE FIELD
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        controller.phoneC = number;
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DROPDOWN,
                        showFlags: true,
                      ),
                      initialValue: PhoneNumber(isoCode: 'ID'),
                      textFieldController: TextEditingController(),

                      formatInput: true,
                      keyboardType: TextInputType.number,
                      inputDecoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintText: "812-3456-7890",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  /// CONTINUE BUTTON
                  buildButtonPink(
                    text: 'Continue',
                    onTap: () => controller.LengkapiProfile(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
