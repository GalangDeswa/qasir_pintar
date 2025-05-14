import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules/Produk/controller_basemenuproduk.dart';

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
        // Container(
        //   height: 60, padding: EdgeInsets.all(15),
        //   //color: Colors.red,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(right: 10),
        //         child: Icon(Icons.maps_ugc_outlined),
        //       ),
        //       Expanded(
        //         child: TextField(
        //           onChanged: (val) {
        //             controller.serachKategoriProdukLocal();
        //           },
        //           controller: controller.search.value,
        //           decoration: InputDecoration(hintText: 'Cari...'),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 10),
        //         child: Icon(Icons.sort),
        //       )
        //     ],
        //   ),
        // ),
        // button_border_custom(
        //     margin: EdgeInsets.all(15),
        //     onPressed: () {
        //       Get.toNamed('/tambahkategoriproduk');
        //     },
        //     child: Text('Tambah Kategori produk'),
        //     width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
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
                ? ListView.builder(
                    itemCount: con.produk.length,
                    itemBuilder: (context, index) {
                      final produk = con.produk;

                      return custom_list(
                        controller: controller,
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
                            Text(produk[index].namaKategori!),
                            Text('Qty x ' + produk[index].qty.toString())
                          ],
                        ),
                        trailing: customDropdown(
                            onSelected: (value) {
                              switch (value) {
                                case 'Ubah':
                                  Get.toNamed('/editproduk',
                                      arguments: produk[index]);
                                  break;
                                case 'Hapus':
                                  Popscreen()
                                      .deleteProduk(controller, produk[index]);
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
