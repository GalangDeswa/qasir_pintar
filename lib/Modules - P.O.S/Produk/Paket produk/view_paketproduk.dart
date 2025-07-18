import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/model_produk.dart';

import '../../../Config/config.dart';
import '../../../Controllers/CentralController.dart';
import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../Produk/model_kategoriproduk.dart';
import '../controller_basemenuproduk.dart';

class PaketProduk extends GetView<BaseMenuProdukController> {
  const PaketProduk({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPaketController>();
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
                    con.searchPaketLocal(id_toko: con.id_toko);
                  },
                  controller: con.search.value,
                  decoration: InputDecoration(hintText: 'Cari...'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(Icons.sort),
              )
            ],
          ),
        ),
        // button_border_custom(
        //     margin: EdgeInsets.all(15),
        //     onPressed: () {
        //       Get.toNamed('/tambahpaketproduk');
        //     },
        //     child: Text('Tambah paket produk'),
        //     width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Daftar Paket'), Text('Aksi')],
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
            child: con.paketproduk.isNotEmpty
                ? ListView.builder(
                    itemCount: con.paketproduk.length,
                    itemBuilder: (context, index) {
                      final paket = con.paketproduk;

                      return custom_list_produk(
                        controller: con,
                        gestureroute: '/detailpaketproduk',
                        gestureArgument: paket[index],
                        isDeleted: paket[index].aktif == 1 ? false : true,
                        usingGambar: true,
                        title: paket[index].nama_paket!,
                        gambar: paket[index].gambar_utama,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            paket[index].diskon != 0.0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        'Rp ${NumberFormat('#,###').format(
                                          paket[index].harga_jual_paket!,
                                        )}',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 8),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Rp. ' +
                                                AppFormat().numFormat(
                                                  paket[index]
                                                          .harga_jual_paket! -
                                                      paket[index].diskon!,
                                                ),
                                            style: AppFont.small(),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(3),
                                            margin: EdgeInsets.only(left: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                                (paket[index].diskon! /
                                                            paket[index]
                                                                .harga_jual_paket! *
                                                            100)
                                                        .toStringAsFixed(0) +
                                                    '%',
                                                style: AppFont.small_white()),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : Text('Rp. ' +
                                    AppFormat().numFormat(
                                        paket[index].harga_jual_paket)),
                          ],
                        ),
                        trailing: customDropdown(
                            onSelected: (value) {
                              switch (value) {
                                case 'Ubah':
                                  Get.toNamed('/editpaketproduk',
                                      arguments: paket[index]);
                                  break;
                                case 'Hapus':
                                  Popscreen().deletePaketProduk(
                                      controller, paket[index]);
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
                            ]),
                      );
                    },
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
      BaseMenuProdukController controller, DataPaketProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editpaketproduk', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deletePaketProduk(controller, data);
        break;
    }
  }
}
