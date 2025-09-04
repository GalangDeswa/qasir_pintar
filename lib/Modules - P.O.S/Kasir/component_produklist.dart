import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';

import '../../Controllers/CentralController.dart';
import '../../Widget/widget.dart';
import 'component_produkthumb_kasir.dart';

class ProdukListKasir extends GetView<KasirController> {
  const ProdukListKasir({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();

    var conpaket = Get.find<CentralPaketController>();
    return Column(
      children: [
        Obx(() {
          return controller.indexdisplay.value == 0
              ? Expanded(
                  child: Padding(
                    padding: AppPading.customListPadding(bottomPadding: 90),
                    child: ListView.builder(
                        itemCount: con.produk.length,
                        itemBuilder: (contex, index) {
                          var produk = con.produk;
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    // Tap area
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.addToCart(produk[index]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(produk[index].nama_produk!,
                                                style: AppFont.regular_bold()),
                                            produk[index].diskon != 0.0
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Rp ${NumberFormat('#,###').format(produk[index].harga_jual_eceran!)}',
                                                        style: const TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 8),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Rp. ${AppFormat().numFormat(produk[index].harga_jual_eceran! - produk[index].diskon!)}',
                                                            style: AppFont
                                                                .regular_bold(),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            margin:
                                                                const EdgeInsets
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
                                                              '${(produk[index].diskon! / produk[index].harga_jual_eceran! * 100).toStringAsFixed(0)}%',
                                                              style: AppFont
                                                                  .small_white_bold(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    'Rp ${NumberFormat('#,###').format(produk[index].harga_jual_eceran!)}',
                                                    style:
                                                        AppFont.regular_bold(),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Right section (stock)
                                    SizedBox(
                                      width: 80, // limit width here
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            produk[index].hitung_stok == 1
                                                ? 'Stock : ${(produk[index].qty! - produk[index].info_stok_habis!)}'
                                                : 'Nonstock',
                                            overflow: TextOverflow.ellipsis,
                                            style: AppFont.small(),
                                          ),
                                          StockDisplay(
                                              item: produk[index],
                                              isPackage: false),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: AppPading.customListPadding(bottomPadding: 90),
                    child: ListView.builder(
                        itemCount: conpaket.paketproduk.length,
                        itemBuilder: (contex, index) {
                          var paket = conpaket.paketproduk;
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    // Tap area
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.addToCart(paket[index]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(paket[index].nama_paket!,
                                                style: AppFont.regular_bold()),
                                            paket[index].diskon != 0.0
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Rp ${NumberFormat('#,###').format(paket[index].harga_jual_paket!)}',
                                                        style: const TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 8),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Rp. ${AppFormat().numFormat(paket[index].harga_jual_paket! - paket[index].diskon!)}',
                                                            style: AppFont
                                                                .regular_bold(),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            margin:
                                                                const EdgeInsets
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
                                                              '${(paket[index].diskon! / paket[index].harga_jual_paket! * 100).toStringAsFixed(0)}%',
                                                              style: AppFont
                                                                  .small_white_bold(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    'Rp ${NumberFormat('#,###').format(paket[index].harga_jual_paket!)}',
                                                    style:
                                                        AppFont.regular_bold(),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Right section (stock)
                                    // SizedBox(
                                    //   width: 80, // limit width here
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    //     children: [
                                    //       Text(
                                    //         paket[index].hitung_stok == 1
                                    //             ? 'Stock : ${(paket[index].qty! - paket[index].info_stok_habis!)}'
                                    //             : 'Nonstock',
                                    //         overflow: TextOverflow.ellipsis,
                                    //         style: AppFont.small(),
                                    //       ),
                                    //       StockDisplay(
                                    //           item: produk[index],
                                    //           isPackage: false),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }),
                  ),
                );
        })
      ],
    );
  }
}
