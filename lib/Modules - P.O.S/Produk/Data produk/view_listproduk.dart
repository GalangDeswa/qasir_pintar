import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/controller_basemenuproduk.dart';

import '../../../Config/config.dart';
import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../Produk/model_kategoriproduk.dart';

class ListProduk extends GetView<BaseMenuProdukController> {
  const ListProduk({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daftar Produk'),
              Text('Aksi'),
            ],
          ),
        ),
        Container(
          height: 0.9,
          color: Colors.black,
          width: context.res_width,
          margin: EdgeInsets.only(bottom: 10),
        ),
        Obx(() {
          return Expanded(
            child: con.produk.isNotEmpty
                ? Padding(
                    padding: AppPading.customListPadding(),
                    child: ListView.builder(
                      itemCount: con.produk.length,
                      itemBuilder: (context, index) {
                        final produk = con.produk;

                        return custom_list_produk(
                          controller: con,
                          gestureroute: '/isiproduk',
                          gestureArgument: produk[index],
                          isDeleted: produk[index].tampilkan_di_produk == 1
                              ? false
                              : true,
                          usingGambar: true,
                          title: produk[index].nama_produk!,
                          gambar: produk[index].gambar_produk_utama,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produk[index].namaKategori!,
                                style: AppFont.small(),
                              ),
                              produk[index].diskon != 0.0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rp. ' +
                                              AppFormat().numFormat(
                                                produk[index]
                                                    .harga_jual_eceran!,
                                              ),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 8),
                                        ),
                                        SizedBox(
                                          width: 5,
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
                                                      BorderRadius.circular(3)),
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
                                      'Rp. ' +
                                          AppFormat().numFormat(
                                            produk[index].harga_jual_eceran!,
                                          ),
                                      style: AppFont.small(),
                                    ),
                              Text(
                                produk[index].hitung_stok == 1
                                    ? 'Qty :' + produk[index].qty.toString()
                                    : 'Nonstock',
                                style: AppFont.small(),
                              ),
                            ],
                          ),
                          trailing: produk[index].tampilkan_di_produk == 1
                              ? customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/editisiproduk',
                                            arguments: produk[index]);
                                        break;
                                      case 'Hapus':
                                        Popscreen().deleteProduk(
                                            controller, produk[index]);
                                    }
                                  },
                                  dropdownColor: Colors.white, // Custom color
                                  customButton: const Icon(Icons.menu),
                                  items: [
                                      {
                                        'title': 'Ubah',
                                        'icon': Icons.edit,
                                        'color': AppColor.primary
                                      },
                                      {'divider': true},
                                      {
                                        'title': 'Hapus',
                                        'icon': Icons.delete,
                                        'color': AppColor.warning
                                      },
                                    ])
                              : customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/editisiproduk',
                                            arguments: produk[index]);
                                        break;
                                      // case 'Hapus':
                                      //   Popscreen()
                                      //       .deleteProduk(controller, produk[index]);
                                    }
                                  },
                                  dropdownColor: Colors.white, // Custom color
                                  customButton: const Icon(Icons.menu),
                                  items: [
                                      {
                                        'title': 'Ubah',
                                        'icon': Icons.edit,
                                        'color': AppColor.primary
                                      },
                                      //{'divider': true},
                                      // {
                                      //   'title': 'Hapus',
                                      //   'icon': Icons.delete,
                                      //   'color': AppColor.warning
                                      // },
                                    ]),
                        );
                      },
                    ),
                  )
                : EmptyData(),
          );
        })
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
