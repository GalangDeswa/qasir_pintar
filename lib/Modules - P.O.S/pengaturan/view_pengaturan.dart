import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/pengaturan/controller_pengaturan.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Config/config.dart';
import '../../Middleware/customPageRole.dart';

class Pengaturan extends GetView<PengaturanController> {
  const Pengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRole(
      allowedRoles: ['ADMIN'],
      child: Scaffold(
        appBar: AppbarCustom(
          title: 'Pengaturan',
          NeedBottom: false,
        ),
        body: Padding(
          padding: AppPading.defaultBodyPadding(),
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Operasional',
                  style: AppFont.regular(),
                ),
              ),
              Padding(
                padding: AppPading.customBottomPadding(),
                child: Container(
                  height: 0.9,
                  color: Colors.black,
                  width: context.res_width,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/basemenuproduk');
                },
                leading: AppIcon(icon: FontAwesomeIcons.boxesPacking),
                title: Text('Produk dan kategori'),
              ),
              // ListTile(
              //   onTap: () {},
              //   leading: AppIcon(icon: FontAwesomeIcons.store),
              //   title: Text('Toko Online'),
              // ),
              // Padding(
              //   padding: AppPading.customBottomPadding(),
              //   child: ListTile(
              //     onTap: () {},
              //     leading: AppIcon(icon: FontAwesomeIcons.receipt),
              //     title: Text('Struk dan biaya'),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Akun',
                  style: AppFont.regular(),
                ),
              ),
              Container(
                height: 0.9,
                color: Colors.black,
                margin: EdgeInsets.only(bottom: 10),
                width: context.res_width,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/user');
                },
                leading: AppIcon(icon: FontAwesomeIcons.user),
                title: Text('User'),
              ),
              // ListTile(
              //   onTap: () {},
              //   leading: AppIcon(icon: FontAwesomeIcons.store),
              //   title: Text('Toko'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
