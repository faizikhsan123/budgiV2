import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_transaksi_controller.dart';

class EditTransaksiView extends GetView<EditTransaksiController> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditTransaksiView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EditTransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
