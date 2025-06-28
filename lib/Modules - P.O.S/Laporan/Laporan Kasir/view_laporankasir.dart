import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Laporan/Laporan%20Kasir/controller_laporankasir.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';

class LaporanKasir extends GetView<LaporanKasirController> {
  const LaporanKasir({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Laporan kasir',
        NeedBottom: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  title: Text("10/12/2077"),
                ),
              ),
              Expanded(child: FaIcon(FontAwesomeIcons.calendar)),
            ],
          ),
          Container(
            height: 0.9,
            color: Colors.black,
            margin: EdgeInsets.only(bottom: 10),
            width: context.res_width,
          ),
          SwitchListTile(
              title: Text('Tampilkan kasir yang belum tutup'),
              value: controller.val.value,
              onChanged: (x) {
                controller.val.value = x;
              }),
          Container(
            height: 50,
            color: Colors.grey,
            margin: EdgeInsets.only(bottom: 10),
            width: context.res_width,
            padding: EdgeInsets.all(15),
            child: Text('10/12/20277'),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Joko'),
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("Buka kasir"),
                  subtitle: Text('09:00'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("Tutup kasir"),
                  subtitle: Text('10:00'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("Saldo awal"),
                  subtitle: Text('Rp.1000'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("Saldo akhir"),
                  subtitle: Text('10:00'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: button_solid_custom(
                  child: Text('Ringkasan'),
                  width: 300,
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: button_border_custom(
                  child: Text('tutup kasir'),
                  width: 300,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
