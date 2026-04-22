import 'package:budgi/app/modules/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  final Map<String, dynamic> dataArgument =
      (Get.arguments as Map<String, dynamic>?) ?? {};

  EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        "https://api.dicebear.com/9.x/initials/png?seed=${dataArgument['name']}";
    final String photoUrl = (dataArgument['photo_url'] ?? '').isEmpty
        ? imageUrl
        : dataArgument['photo_url'];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF0EBF8),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1D2E),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF1A1D2E),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Avatar ───────────────────────────────────────────────
                GestureDetector(
                  onTap: () => _showPhotoSheet(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -2,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFF0EBF8),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 14,
                            color: Color(0xFF3D5AF1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Form area ────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Full Name'),
                        _buildField(
                          controller: controller.nameC,
                          hint: 'Full name',
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Email'),
                        _buildField(
                          controller: controller.emailC,
                          hint: 'Email',
                          readOnly: true,
                        ),

                        const SizedBox(height: 40),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => controller.updateProfile(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D3A8C),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Save Changes',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
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

          // ── Loading overlay ──────────────────────────────────────────
          Obx(
            () => controller.isloading.value
                ? loading_overlay()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _showPhotoSheet() {
    final bool hasPhoto = (dataArgument['photo_url'] ?? '').isNotEmpty;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 36),
                Text(
                  'Profile Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _SheetItem(
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              color: const Color(0xFF3D5AF1),
              onTap: () async {
                await controller.selectImage();
                Get.back();
              },
            ),
            if (hasPhoto) ...[
              const Divider(height: 1),
              _SheetItem(
                icon: Icons.delete_outline_rounded,
                label: 'Delete Image',
                color: Colors.red,
                onTap: () {
                  controller.deleteImage();
                  Get.back();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1D2E),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1A1D2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3D5AF1), width: 1.5),
        ),
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}