import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/controller_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/model_kategoriPelanggan.dart';
import 'package:qasir_pintar/Widget/popscreen.dart';
import 'package:qasir_pintar/Widget/widget.dart';

class KategoriPelanggan extends GetView<KategoriPelangganController> {
  const KategoriPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
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
                  controller: controller.search.value,
                  onChanged: (val) {
                    controller.serachKategoriPelangganLocal();
                  },
                  decoration: InputDecoration(hintText: 'Pencarian'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(Icons.sort),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // button_border_custom(
        //     margin: EdgeInsets.all(15),
        //     onPressed: () {
        //       Get.toNamed('/tambahkategoripelanggan');
        //     },
        //     child: Text('Tambah Kategori'),
        //     width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Kategori',
                style: AppFont.regular(),
              ),
              Text(
                'Aksi',
                style: AppFont.regular(),
              ),
            ],
          ),
        ),
        Container(
          height: 0.9,
          color: Colors.black,
          width: context.res_width,
          margin: EdgeInsets.only(bottom: 20),
        ),
        Obx(() {
          return Expanded(
            child: controller.kategoripelangganList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.kategoripelangganList.length,
                    itemBuilder: (context, index) {
                      final customer = controller.kategoripelangganList;

                      return custom_list(
                        controller: controller,
                        title: customer[index].kategori,
                        isDeleted: customer[index].status == 1 ? false : true,
                        usingGambar: true,
                        gambar: customer[index].ikon,
                        trailing: customDropdown(
                            onSelected: (value) {
                              switch (value) {
                                case 'Ubah':
                                  Get.toNamed('/editkategoripelanggan',
                                      arguments: customer[index]);
                                  break;
                                case 'Hapus':
                                  Popscreen().deleteKategoriPelanggan(
                                      controller, customer[index]);
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
      KategoriPelangganController controller, DataKategoriPelanggan data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editkategoripelanggan', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deleteKategoriPelanggan(controller, data);
        break;
    }
  }
}
