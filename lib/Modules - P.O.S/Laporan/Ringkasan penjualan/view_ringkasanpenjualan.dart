import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Laporan/Ringkasan%20penjualan/controller_ringkasanpenjualan.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';

class RingkasanPenjualan extends GetView<RingkasanPenjualanController> {
  const RingkasanPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Ringkasan Penjualan',
        NeedBottom: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operasional',
            textAlign: TextAlign.start,
          ),
          Container(
            height: 0.9,
            color: Colors.black,
            margin: EdgeInsets.only(bottom: 10),
            width: context.res_width,
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("Total Penjualan"),
                  subtitle: Text('Rp.1000'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("Laba kotor"),
                  subtitle: Text('Rp.100'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("Promo"),
                  subtitle: Text('Rp.1000'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("Komisi"),
                  subtitle: Text('Rp.100'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("promo"),
                  subtitle: Text('Rp.1000'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("transaksi"),
                  subtitle: Text('Rp.100'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
