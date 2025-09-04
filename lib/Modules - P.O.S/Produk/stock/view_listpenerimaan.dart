import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/controller_basemenustock.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/model_penerimaan.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Produk/stock/view_produkAPIlist.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Produk/stock/view_produkAPIthumb.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../../Widget/widget.dart';

class Listpenerimaan extends GetView<BasemenuStockController> {
  const Listpenerimaan({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPenerimaanController>();
    return Column(
      children: [
        // Obx(() {
        //   return customDatesearch(
        //       onReset: () {
        //         print('fetch ulang');
        //         con.fetchPenerimaanLocal(id_toko: con.id_toko);
        //       },
        //       sortValue: con.isAsc.value,
        //       onSortPressed: () {
        //         con.toggleSortPenerimaan();
        //       },
        //       onOkTap: () {
        //         print('custom dates');
        //         con.searchPenerimaanByDateLocal(
        //             id_toko: con.id_toko,
        //             startDate: con.date1.toString(),
        //             endDate: con.date2.toString());
        //       },
        //       textController: con.pickdate.value,
        //       dates: con.dates,
        //       onDateChanged: (dates) {
        //         var list = <String>[];
        //         var start = dates.first;
        //         final end = dates.last;
        //         con.pickdate.value.text = (con.dateformat.format(start!) +
        //             ' - ' +
        //             con.dateformat.format(end!));
        //
        //         con.date1 = start;
        //         con.date2 = end;
        //         print(con.date1);
        //         print(con.date2);
        //       });
        // }),
        // SizedBox(
        //   height: 20,
        // ),
        // Container(
        //   //height: 100,
        //   //color: Colors.blue,
        //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [Text('Riwayat Penerimaan'), Text('Aksi')],
        //   ),
        // ),
        // Container(
        //   height: 0.9,
        //   color: Colors.black,
        //   width: context.res_width,
        //   margin: EdgeInsets.only(bottom: 10),
        // ),

        Padding(
          padding: AppPading.defaultBodyPadding(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 20, top: 20),
              //     child: SizedBox(
              //       height: 40,
              //       child: Obx(() {
              //         return TextField(
              //           onChanged: (val) {
              //             print(val);
              //             if (controller.indexdisplay.value == 0) {
              //               con.searchProdukLocal(
              //                   id_toko: con.id_toko, search: val);
              //             } else {
              //               conpaket.searchPaketLocal(
              //                   id_toko: con.id_toko, search: val);
              //             }
              //           },
              //           controller: con.searchproduk.value,
              //           decoration: InputDecoration(
              //               contentPadding:
              //               EdgeInsets.symmetric(horizontal: 10),
              //               hintText: 'Pencarian',
              //               hintStyle: AppFont.regular(),
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10))),
              //         );
              //       }),
              //     ),
              //   ),
              // ),
              Expanded(
                  child: Text(
                'List produk',
                style: AppFont.regular(),
              )),
              IconButton(
                  onPressed: () {
                    con.fecthProdukAPI();
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 20,
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: DropdownButton2(
                  hint: Text('Pilih tampilan'),
                  customButton: Obx(() {
                    return controller.tampilan.value == 'list'
                        ? FaIcon(
                            FontAwesomeIcons.list,
                            // color: Colors.white,
                            size: 20,
                          )
                        : FaIcon(
                            FontAwesomeIcons.image,
                            // color: Colors.white,
                            size: 20,
                          );
                  }),
                  items: [
                    ...MenuItems.thirdItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                        value: item,
                        child: MenuItems.buildItem(item),
                      ),
                    ),
                    const DropdownMenuItem<Divider>(
                        enabled: false, child: Divider()),
                    ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                        value: item,
                        child: MenuItems.buildItem(item),
                      ),
                    ),
                    // const DropdownMenuItem<Divider>(
                    //     enabled: false, child: Divider()),
                    // ...MenuItems.secondItems.map(
                    //   (item) => DropdownMenuItem<MenuItem>(
                    //     value: item,
                    //     child: MenuItems.buildItem(item),
                    //   ),
                    // ),
                  ],
                  onChanged: (value) {
                    MenuItems.onChanged(
                        context, value! as MenuItem, controller);
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    offset: const Offset(0, 8),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    height: 35,
                    // customHeights: [
                    //   ...List<double>.filled(MenuItems.firstItems.length, 48),
                    //   1,
                    //   ...List<double>.filled(
                    //       MenuItems.secondItems.length, 48),
                    //   ...List<double>.filled(MenuItems.thirdItems.length, 48),
                    //   1,
                    // ],
                    padding: const EdgeInsets.only(left: 16, right: 16),
                  ),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.only(right: 10),
              //   child: Stack(
              //     children: [
              //       IconButton(
              //         onPressed: () {
              //           // controller.openSavedCart();
              //         },
              //         icon: Icon(
              //           FontAwesomeIcons.cartShopping,
              //           // color: AppColor.primary,
              //         ),
              //       ),
              //       Positioned(
              //         right: 3,
              //         child: Container(
              //           padding: EdgeInsets.all(6),
              //           decoration: BoxDecoration(
              //               shape: BoxShape.circle, color: AppColor.accent),
              //           child: Obx(() {
              //             return Text(
              //               controller.savedCart.length.toString(),
              //               style: AppFont.regular_bold(),
              //             );
              //           }),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            return Stack(
              children: [
                //TODO : UI penerimaan
                Column(
                  children: [
                    controller.tampilan.value == 'list'
                        ? Expanded(child: ProdukAPIList())
                        : Expanded(child: ProdukAPIThumb()),
                  ],
                ),
                CartSheet()
              ],
            );
          }),
        )
      ],
    );
  }
}

class CartSheet extends GetView<BasemenuStockController> {
  const CartSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SheetViewport(
        child: Sheet(
      controller: controller.kasirsheet.value,
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
                                return controller.totalItem.value == 0
                                    ? Text('Keranjang kosong')
                                    : Text(
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
                                  // controller.editDiskonKasir(
                                  //     controller, controller.promolistvalue);
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
                                  // controller.popListPromo();
                                },
                                icon: Icon(
                                  FontAwesomeIcons.tag,
                                  color: controller.namaPromo.value != ''
                                      ? AppColor.primary
                                      : Colors.grey,
                                  size: 15,
                                ));
                          }),
                          Obx(() {
                            return IconButton(
                                onPressed: () {
                                  // Get.toNamed('/basemenupelanggan');
                                  //controller.popListPelanggan();
                                },
                                icon: controller.pelangganvalue.value == ''
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
                            return controller.keranjang.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.keranjang.length,
                                    itemBuilder: (context, index) {
                                      final keranjang = controller.keranjang;

                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  title: Text(
                                                    keranjang[index].name!,
                                                    style:
                                                        AppFont.regular_bold(),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              style:
                                                                  AppFont.small(
                                                                      fontSize:
                                                                          11),
                                                              'Rp. ' +
                                                                  AppFormat().numFormat(
                                                                      keranjang[
                                                                              index]
                                                                          .fund!)),
                                                          Text(
                                                            ' X ' +
                                                                keranjang[index]
                                                                    .qty
                                                                    .toString(),
                                                            style:
                                                                AppFont.small(),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          style: AppFont
                                                              .small_bold(),
                                                          'Rp. ' +
                                                              AppFormat().numFormat(
                                                                  (keranjang[index]
                                                                          .fund! *
                                                                      keranjang[
                                                                              index]
                                                                          .qty))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Container(
                                              //   height: 35,
                                              //   width: 35,
                                              //   decoration: BoxDecoration(
                                              //       shape: BoxShape.circle,
                                              //       color: AppColor.primary),
                                              //   child: IconButton(
                                              //       onPressed: () {
                                              //         // controller
                                              //         //     .decrementItem(index);
                                              //       },
                                              //       icon: Icon(
                                              //         Icons.edit,
                                              //         size: 15,
                                              //         color: Colors.white,
                                              //       )),
                                              // ),

                                              IconButton(
                                                  onPressed: () {
                                                    controller.editqty(
                                                        keranjang[index]);
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 18,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    controller
                                                        .deleteCart(index);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_forever,
                                                    size: 18,
                                                    color: AppColor.warning,
                                                  )),
                                              // IconButton(
                                              //     onPressed: () {
                                              //        controller
                                              //            .decrementItem(index);
                                              //     },
                                              //     icon: Icon(
                                              //       Icons.remove,
                                              //       size: 15,
                                              //     )),
                                              // IconButton(
                                              //     onPressed: () {
                                              //       print('add from cart-->');
                                              //        // controller.addKeranjang(
                                              //        //    keranjang[index]);
                                              //     },
                                              //     icon: Icon(
                                              //       Icons.add,
                                              //       size: 15,
                                              //     ))
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
                  BottomMenuPenerimaan(),
                ],
              ))),
    ));
  }
}

class BottomMenuPenerimaan extends GetView<BasemenuStockController> {
  const BottomMenuPenerimaan({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPelangganController>();
    var conpromo = Get.find<CentralPromoController>();
    return Column(
      children: [
        Obx(() {
          return Container(
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            // color: Colors.red,
            padding: AppPading.defaultBodyPadding(),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('Kasir : ' + controller.namaKaryawan.value,
                //         style: AppFont.regular()),
                //     IconButton(
                //         onPressed: () {
                //           controller.popLoginKaryawanUlang();
                //         },
                //         icon: Icon(
                //           FontAwesomeIcons.userGear,
                //           color: AppColor.primary,
                //           size: 15,
                //         ))
                //   ],
                // ),
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
                                      conpromo.promo
                                                  .where((nilai) =>
                                                      nilai.uuid ==
                                                      controller.promolistvalue)
                                                  .first
                                                  .promoNominal !=
                                              0.0
                                          ? 'Rp. ' +
                                              AppFormat().numFormat(conpromo
                                                  .promo
                                                  .where((promo) =>
                                                      promo.uuid ==
                                                      controller.promolistvalue
                                                          .toString())
                                                  .first
                                                  .promoNominal) +
                                              '  ' +
                                              '(' +
                                              conpromo.promo
                                                  .where((promo) =>
                                                      promo.uuid ==
                                                      controller.promolistvalue
                                                          .toString())
                                                  .first
                                                  .namaPromo! +
                                              ')'
                                          : '% ' +
                                              conpromo.promo
                                                  .where((promo) =>
                                                      promo.uuid ==
                                                      controller.promolistvalue
                                                          .toString())
                                                  .first
                                                  .promoPersen
                                                  .toString()! +
                                              '  '
                                                  '(' +
                                              conpromo.promo
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
                            ),
                      Padding(
                        padding: AppPading.customBottomPaddingSmall(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pajak :',
                              style: AppFont.regular(),
                            ),
                            Text(
                              'Rp. ' +
                                  AppFormat()
                                      .numFormat(controller.totalTax.value),
                              style: AppFont.regular_bold(),
                            ),
                          ],
                        ),
                      ),
                      Divider()
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
                    button_border_custom(
                        margin: EdgeInsets.all(20),
                        onPressed: () {
                          if (controller.keranjangv2.isEmpty) {
                            Get.showSnackbar(toast().bottom_snackbar_error(
                                "Error", 'Keranjang kosong'));
                          } else {
                            controller.saveCartv2();
                            controller.kasirsheet.value
                                .animateTo(const SheetOffset(0.1));
                          }
                        },
                        child: Text('Simpan'),
                        width: context.width * 0.3),
                    Expanded(
                      child: button_border_custom(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            if (controller.keranjang.isEmpty) {
                              Get.showSnackbar(toast().bottom_snackbar_error(
                                  "Error", 'Keranjang kosong'));
                            } else {
                              Get.toNamed('/rincianpembayaranpemesanan');
                            }
                          },
                          child: Text('Pesan'),
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

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
    this.iconcolor,
  });

  final String text;
  final IconData icon;
  final bool? iconcolor;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [list];
  static const List<MenuItem> secondItems = [meja];
  static const List<MenuItem> thirdItems = [thumb];

  static const list =
      MenuItem(text: 'List', icon: Icons.edit, iconcolor: false);
  static const meja =
      MenuItem(text: 'Meja', icon: Icons.table_bar, iconcolor: true);
  static const thumb = MenuItem(
      text: 'Thumbnail', icon: Icons.picture_in_picture, iconcolor: true);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color:
                item.iconcolor == false ? AppColor.primary : AppColor.secondary,
            size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: AppFont.regular(),
          ),
        ),
      ],
    );
  }

  static void onChanged(
      BuildContext context, MenuItem item, BasemenuStockController controller) {
    switch (item) {
      case MenuItems.list:
        print('edit');
        controller.tampilan.value = 'list';
        break;
      case MenuItems.meja:
        controller.tampilan.value = 'meja';
        break;
      case MenuItems.thumb:
        controller.tampilan.value = 'thumb';
        break;
    }
  }
}
