import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules/Kasir/controller_kasir.dart';

import '../../Widget/widget.dart';

class ProdukListKasir extends GetView<KasirController> {
  const ProdukListKasir({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Expanded(
            child: ListView.builder(
                itemCount: controller.produk.length,
                itemBuilder: (contex, index) {
                  var produk = controller.produk;
                  return ListTile(
                    onTap: () {
                      controller.addKeranjang(produk[index]);
                    },
                    title: Text(
                      produk[index].nama_produk!,
                    ),
                    trailing: Text(
                      overflow: TextOverflow.ellipsis,
                      'Stock : ' + produk[index].qty.toString(),
                      style: AppFont.small(),
                    ),
                    subtitle: Text('Rp ${NumberFormat('#,###').format(
                      produk[index].harga_jual_eceran!,
                    )}'),
                    //trailing: Text('Rp.10.000'),
                  );
                }),
          );
        })
      ],
    );
  }
}
