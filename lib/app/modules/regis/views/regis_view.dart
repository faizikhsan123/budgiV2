import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input_v2/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/regis_controller.dart';

class RegisView extends GetView<RegisController> {
  @override
  Widget build(BuildContext context) {
    String phoneNumber;
    PhoneNumber number = PhoneNumber(isoCode: 'ID');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFF5EBDC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// BACK BUTTON
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Create an account to continue!",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 30),

                buildLabel("Full Name"),
                buildTextField(
                  hint: "",
                  keyboardType: TextInputType.text,
                  controller: controller.nameC,
                ),

                buildLabel("Email"),
                buildTextField(
                  hint: "",
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailC,
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
                          selectionMode: DateRangePickerSelectionMode
                              .single, //mode datepicker
                          minDate: DateTime(2000),
                          initialSelectedDate: null,
                          maxDate: DateTime(2040),
                          todayHighlightColor: Colors.transparent,
                          showNavigationArrow: true,
                          showActionButtons: true, //tampilkan tombol
                          onCancel: () =>
                              Get.back(), //ketika tombol cancel ditekan
                          onSubmit: (obj) {
                            DateTime date = obj as DateTime;

                            controller.nilaiTanggal.value =
                                "${date.day}/${date.month}/${date.year}";

                            print(
                              " data tagnggal : ${controller.nilaiTanggal.value}",
                            );

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

                buildLabel("Phone Number"),
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
                      controller.phoneC = number; // 🔥 INI WAJIB
                      print(number.phoneNumber);
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
                      border: InputBorder.none, // 🔥 hilangkan border default
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      hintText: "812-3456-7890",
                    ),
                  ),
                ),

                buildLabel("Set Password"),
                Obx(
                  () => buildTextField(
                    controller: controller.passC,
                    hint: "********",
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.ishidepass.toggle();
                      },
                      icon: controller.ishidepass.value == true
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),

                    obscureText: controller.ishidepass.value,
                  ),
                ),

                buildLabel("Re-Enter Password"),

                Obx(
                  () => buildTextField(
                    controller: controller.passReC,
                    hint: "********",
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.ishidepassreentry.toggle();
                      },
                      icon: controller.ishidepassreentry.value == true
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    obscureText: controller.ishidepassreentry.value,
                  ),
                ),

                const SizedBox(height: 30),

                /// SIGN UP BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.jalankanRegis();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB18FCF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// LOGIN TEXT
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.LOGIN),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// LABEL
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 15),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  /// TEXT FIELD STYLE
  Widget buildTextField({
    required String hint,
    TextEditingController? controller,
    bool obscureText = false,
    Widget? suffixIcon,
    // VoidCallback? onSuffixTap,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(
            minHeight: 55,
            minWidth: 55,
          ),
        ),
      ),
    );
  }

  /// PHONE FIELD
  Widget buildPhoneField() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: const [
          Text("+62", style: TextStyle(fontSize: 15)),

          VerticalDivider(width: 20),
          Expanded(child: Text("821-726-0592", style: TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
