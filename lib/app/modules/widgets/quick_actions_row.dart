import 'package:budgi/app/modules/scan_bill/controllers/scan_bill_controller.dart';
import 'package:budgi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class QuickActionsRow extends StatelessWidget {
  final ScanC = Get.find<ScanBillController>();
  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(
        labelKey: 'analytics',
        url:
            'https://res.cloudinary.com/dzfi5acyl/image/upload/v1776970771/Group_37263_h71lvx.svg',
        onTap: () => Get.toNamed(Routes.ANALYTICS),
      ),
      _CategoryData(
        labelKey: 'history',
        url:
            'https://res.cloudinary.com/dzfi5acyl/image/upload/v1776970872/Group_37264_hdwxrj.svg',
        onTap: () => Get.toNamed(Routes.HISTORY),
      ),
      _CategoryData(
        labelKey: 'split_bill',
        url:
            'https://res.cloudinary.com/dzfi5acyl/image/upload/v1776970902/Group_37261_m0fego.svg',
        onTap: () {
          Get.toNamed(Routes.SCAN_BILL);
          // ScanC.openCameras();
        },
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((cat) => _CategoryItem(data: cat)).toList(),
    );
  }
}

class _CategoryData {
  final String labelKey;
  final String url;
  final VoidCallback onTap;

  const _CategoryData({
    required this.labelKey,
    required this.url,
    required this.onTap,
  });
}

class _CategoryItem extends StatelessWidget {
  final _CategoryData data;
  const _CategoryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
            child: SvgPicture.network(
              data.url,
              fit: BoxFit.contain,
              placeholderBuilder: (_) => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Text(
            data.labelKey.tr,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1D2E),
            ),
          ),
        ],
      ),
    );
  }
}
