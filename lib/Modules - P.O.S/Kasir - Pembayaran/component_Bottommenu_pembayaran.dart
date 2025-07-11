import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Pembayaran/controller_pembayaran.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Widget/popscreen.dart';

class BottomMenuPembayaran extends GetView<KasirController> {
  const BottomMenuPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPelangganController>();
    return Column(
      children: [
        Obx(() {
          return Container(
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            // color: Colors.red,
            padding: AppPading.defaultBodyPadding(),
            child: Column(
              children: [
                Padding(
                  padding: AppPading.customBottomPaddingSmall(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal :', style: AppFont.regular()),
                      Text(
                          'Rp. ' +
                              AppFormat().numFormat(controller.subtotal.value),
                          style: AppFont.regular_bold()),
                    ],
                  ),
                ),
                Divider(),
                Obx(() {
                  return ExpansionTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text('Detail :', style: AppFont.regular()),
                    shape: const Border(),
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: EdgeInsets.zero,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.centerLeft,
                    children: [
                      controller.displaydiskon.value == 0.0
                          ? Container()
                          : Padding(
                              padding: AppPading.customBottomPaddingSmall(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Diskon',
                                    style: AppFont.regular(),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Rp, ' +
                                            AppFormat().numFormat(controller
                                                .jumlahdiskonkasir.value),
                                        style: AppFont.regular_bold(),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      controller.metode_diskon == 1
                                          ? Text(
                                              "(" +
                                                  controller.displaydiskon.value
                                                      .toStringAsFixed(0) +
                                                  '%)'.toString(),
                                              style: AppFont.regular_bold(),
                                            )
                                          : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                      controller.promolistvalue == null
                          ? Container()
                          : Padding(
                              padding: AppPading.customBottomPaddingSmall(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Promo', style: AppFont.regular()),
                                  Text(
                                      controller.promolist
                                                  .where((nilai) =>
                                                      nilai.uuid ==
                                                      controller.promolistvalue)
                                                  .first
                                                  .promoNominal !=
                                              0.0
                                          ? 'Rp. ' +
                                              AppFormat().numFormat(controller
                                                  .promolist
                                                  .where((promo) =>
                                                      promo.uuid ==
                                                      controller.promolistvalue
                                                          .toString())
                                                  .first
                                                  .promoNominal) +
                                              '  ' +
                                              '(' +
                                              controller.promolist
                                                  .where((promo) =>
                                                      promo.uuid ==
                                                      controller.promolistvalue
                                                          .toString())
                                                  .first
                                                  .namaPromo! +
                                              ')'
                                          : '% ' +
                                              controller.promolist
                                                  .where((promo) =>
                                                      promo.uuid ==
                                                      controller.promolistvalue
                                                          .toString())
                                                  .first
                                                  .promoPersen
                                                  .toString()! +
                                              '  '
                                                  '(' +
                                              controller.promolist
                                                  .where((promo) =>
                                                      promo.uuid ==
                                                      controller.promolistvalue
                                                          .toString())
                                                  .first
                                                  .namaPromo! +
                                              ')',
                                      style: AppFont.regular_bold())
                                ],
                              ),
                            ),
                      controller.pelangganvalue.value == ''
                          ? Container()
                          : Padding(
                              padding: AppPading.customBottomPaddingSmall(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pelanggan',
                                    style: AppFont.regular(),
                                  ),
                                  Text(
                                      con.pelangganList
                                          .where((x) =>
                                              x.uuid ==
                                              controller.pelangganvalue.value)
                                          .first
                                          .namaPelanggan!,
                                      style: AppFont.regular_bold())
                                ],
                              ),
                            )
                    ],
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total :',
                      style: AppFont.regular_bold(),
                    ),
                    Text(
                      'Rp. ' + AppFormat().numFormat(controller.total.value),
                      style: AppFont.regular_bold(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        Container(
          //height: 80,
          //width: context.res_width,
          padding: EdgeInsets.symmetric(vertical: 12),
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
                            if (controller.keranjangv2.isEmpty) {
                              Get.showSnackbar(toast().bottom_snackbar_error(
                                  "Error", 'Keranjang kosong'));
                            } else {
                              Get.toNamed('/rincianpembayaran');
                            }
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
