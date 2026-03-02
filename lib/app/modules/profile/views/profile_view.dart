import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
         bottomNavigationBar: ConvexAppBar(
        //widget bottom navbar
        style: TabStyle.fixed, //style bottom navbar
        initialActiveIndex: pageC.CurrentIndex.value, //index active
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.qr_code, title: 'Scan Qr'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        onTap: (index) {
          pageC.changePage(index);
        },
      ),
    );
  }
}
