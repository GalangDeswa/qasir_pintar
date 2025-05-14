import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Pembayaran/controller_pembayaran.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Widget/popscreen.dart';

class BottomMenuPembayaran extends GetView<PembayaranController> {
  const BottomMenuPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Container(
            padding: AppPading.defaultBodyPadding(),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total :',
                  style: AppFont.regular(),
                ),
                Text(
                  'Rp. ' + controller.total.value.toString(),
                  style: AppFont.regular(),
                ),
              ],
            ),
          );
        }),
        Container(
          height: 80,
          //width: context.res_width,
          color: AppColor.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Expanded(
                    //   child: button_border_custom(
                    //       margin: EdgeInsets.all(20),
                    //       onPressed: () {},
                    //       child: Text('Simpan order'),
                    //       width: context.res_width),
                    // ),
                    Expanded(
                      child: button_border_custom(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            Get.toNamed('/rincianpembayaran');
                          },
                          child: Text('Bayar'),
                          width: context.res_width),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
