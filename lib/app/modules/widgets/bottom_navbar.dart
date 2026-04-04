import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class bottom_navbar extends StatelessWidget {
  const bottom_navbar({super.key, required this.pageC});

  final PageIndexController pageC;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFC19DC8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SalomonBottomBar(
          currentIndex: pageC.pageIndex.value,
          onTap: pageC.changePage,
        
          selectedItemColor: Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: const Color.fromARGB(255, 226, 223, 223),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          itemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              title: const Text('Home'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.add_circle_outline),
              title: const Text('Add Transaction'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_outline),
              title: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
