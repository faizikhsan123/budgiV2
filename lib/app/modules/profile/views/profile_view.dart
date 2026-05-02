import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:budgi/app/modules/widgets/loading_awal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  final authC = Get.find<AuthController>();
  // ✅ Hapus: final controller = Get.find<ProfileController>();
  //    GetView sudah provide 'controller' secara otomatis

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = controller.isDark.value;

      final bgColor = isDark
          ? const Color(0xFF0D0D0D)
          : const Color(0xFFF5F6FA);
      final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
      final textPrimary = isDark ? Colors.white : const Color(0xFF1A1D2E);
      final textSecondary = isDark ? Colors.grey[400] : Colors.grey[500];
      final menuCardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
      final shadowColor = isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.05);
      final editBtnColor = isDark
          ? const Color(0xFF0B30FF)
          : const Color.fromARGB(255, 79, 92, 165);

      return Scaffold(
        backgroundColor: bgColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamUser(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: loading_awal());
                      }
          
                      final user = snapshot.data!;
                      final String photoUrl = (user['photo_url'] ?? '').isEmpty
                          ? "https://api.dicebear.com/9.x/initials/png?seed=${user['name']}"
                          : user['photo_url'];
          
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
          
                            // ── Header ──────────────────────────────────────
                            Center(
                              child: Text(
                                'profile'.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
          
                            // ── Profile Card ────────────────────────────────
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor,
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 44,
                                    backgroundImage: NetworkImage(photoUrl),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    user['name'],
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user['email'],
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
          
                                  // Edit Profile Button
                                  GestureDetector(
                                    onTap: () => Get.toNamed(
                                      Routes.EDIT_PROFILE,
                                      arguments: {
                                        "name": user.data()?['name'] ?? '',
                                        "email": user.data()?['email'] ?? '',
                                        "photo_url":
                                            user.data()?['photo_url'] ?? '',
                                      },
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: editBtnColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'edit_profile'.tr,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
          
                            // ── Menu Items ───────────────────────────────────
                            _MenuItem(
                              icon: Icons.translate,
                              label: 'language'.tr,
                              isDark: isDark,
                              menuCardColor: menuCardColor,
                              onTap: (position) =>
                                  _showPopupMenu(context, position),
                            ),
                            const SizedBox(height: 18),
                            _MenuItem(
                              icon: isDark
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined,
                              label: 'theme'.tr,
                              isDark: isDark,
                              menuCardColor: menuCardColor,
                              onTap: (position) =>
                                  _showPopupMenuThema(context, position),
                            ),
                            const SizedBox(height: 18),
                            _MenuItem(
                              icon: Icons.logout_outlined,
                              label: 'logout'.tr,
                              isDark: isDark,
                              menuCardColor: menuCardColor,
                              isDestructive: true,
                              onTap: (position) => _showLogoutDialog(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                bottom_navbar(pageC: pageC),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: '',
      radius: 16,
      content: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFEEEE),
              border: Border.all(color: const Color(0xFFFFCCCC), width: 1.5),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFE53935),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'logout'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'logout_confirm'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
      cancel: SizedBox(
        width: 250,
        child: OutlinedButton(
          onPressed: () => Get.back(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 13),
            side: const BorderSide(color: Color(0xFFB6B6B6)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'cancel'.tr,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      confirm: SizedBox(
        width: 250,
        child: ElevatedButton(
          onPressed: () => authC.signOut(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            padding: const EdgeInsets.symmetric(vertical: 13),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'yes_logout'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Popup Menu Language ───────────────────────────────────────────────────────
void _showPopupMenu(BuildContext context, Offset position) async {
  final profileC = Get.find<ProfileController>();
  final result = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx + 1,
      position.dy + 1,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    items: [
      PopupMenuItem<String>(
        value: 'en',
        child: Text(
          '🇺🇸  English',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ),
      const PopupMenuDivider(height: 1),
      PopupMenuItem<String>(
        value: 'id',
        child: Text(
          '🇮🇩  Indonesia',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ),
      const PopupMenuDivider(height: 1),
      PopupMenuItem<String>(
        value: 'es',
        child: Text(
          '🇪🇸  Español',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ),
      const PopupMenuDivider(height: 1),
      PopupMenuItem<String>(
        value: 'zh',
        child: Text(
          '🇨🇳  中文',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ),
    ],
  );

  if (result == null) return;

  switch (result) {
    case 'en':
      profileC.bahasainggris();
      break;
    case 'id':
      profileC.bahasaindo();
      break;
    case 'es':
      profileC.bahasaspanyol();
      break;
    case 'zh':
      profileC.bahasamandarin();
      break;
  }
}

// ── Popup Menu Tema ───────────────────────────────────────────────────────────
void _showPopupMenuThema(BuildContext context, Offset position) async {
  final profileC = Get.find<ProfileController>();
  final result = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx + 1,
      position.dy + 1,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    items: [
      PopupMenuItem<String>(
        value: 'gelap',
        child: Text(
          '🌙  ${'dark_mode'.tr}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ),
      const PopupMenuDivider(height: 1),
      PopupMenuItem<String>(
        value: 'terang',
        child: Text(
          '☀️  ${'light_mode'.tr}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1A1D2E),
          ),
        ),
      ),
    ],
  );

  if (result == null) return;

  switch (result) {
    case 'gelap':
      profileC.darkMode();
      break;
    case 'terang':
      profileC.lightMode();
      break;
  }
}

// ── Menu Item Widget ──────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function(Offset position) onTap;
  final bool isDestructive;
  final bool isDark;
  final Color menuCardColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.menuCardColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFE53935)
        : isDark
        ? Colors.white
        : const Color(0xFF1A1D2E);

    return GestureDetector(
      onTapDown: (details) => onTap(details.globalPosition),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: menuCardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color,),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color, size: 30),
          ],
        ),
      ),
    );
  }
}
