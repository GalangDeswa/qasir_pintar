import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20Pelanggan/view_pelanggan.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/view_listdatadettailproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/view_listproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/view_thumbproduk.dart';
import 'package:qasir_pintar/Modules/Produk/controller_basemenuproduk.dart';

import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../../Home/view_home.dart';
import '../Produk/component_kelompokproduk.dart';
import '../Produk/model_kategoriproduk.dart';

class ViewBaseDataproduk extends GetView<BaseMenuProdukController> {
  const ViewBaseDataproduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60, padding: EdgeInsets.all(15),
          //color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(FontAwesomeIcons.magnifyingGlass),
              ),
              Expanded(
                child: TextField(
                  onChanged: (val) {
                    print(val);
                    controller.searchProdukLocal(id_toko: controller.id_toko);
                  },
                  controller: controller.searchproduk.value,
                  decoration: InputDecoration(hintText: 'Pencarian'),
                ),
              ),
              Obx(() {
                return controller.isAscending == true
                    ? Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: IconButton(
                          onPressed: () async {
                            print('sort...');
                            controller.isAscending.value =
                                !controller.isAscending.value;
                            await controller.fetchProdukLocal(
                                id_toko: controller.id_toko,
                                ascending: controller.isAscending.value);
                          },
                          icon: FaIcon(FontAwesomeIcons.sortAlphaDown),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: IconButton(
                          onPressed: () async {
                            print('sort...');
                            controller.isAscending.value =
                                !controller.isAscending.value;
                            await controller.fetchProdukLocal(
                                id_toko: controller.id_toko,
                                ascending: controller.isAscending.value);
                          },
                          icon: FaIcon(FontAwesomeIcons.sortAlphaUp),
                        ),
                      );
              }),
              Obx(() {
                return controller.thumb.value == true
                    ? IconButton(
                        onPressed: () {
                          controller.thumb.value = !controller.thumb.value;
                        },
                        icon: FaIcon(FontAwesomeIcons.image))
                    : IconButton(
                        onPressed: () {
                          controller.thumb.value = !controller.thumb.value;
                        },
                        icon: FaIcon(FontAwesomeIcons.list));
              })
            ],
          ),
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: button_border_custom(
        //           margin: EdgeInsets.all(15),
        //           onPressed: () {
        //             Get.toNamed('/tambahprodukv3');
        //           },
        //           child: Text('Tambah Produk'),
        //           width: context.res_width),
        //     ),
        //     // Expanded(
        //     //   child: button_border_custom(
        //     //       margin: EdgeInsets.all(15),
        //     //       onPressed: () {
        //     //         Get.toNamed('/penerimaan_produk');
        //     //       },
        //     //       child: Text('Tambah Stock'),
        //     //       width: context.res_width),
        //     // ),
        //   ],
        // ),
        SizedBox(
          height: 20,
        ),
        Obx(() {
          return controller.thumb.value == true
              ? Expanded(child: ThumbProduk())
              : Expanded(child: ListProduk());
        }),
        //Expanded(child: ThumbProduk()),
      ],
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
    this.iconcolor,
  });

  final String text;
  final IconData icon;
  final bool? iconcolor;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [Edit];
  static const List<MenuItem> secondItems = [Hapus];

  static const Edit =
      MenuItem(text: 'Edit', icon: Icons.edit, iconcolor: false);
  static const Hapus =
      MenuItem(text: 'Hapus', icon: Icons.delete, iconcolor: true);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color:
                item.iconcolor == false ? AppColor.primary : AppColor.warning,
            size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: AppFont.regular(),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item,
      BaseMenuProdukController controller, DataProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editisiproduk', arguments: data);
        break;
      case MenuItems.Hapus:
        print('kushfkusehfukisef');
        Popscreen().deleteProduk(controller, data);
        break;
    }
  }
}
