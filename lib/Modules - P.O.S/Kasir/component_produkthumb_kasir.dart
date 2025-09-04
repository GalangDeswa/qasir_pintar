import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../Produk/Data produk/model_produk.dart';

class ProdukThumb extends GetView<KasirController> {
  const ProdukThumb({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();

    var conpaket = Get.find<CentralPaketController>();
    return Padding(
      padding: AppPading.defaultBodyPadding(),
      child: Container(
        // color: Colors.red,
        child: Obx(() {
          return controller.indexdisplay.value == 0
              ? Padding(
                  padding: AppPading.customListPadding(bottomPadding: 70),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisExtent: context.res_height / 4.0,
                          maxCrossAxisExtent: context.res_width / 2.0,
                          childAspectRatio: 1 / 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemCount: con.produk.length,
                      itemBuilder: (BuildContext context, index) {
                        var produk = con.produk;
                        return produk[index].tampilkan_di_produk == 1
                            ? GestureDetector(
                                onTap: () {
                                  //controller.addKeranjang(produk[index]);
                                  controller.addToCart(produk[index]);
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: produk[index]
                                                        .gambar_produk_utama !=
                                                    '' &&
                                                produk[index]
                                                        .gambar_produk_utama !=
                                                    null
                                            ? controller.isBase64Svg(
                                                    produk[index]
                                                        .gambar_produk_utama!)
                                                ? SvgPicture.memory(
                                                    base64Decode(produk[index]
                                                        .gambar_produk_utama!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.memory(
                                                    base64Decode(produk[index]
                                                        .gambar_produk_utama!),
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.asset(
                                                AppString.defaultImg,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          width: context.res_width,
                                          //height: context.res_height * 0.1,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                produk[index].nama_produk!,
                                                style: AppFont.regular_bold(),
                                              ),
                                              produk[index].diskon != 0.0
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          'Rp ${NumberFormat('#,###').format(
                                                            produk[index]
                                                                .harga_jual_eceran!,
                                                          )}',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize: 8),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Rp. ' +
                                                                  AppFormat()
                                                                      .numFormat(
                                                                    produk[index]
                                                                            .harga_jual_eceran! -
                                                                        produk[index]
                                                                            .diskon!,
                                                                  ),
                                                              style: AppFont
                                                                  .regular_bold(),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Text(
                                                                  (produk[index].diskon! /
                                                                              produk[index]
                                                                                  .harga_jual_eceran! *
                                                                              100)
                                                                          .toStringAsFixed(
                                                                              0) +
                                                                      '%',
                                                                  style: AppFont
                                                                      .small_white_bold()),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      'Rp ${NumberFormat('#,###').format(
                                                        produk[index]
                                                            .harga_jual_eceran!,
                                                      )}',
                                                      style: AppFont
                                                          .regular_bold(),
                                                    ),
                                              Obx(() {
                                                return Text(
                                                  produk[index].hitung_stok == 1
                                                      ? 'Stock : ' +
                                                          (produk[index].qty! -
                                                                  produk[index]
                                                                      .info_stok_habis!)
                                                              .toString()
                                                      : 'Nonstock',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppFont.small(),
                                                );
                                              }),
                                              StockDisplay(
                                                item: produk[index],
                                                isPackage: false,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.showSnackbar(toast()
                                      .bottom_snackbar_error(
                                          'Gagal', 'Produk tidak aktif'));
                                },
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: produk[index]
                                                        .gambar_produk_utama !=
                                                    '' &&
                                                produk[index]
                                                        .gambar_produk_utama !=
                                                    null
                                            ? controller.isBase64Svg(
                                                    produk[index]
                                                        .gambar_produk_utama!)
                                                ? SvgPicture.memory(
                                                    base64Decode(produk[index]
                                                        .gambar_produk_utama!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.memory(
                                                    base64Decode(produk[index]
                                                        .gambar_produk_utama!),
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.asset(
                                                AppString.defaultImg,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          width: context.res_width,
                                          //height: context.res_height * 0.1,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                produk[index].nama_produk!,
                                                style: AppFont.regular_bold(),
                                              ),
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                'Nonaktif',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }),
                )
              : Padding(
                  padding: AppPading.customListPadding(bottomPadding: 70),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisExtent: context.res_height / 4.0,
                          maxCrossAxisExtent: context.res_width / 2.0,
                          childAspectRatio: 1 / 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemCount: conpaket.paketproduk.length,
                      itemBuilder: (BuildContext context, index) {
                        var paketproduk = conpaket.paketproduk;
                        return paketproduk[index].tampilkan_di_paket == 1
                            ? GestureDetector(
                                onTap: () {
                                  //controller.addKeranjang(produk[index]);
                                  controller.addToCart(paketproduk[index]);
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child:
                                            paketproduk[index].gambar_utama !=
                                                        '' &&
                                                    paketproduk[index]
                                                            .gambar_utama !=
                                                        null
                                                ? controller.isBase64Svg(
                                                        paketproduk[index]
                                                            .gambar_utama!)
                                                    ? SvgPicture.memory(
                                                        base64Decode(
                                                            paketproduk[index]
                                                                .gambar_utama!),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.memory(
                                                        base64Decode(
                                                            paketproduk[index]
                                                                .gambar_utama!),
                                                        fit: BoxFit.cover,
                                                      )
                                                : Image.asset(
                                                    AppString.defaultImg,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          width: context.res_width,
                                          //height: context.res_height * 0.1,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                paketproduk[index].nama_paket!,
                                                style: AppFont.regular_bold(),
                                              ),
                                              paketproduk[index].diskon != 0.0
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          'Rp ${NumberFormat('#,###').format(
                                                            paketproduk[index]
                                                                .harga_jual_paket!,
                                                          )}',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize: 8),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Rp. ' +
                                                                  AppFormat()
                                                                      .numFormat(
                                                                    paketproduk[index]
                                                                            .harga_jual_paket! -
                                                                        paketproduk[index]
                                                                            .diskon!,
                                                                  ),
                                                              style: AppFont
                                                                  .regular_bold(),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Text(
                                                                  (paketproduk[index].diskon! /
                                                                              paketproduk[index]
                                                                                  .harga_jual_paket! *
                                                                              100)
                                                                          .toStringAsFixed(
                                                                              0) +
                                                                      '%',
                                                                  style: AppFont
                                                                      .small_white_bold()),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      'Rp ${NumberFormat('#,###').format(
                                                        paketproduk[index]
                                                            .harga_jual_paket!,
                                                      )}',
                                                      style: AppFont
                                                          .regular_bold(),
                                                    ),
                                              // Obx(() {
                                              //   return Text(
                                              //     paketproduk[index].hitung_stok == 1
                                              //         ? 'Stock : ' +
                                              //             (paketproduk[index].qty! -
                                              //                     produk[index]
                                              //                         .info_stok_habis!)
                                              //                 .toString()
                                              //         : 'Nonstock',
                                              //     overflow:
                                              //         TextOverflow.ellipsis,
                                              //     style: AppFont.small(),
                                              //   );
                                              // }),
                                              // StockDisplay(
                                              //   item: produk[index],
                                              //   isPackage: false,
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.showSnackbar(toast()
                                      .bottom_snackbar_error(
                                          'Gagal', 'Produk tidak aktif'));
                                },
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child:
                                            paketproduk[index].gambar_utama !=
                                                        '' &&
                                                    paketproduk[index]
                                                            .gambar_utama !=
                                                        null
                                                ? controller.isBase64Svg(
                                                        paketproduk[index]
                                                            .gambar_utama!)
                                                    ? SvgPicture.memory(
                                                        base64Decode(
                                                            paketproduk[index]
                                                                .gambar_utama!),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.memory(
                                                        base64Decode(
                                                            paketproduk[index]
                                                                .gambar_utama!),
                                                        fit: BoxFit.cover,
                                                      )
                                                : Image.asset(
                                                    AppString.defaultImg,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          width: context.res_width,
                                          //height: context.res_height * 0.1,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                paketproduk[index].nama_paket!,
                                                style: AppFont.regular_bold(),
                                              ),
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                'Nonaktif',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }),
                );
        }),
      ),
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
  static const List<MenuItem> firstItems = [Edit];
  static const List<MenuItem> secondItems = [Hapus];

  static const Edit =
      MenuItem(text: 'Edit', icon: Icons.edit, iconcolor: false);
  static const Hapus =
      MenuItem(text: 'Hapus', icon: Icons.delete, iconcolor: true);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color:
                item.iconcolor == false ? AppColor.primary : AppColor.warning,
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

  static void onChanged(BuildContext context, MenuItem item,
      KasirController controller, DataProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editisiproduk', arguments: data);
        break;
      case MenuItems.Hapus:
        print('kushfkusehfukisef');
        //Popscreen().deleteProduk(controller, data);
        break;
    }
  }
}

class StockDisplay extends GetView<KasirController> {
  final dynamic item;
  final bool isPackage;

  const StockDisplay({
    Key? key,
    required this.item,
    required this.isPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1) Package: no stock
    if (isPackage) {
      return Text(
        'Package',
        overflow: TextOverflow.ellipsis,
        style: AppFont.small(),
      );
    }

    // 2) Non‑stock items
    if (item.hitung_stok != 1) {
      return Container();
    }

    // 3) Trigger load once per UUID
    if (!controller.availStockMap.containsKey(item.uuid)) {
      controller.loadStock(item.uuid);
      print(controller.availStockMap);
    }

    // 4) Reactive UI
    return Obx(() {
      // still loading if no entry yet
      if (!controller.availStockMap.containsKey(item.uuid)) {
        print('availStockMap is Empty -->');
        return Text('Loading...', style: AppFont.small());
      }

      final availableStock = controller.availStockMap[item.uuid]!.value;
      final actualStock = item.qty ?? 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tersedia: $availableStock',
            overflow: TextOverflow.ellipsis,
            style: AppFont.small().copyWith(
              color: availableStock == 0
                  ? Colors.red
                  : availableStock < 5
                      ? Colors.orange
                      : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          // if (availableStock != actualStock)
          //   Text(
          //     'Total: $actualStock',
          //     overflow: TextOverflow.ellipsis,
          //     style: AppFont.small().copyWith(
          //       color: Colors.grey,
          //       fontSize: 10,
          //     ),
          //   ),
        ],
      );
    });
  }
}
