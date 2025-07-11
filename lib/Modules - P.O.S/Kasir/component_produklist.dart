import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';

import '../../Controllers/CentralController.dart';
import '../../Widget/widget.dart';

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
                              trailing: Text(
                                produk[index].hitung_stok == 1
                                    ? 'Stock : ' + produk[index].qty.toString()
                                    : 'Nonstock',
                                overflow: TextOverflow.ellipsis,
                                style: AppFont.small(),
                              ),
                              subtitle: Text(
                                  style: AppFont.regular(),
                                  'Rp ${NumberFormat('#,###').format(
                                    produk[index].harga_jual_eceran!,
                                  )}'),
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
                              subtitle: Text(
                                  style: AppFont.regular(),
                                  'Rp ${NumberFormat('#,###').format(
                                    paketproduk[index].harga_jual_paket!,
                                  )}'),
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
