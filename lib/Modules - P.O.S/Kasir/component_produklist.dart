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
          return controller.indexdisplay == 0
              ? Expanded(
                  child: ListView.builder(
                      itemCount: con.produk.length,
                      itemBuilder: (contex, index) {
                        var produk = con.produk;
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                controller.addToCart(produk[index]);
                              },
                              title: Text(
                                produk[index].nama_produk!,
                                style: AppFont.regular_bold(),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    produk[index].hitung_stok == 1
                                        ? 'Stock : ' +
                                            produk[index].qty.toString()
                                        : 'Nonstock',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFont.small(),
                                  ),
                                  StockDisplay(
                                    item: produk[index],
                                    isPackage: false,
                                  )
                                ],
                              ),
                              subtitle: produk[index].diskon != 0.0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          'Rp ${NumberFormat('#,###').format(
                                            produk[index].harga_jual_eceran!,
                                          )}',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 8),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rp. ' +
                                                  AppFormat().numFormat(
                                                    produk[index]
                                                            .harga_jual_eceran! -
                                                        produk[index].diskon!,
                                                  ),
                                              style: AppFont.small(),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.only(left: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                  (produk[index].diskon! /
                                                              produk[index]
                                                                  .harga_jual_eceran! *
                                                              100)
                                                          .toStringAsFixed(0) +
                                                      '%',
                                                  style: AppFont.small_white()),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  : Text(
                                      overflow: TextOverflow.ellipsis,
                                      'Rp ${NumberFormat('#,###').format(
                                        produk[index].harga_jual_eceran!,
                                      )}',
                                      style: AppFont.small(),
                                    ),
                              //trailing: Text('Rp.10.000'),
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.black,
                            )
                          ],
                        );
                      }),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: conpaket.paketproduk.length,
                      itemBuilder: (contex, index) {
                        var paketproduk = conpaket.paketproduk;
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                controller.addToCart(paketproduk[index]);
                              },
                              title: Text(
                                paketproduk[index].nama_paket!,
                                style: AppFont.regular_bold(),
                              ),
                              // trailing: Text(
                              //   paketproduk[index].hitung_stok == 1
                              //       ? 'Stock : ' + produk[index].qty.toString()
                              //       : 'Nonstock',
                              //   overflow: TextOverflow.ellipsis,
                              //   style: AppFont.small(),
                              // ),
                              subtitle: paketproduk[index].diskon != 0.0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          'Rp ${NumberFormat('#,###').format(
                                            paketproduk[index]
                                                .harga_jual_paket!,
                                          )}',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 8),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rp. ' +
                                                  AppFormat().numFormat(
                                                    paketproduk[index]
                                                            .harga_jual_paket! -
                                                        paketproduk[index]
                                                            .diskon!,
                                                  ),
                                              style: AppFont.small(),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.only(left: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                  (paketproduk[index].diskon! /
                                                              paketproduk[index]
                                                                  .harga_jual_paket! *
                                                              100)
                                                          .toStringAsFixed(0) +
                                                      '%',
                                                  style: AppFont.small_white()),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  : Text(
                                      overflow: TextOverflow.ellipsis,
                                      'Rp ${NumberFormat('#,###').format(
                                        paketproduk[index].harga_jual_paket!,
                                      )}',
                                      style: AppFont.small(),
                                    ),
                              //trailing: Text('Rp.10.000'),
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.black,
                            )
                          ],
                        );
                      }),
                );
        })
      ],
    );
  }
}
