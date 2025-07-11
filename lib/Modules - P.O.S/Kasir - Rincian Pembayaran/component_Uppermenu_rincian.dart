import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Pembayaran/controller_pembayaran.dart';

import '../Kasir/controller_kasir.dart';

class UppermenuRincian extends GetView<KasirController> {
  const UppermenuRincian({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: context.res_width,
        color: AppColor.primary,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total tagihan',
                    style: AppFont.regular_white(),
                  ),
                  Text(
                    'Rp. ' + AppFormat().numFormat(controller.total.value),
                    style: AppFont.big_white(),
                  )
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 20),
            //   width: 2,
            //   color: Colors.white,
            // ),
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         'Pembayaran',
            //         style: AppFont.regular_white(),
            //       ),
            //       Text(
            //         'Rp. ' + controller.totalHarga.toString(),
            //         style: AppFont.big_white(),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ));
  }
}
