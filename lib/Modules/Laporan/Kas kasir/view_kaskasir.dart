import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Laporan/Kas%20kasir/controller_kaskasir.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';

class KasKasir extends GetView<KasKasirController> {
  const KasKasir({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Kas kasir',
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
                  title: Text("pemasukan"),
                  subtitle: Text('Rp.1000'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("pengeluaran"),
                  subtitle: Text('Rp.100'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("Total kas kasir"),
                  subtitle: Text('Rp.1000'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("total penjualan"),
                  subtitle: Text('Rp.100'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("total Refund"),
                  subtitle: Text('Rp.1000'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
