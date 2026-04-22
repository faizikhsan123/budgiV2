import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class bottom_navbar extends StatelessWidget {
  const bottom_navbar({super.key, required this.pageC});

  final PageIndexController pageC;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = pageC.pageIndex.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: current == 0,
                  onTap: () => pageC.changePage(0),
                ),

                // Add Transaction — FAB style
                GestureDetector(
                  onTap: () => pageC.changePage(1),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D5AF1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3D5AF1).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),

                // Profile
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  isSelected: current == 2,
                  onTap: () => pageC.changePage(2),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected
                  ? const Color(0xFF3D5AF1)
                  : const Color(0xFFB0B3C6),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 6 : 0,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF3D5AF1),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}