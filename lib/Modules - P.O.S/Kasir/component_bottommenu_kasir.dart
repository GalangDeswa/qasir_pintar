import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:qasir_pintar/Config/config.dart';

import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir%20-%20Pembayaran/view_pembayaran.dart';
import 'package:qasir_pintar/Widget/widget.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../Controllers/CentralController.dart';
import '../../Widget/popscreen.dart';

class BottomMenuKasirv2 extends GetView<KasirController> {
  const BottomMenuKasirv2({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.42,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            children: [
              // Drag handle indicator
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Cart content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      height: 100,
                      color: Colors.cyan,
                    ),
                    Container(
                      height: 100,
                      color: Colors.green,
                    ),
                    // Add more cart items here
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomMenuKasir extends GetView<KasirController> {
  const BottomMenuKasir({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   height: 70,
        //   width: context.res_width,
        //   // color: Colors.blue,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       // IconButton(
        //       //   onPressed: () {
        //       //     showMaterialModalBottomSheet(
        //       //       context: context,
        //       //       builder: (context) => Container(
        //       //         height: context.res_height * 0.5,
        //       //         decoration: BoxDecoration(
        //       //             //color: Colors.greenAccent,
        //       //             borderRadius: BorderRadius.only(
        //       //                 topRight: Radius.circular(30),
        //       //                 topLeft: Radius.circular(30))),
        //       //         child: ListView.builder(
        //       //             itemCount: controller.produklist.length,
        //       //             itemBuilder: (contex, index) {
        //       //               var x = controller.produklist;
        //       //               return ListTile(
        //       //                 title: Text(x[index]),
        //       //                 subtitle: Text('x3'),
        //       //                 trailing: Text('!0.000'),
        //       //               );
        //       //             }),
        //       //       ),
        //       //     );
        //       //   },
        //       //   icon: FaIcon(
        //       //     FontAwesomeIcons.cartShopping,
        //       //     size: 20,
        //       //   ),
        //       //   color: AppColor.primary,
        //       // ),
        //       // Expanded(
        //       //   child: Row(
        //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //     children: [
        //       //       Expanded(
        //       //         child: TextButton(
        //       //             onPressed: () {}, child: Text('Pelanggan')),
        //       //       ),
        //       //       Expanded(
        //       //         child: TextButton(onPressed: () {}, child: Text('Kasir')),
        //       //       ),
        //       //       Expanded(
        //       //         child: TextButton(onPressed: () {}, child: Text('Jasa')),
        //       //       ),
        //       //     ],
        //       //   ),
        //       // )
        //     ],
        //   ),
        // ),
        Container(
          height: 60,
          //width: context.res_width,
          color: AppColor.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    //color: Colors.cyan,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.secondary,
                          ),
                          child: Text(
                            controller.totalitem.value.toString(),
                            style: AppFont.regular_white_bold(),
                          ),
                        ),
                        Text(
                          'Item',
                          style: AppFont.regular_white_bold(),
                        )
                      ],
                    ),
                  ),
                );
              }),
              Obx(() {
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    //color: Colors.purple,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        'Rp. ' +
                            AppFormat().numFormat(controller.subtotal.value),
                        textAlign: TextAlign.right,
                        style: AppFont.regular_white_bold()),
                  ),
                );
              }),
              Expanded(
                child: button_border_custom(
                    onPressed: () {
                      if (controller.keranjangv2.isEmpty) {
                        Get.showSnackbar(toast().bottom_snackbar_error(
                            'error', 'Keranjang Kosong'));
                        return;
                      }
                      Get.toNamed('/pembayaran', arguments: {
                        'keranjang': controller.keranjangv2,
                        'totalItem': controller.totalitem.value,
                        'subtotal': controller.subtotal.value,
                      });
                    },
                    child: Text('Keranjang'),
                    width: context.res_width),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomMenuMeja extends GetView<KasirController> {
  const BottomMenuMeja({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: context.res_width,
          //color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: button_border_custom(
                            margin: EdgeInsets.all(10),
                            onPressed: () {},
                            child: Text(
                              'Atur Meja',
                              style: AppFont.regular(),
                            ),
                            width: context.res_width)),
                    Expanded(
                        child: button_solid_custom(
                            onPressed: () {},
                            child: Text(
                              'Daftar Order',
                              style: AppFont.regular_white(),
                            ),
                            width: context.res_width)),
                    // Expanded(
                    //   child: Container(
                    //     child: Text('Jasa'),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

popaddprodukv2() {
  var con = Get.find<CentralProdukController>();
  Get.dialog(SheetViewport(
      child: Sheet(
    scrollConfiguration: SheetScrollConfiguration(),
    initialOffset: const SheetOffset(0.5),
    physics: BouncingSheetPhysics(),
    snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
    child: Material(
      color: Colors.transparent,
      child: Obx(() {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: AppPading.defaultBodyPadding(),
            height: Get.height * 0.5,
            child: Column(children: [Pembayaran()]));
      }),
    ),
  )));
}
