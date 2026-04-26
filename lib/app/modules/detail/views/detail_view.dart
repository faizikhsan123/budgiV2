import 'package:budgi/app/bahasa/category_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:format_indonesia_v2/format_indonesia_v2.dart';
import 'package:intl/intl.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final rupiah = Rupiah();

    final String icon = args['icon'] ?? '';
    final String category = args['category'] ?? '';
    final String notes = args['notes'] ?? '';
    final String date = args['date'] ?? '';
    final num amount = args['amount'] ?? 0;

    String formattedDate = date;
    try {
      final locale = Get.locale?.toString().replaceAll('_', '-') ?? 'en';
      formattedDate = DateFormat('d-M-yyyy', locale)
          .format(DateFormat('d-M-yyyy').parse(date));
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: Get.back,
          child: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2E)),
        ),
        title: Text(
          'view_details'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: SvgPicture.network(icon, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    rupiah.convertToRupiah('${amount.toInt()}'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1D2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notes,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'details'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1D2E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey[200]),
                  const SizedBox(height: 8),

                  // ← pakai translateCategory di sini
                  _DetailRow(
                    label: 'category'.tr,
                    value: translateCategory(category),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    label: 'amount'.tr,
                    value: rupiah.convertToRupiah('${amount.toInt()}'),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(label: 'date'.tr, value: formattedDate),
                  const SizedBox(height: 12),
                  _DetailRow(
                    label: 'notes'.tr,
                    value: notes.isEmpty ? '-' : notes,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ],
    );
  }
}