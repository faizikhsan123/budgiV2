import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/widgets/bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  final authC = Get.find<AuthController>();

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEF8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: controller.streamUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = snapshot.data!;
                  final String photoUrl =
                      (user['photo_url'] ?? '').isEmpty
                          ? "https://api.dicebear.com/9.x/initials/png?seed=${user['name']}"
                          : user['photo_url'];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // ── Header ──────────────────────────────────────
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Profile',
                                style: GoogleFonts.plusJakartaSans(
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
                        const SizedBox(height: 24),

                        // ── Profile Card ────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Avatar
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 44,
                                    backgroundImage: NetworkImage(photoUrl),
                                  ),

                                ],
                              ),
                              const SizedBox(height: 14),

                              // Name
                              Text(
                                user['name'],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1D2E),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user['email'],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: Colors.grey[500],
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
                                    color: const Color(0xFF2D3A8C),
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
                                        'Edit Profile',
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

                        // ── Menu Items ──────────────────────────────────
                        _MenuItem(
                          icon: Icons.translate_rounded,
                          label: 'Languages',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _MenuItem(
                          icon: Icons.settings_outlined,
                          label: 'Theme',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),

                        // Logout item — merah
                        _MenuItem(
                          icon: Icons.logout_rounded,
                          label: 'Logout',
                          isDestructive: true,
                          onTap: () => _showLogoutDialog(context),
                        ),
                        const SizedBox(height: 20),
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
    );
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
          const Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure want to logout?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[500], height: 1.5),
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
          child: const Text(
            'Cancel',
            style: TextStyle(
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
          child: const Text(
            'Yes, Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// ── Menu Item Widget ─────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFE53935) : const Color(0xFF1A1D2E);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
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
            Icon(
              Icons.chevron_right_rounded,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}