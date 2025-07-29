import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Laporan/Laporan%20menu/controller_laporanmenu.dart';
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
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Text(
              'Operasional',
              style: AppFont.regular(),
            ),
            Container(
              height: 0.9,
              color: Colors.black,
              margin: EdgeInsets.only(bottom: 10, top: 5),
              width: context.res_width,
            ),
            ListTile(
              onTap: () {
                Get.toNamed('/ringkasanpenjualan');
              },
              leading: Icon(Icons.account_box),
              title: Text(
                'Umum',
                style: AppFont.regular(),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.account_box),
              title: Text(
                'Penjualan',
                style: AppFont.regular(),
              ),
            ),
            ListTile(
              onTap: () {
                Get.toNamed('/laporankasir');
              },
              leading: Icon(Icons.account_box),
              title: Text(
                'Beban',
                style: AppFont.regular(),
              ),
            ),
            ListTile(
              onTap: () {
                Get.toNamed('/kaskasir');
              },
              leading: Icon(Icons.account_box),
              title: Text(
                'Reversal',
                style: AppFont.regular(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
