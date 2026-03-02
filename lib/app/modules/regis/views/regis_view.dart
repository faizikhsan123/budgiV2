import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/regis_controller.dart';

class RegisView extends GetView<RegisController> {
  const RegisView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'RegisView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
