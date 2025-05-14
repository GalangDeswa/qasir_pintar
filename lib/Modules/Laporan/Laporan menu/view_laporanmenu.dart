import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Laporan/Laporan%20menu/controller_laporanmenu.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';

class LaporanMenu extends GetView<LaporanMenuController> {
  const LaporanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Laporan',
        NeedBottom: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text('Operasional'),
          Container(
            height: 0.9,
            color: Colors.black,
            margin: EdgeInsets.only(bottom: 10),
            width: context.res_width,
          ),
          ListTile(
            onTap: () {
              Get.toNamed('/ringkasanpenjualan');
            },
            leading: Icon(Icons.account_box),
            title: Text('Ringkasan penjualan'),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.account_box),
            title: Text('10 laporan teratas'),
          ),
          ListTile(
            onTap: () {
              Get.toNamed('/laporankasir');
            },
            leading: Icon(Icons.account_box),
            title: Text('Kasir'),
          ),
          ListTile(
            onTap: () {
              Get.toNamed('/kaskasir');
            },
            leading: Icon(Icons.account_box),
            title: Text('Kas Kasir'),
          ),
        ],
      ),
    );
  }
}
