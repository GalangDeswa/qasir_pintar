import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/model_kategoriproduk.dart';

import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../../Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../controller_basemenuproduk.dart';

class KelompokProduk extends GetView<BaseMenuProdukController> {
  const KelompokProduk({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralKategoriProdukController>();
    return Column(
      children: [
        Obx(() {
          return customSearch(
            controller: con.searchKategori.value,
            sortValue: con.isAsc.value,
            onSortPressed: () {
              con.toggleSortkategori();
            },
            onChanged: (x) {
              con.serachKategoriProdukLocal(id_toko: con.id_toko, search: x);
            },
          );
        }),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Daftar kategori'), Text('Aksi')],
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
            child: con.kategoriProduk.isNotEmpty
                ? Padding(
                    padding: AppPading.customListPadding(),
                    child: ListView.builder(
                      itemCount: con.kategoriProduk.length,
                      itemBuilder: (context, index) {
                        final kategori = con.kategoriProduk;

                        return custom_list(
                          controller: controller,
                          usingGambar: true,
                          isDeleted: kategori[index].aktif == 1 ? false : true,
                          gambar: kategori[index].ikon,
                          title: kategori[index].namakelompok,
                          trailing: kategori[index].aktif == 1
                              ? customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/editkategoriproduk',
                                            arguments: kategori[index]);
                                        break;
                                      case 'Hapus':
                                        Popscreen().deleteKategoriProduk(
                                            controller, kategori[index]);
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
                                        Get.toNamed('/editkategoriproduk',
                                            arguments: kategori[index]);
                                        break;
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
      BaseMenuProdukController controller, DataKategoriProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editkategoriproduk', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deleteKategoriProduk(controller, data);
        break;
    }
  }
}
