import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/component_bottommenu_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/component_meja_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/component_produklist.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/component_produkthumb_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/component_uppermenu_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir%20-%20Pembayaran/controller_pembayaran.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../Config/config.dart';
import '../Kasir - Pembayaran/component_Bottommenu_pembayaran.dart';
import '../Kasir - Pembayaran/view_pembayaran.dart';

class Kasir extends GetView<KasirController> {
  const Kasir({super.key});

  @override
  Widget build(BuildContext context) {
    final isMeja = controller.tampilan.value == 'meja';
    return Obx(() {
      return Stack(
        children: [
          Column(
            children: [
              controller.tampilan.value == 'meja'
                  ? UpperMenuMeja()
                  : UpperMenuKasir(),
              controller.tampilan.value == 'list'
                  ? Expanded(child: ProdukListKasir())
                  : controller.tampilan.value == 'meja'
                      ? Expanded(child: Meja())
                      : Expanded(child: ProdukThumb()),
            ],
          ),
          if (!isMeja) CartSheet()
        ],
      );
    });
  }
}

class CartSheet extends GetView<KasirController> {
  const CartSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.1),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.1), SheetOffset(1)]),
      child: Material(
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(149, 157, 165, 0.2),
                        blurRadius: 24,
                        spreadRadius: 0),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      color: Colors.grey[300],
                      width: 50,
                      margin: EdgeInsets.only(top: 10),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: AppPading.defaultBodyPadding(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() {
                                return Text(
                                  'Total item : ' +
                                      controller.totalItem.value
                                          .toString()
                                          .replaceAll('-', ''),
                                  style: AppFont.regular_bold(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Obx(() {
                            return IconButton(
                                onPressed: () {
                                  controller.editDiskonKasir(
                                      controller, controller.promolistvalue);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.percent,
                                  color: controller.displaydiskon.value == 0.0
                                      ? Colors.grey
                                      : AppColor.primary,
                                  size: 15,
                                ));
                          }),
                          Obx(() {
                            return IconButton(
                                onPressed: () {
                                  print('pop promo');
                                  controller.popListPromo();
                                },
                                icon: Icon(
                                  FontAwesomeIcons.tag,
                                  color: controller.namaPromo != ''
                                      ? AppColor.primary
                                      : Colors.grey,
                                  size: 15,
                                ));
                          }),
                          Obx(() {
                            return IconButton(
                                onPressed: () {
                                  // Get.toNamed('/basemenupelanggan');
                                  controller.popListPelanggan();
                                },
                                icon: controller.pelangganvalue == ''
                                    ? Icon(
                                        FontAwesomeIcons.userLarge,
                                        color: Colors.grey,
                                        size: 15,
                                      )
                                    : Icon(
                                        FontAwesomeIcons.userLarge,
                                        color: AppColor.primary,
                                        size: 15,
                                      ));
                          }),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Obx(() {
                            return controller.keranjangv2.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.keranjangv2.length,
                                    itemBuilder: (context, index) {
                                      final keranjang = controller.keranjangv2;

                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  title: Text(
                                                    keranjang[index].isPaket ==
                                                            true
                                                        ? keranjang[index]
                                                            .namaPaket!
                                                        : keranjang[index]
                                                            .namaProduk!,
                                                    style:
                                                        AppFont.regular_bold(),
                                                  ),
                                                  trailing: Text(
                                                      style: AppFont.small(),
                                                      keranjang[index]
                                                                  .isPaket ==
                                                              false
                                                          ? 'Rp. ' +
                                                              AppFormat().numFormat((keranjang[
                                                                          index]
                                                                      .hargaEceran! *
                                                                  keranjang[
                                                                          index]
                                                                      .qty))
                                                          : 'Rp. ' +
                                                              AppFormat().numFormat((keranjang[
                                                                          index]
                                                                      .hargaPaket! *
                                                                  keranjang[
                                                                          index]
                                                                      .qty))),
                                                  subtitle: Row(
                                                    children: [
                                                      Text(
                                                          style:
                                                              AppFont.small(),
                                                          keranjang[index]
                                                                      .isPaket ==
                                                                  false
                                                              ? 'Rp. ' +
                                                                  AppFormat().numFormat(
                                                                      keranjang[
                                                                              index]
                                                                          .hargaEceran!)
                                                              : 'Rp. ' +
                                                                  AppFormat().numFormat(
                                                                      keranjang[
                                                                              index]
                                                                          .hargaPaket!)),
                                                      Text(
                                                        ' X ' +
                                                            keranjang[index]
                                                                .qty
                                                                .toString(),
                                                        style: AppFont.small(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    print('min-------------->');
                                                    keranjang[index].qty--;

                                                    // Get the individual product values to subtract
                                                    final hargaBeliPerItem =
                                                        keranjang[index]
                                                                    .isPaket ==
                                                                false
                                                            ? keranjang[index]
                                                                .hargaEceran!
                                                            : keranjang[index]
                                                                .hargaPaket;
                                                    final hppPerItem =
                                                        keranjang[index].hpp!;

                                                    // Subtract from totals
                                                    controller.subtotal.value -=
                                                        hargaBeliPerItem!;

                                                    var sumqty = keranjang.fold(
                                                        0,
                                                        (sum, item) =>
                                                            sum -
                                                            (item.qty ?? 0));
                                                    controller.totalItem.value =
                                                        sumqty;

                                                    if (keranjang[index].qty <=
                                                        0) {
                                                      var x = keranjang
                                                          .removeAt(index);
                                                      controller
                                                          .deletedDetailIds
                                                          .add(x.uuid!);
                                                      controller.keranjangv2
                                                          .refresh();
                                                    }
                                                    controller
                                                        .hitungPembayaran();
                                                    controller.keranjangv2
                                                        .refresh();
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    print('add from cart-->');
                                                    controller.addToCart(
                                                        keranjang[index]);
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 15,
                                                  ))
                                            ],
                                          ),
                                          Divider()
                                        ],
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                    'Keranjang kosong',
                                    style: AppFont.regular(),
                                  ));
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Fixed bottom menu
                  BottomMenuPembayaran(),
                ],
              ))),
    ));
  }
}
