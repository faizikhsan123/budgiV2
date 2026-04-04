import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class bottom_navbar extends StatelessWidget {
  const bottom_navbar({
    super.key,
    required this.pageC,
  });

  final PageIndexController pageC;

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
     
      height: 50,
      //widget bottom navbar
      style: TabStyle.fixed,
      backgroundColor: const Color.fromARGB(255, 189, 157, 195),
      initialActiveIndex: pageC.CurrentIndex.value, //index active
      items: [
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(icon: Icons.add, title: 'Transaction'),
        TabItem(icon: Icons.person, title: 'Profile'),
      ],
      onTap: (index) {
        pageC.changePage(index);
      },
    );
  }
}