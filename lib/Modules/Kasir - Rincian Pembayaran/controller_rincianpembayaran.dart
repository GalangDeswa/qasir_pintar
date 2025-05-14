import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Rincian%20Pembayaran/view_rincianpembayaran.dart';

class RincianPembayaranController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  List<Widget> pages = [
    RincianPembayaran(),
    Container(
      height: 100,
      width: 100,
      color: Colors.red,
    ),
    Container(
      height: 100,
      width: 100,
      color: Colors.green,
    ),
    Container(
      height: 100,
      width: 100,
      color: Colors.blue,
    )
  ];
}
