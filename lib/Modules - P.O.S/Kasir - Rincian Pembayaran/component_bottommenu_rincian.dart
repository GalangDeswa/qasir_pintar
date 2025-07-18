import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qasir_pintar/Config/config.dart';

import 'package:qasir_pintar/Widget/popscreen.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Controllers/printerController.dart';
import '../Kasir - Pembayaran/controller_pembayaran.dart';
import '../Kasir/controller_kasir.dart';

class BottommenuRincian extends GetView<KasirController> {
  const BottommenuRincian({super.key});

  @override
  Widget build(BuildContext context) {
    //final PrintController _ctrl = Get.put(PrintController());
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.all(10),
          color: AppColor.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pembayaran',
                style: AppFont.regular_white(),
              ),
              Obx(() {
                return Center(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: controller.bayar.value,
                    style: AppFont.big_white(),
                    keyboardType: TextInputType.number,
                  ),
                );
              })
            ],
          ),
        ),
        Container(
            height: 60,
            width: context.res_width,
            color: AppColor.primary,
            child: button_border_custom(
                onPressed: () {
                  if (controller.bayarvalue < controller.total.value) {
                    Get.showSnackbar(toast().bottom_snackbar_error(
                        "Error", 'uang tidak mencukupi'));
                    return;
                  }
                  Popscreen().konfirmasibayar(controller.keranjang, controller);
                  //controller.printString();
                  //controller.startScan();
                  // controller.printReceipt(controller.printers[0]);
                },
                child: Text('Bayar'),
                width: Get.width)),
      ],
    );
  }
}
