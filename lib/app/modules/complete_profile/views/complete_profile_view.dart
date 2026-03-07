import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/complete_profile_controller.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ biar scaffold otomatis naik saat keyboard muncul
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E7FF), Color(0xFFF6EBDD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // ✅ ganti Column biasa ke SingleChildScrollView
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              // ✅ pastikan konten minimal setinggi layar
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 160),

                    /// TITLE
                    const Text(
                      "To Continue Fill in\nYour Details",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Enter your Birth of date & Phone Number",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 40),

                    /// BIRTH DATE LABEL
                    const Text(
                      "Birth of date",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 8),

                    /// BIRTH DATE FIELD
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
                              minDate: DateTime(2000),
                              initialSelectedDate: null,
                              maxDate: DateTime(2040),
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
                                      ? "Select Date"
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

                    const SizedBox(height: 25),

                    /// PHONE LABEL
                    const Text(
                      "Phone Number",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 8),

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
                        ),
                      ),
                    ),

                    // ✅ Spacer diganti Expanded biar tetap works di dalam IntrinsicHeight
                    const Expanded(child: SizedBox(height: 40)),

                    /// CONTINUE BUTTON
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.isloading.value
                              ? null
                              : () => controller.LengkapiProfile(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB18FCF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          child: controller.isloading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}