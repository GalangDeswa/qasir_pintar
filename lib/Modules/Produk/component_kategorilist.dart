import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Produk/Kategori/model_subkategoriproduk.dart';
import 'package:qasir_pintar/Modules/Produk/controller_basemenuproduk.dart';

import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';
import '../Pelanggan/List Pelanggan/model_pelanggan.dart';

class KategoriList extends GetView<BaseMenuProdukController> {
  const KategoriList({super.key});

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
                  controller: controller.subsearch.value,
                  onChanged: (val) {
                    controller.serachSubKategoriProdukLocal();
                  },
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
        //       Get.toNamed('/tambahsubkategori');
        //     },
        //     child: Text('Tambah sub kategori'),
        //     width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Daftar sub kategori'), Text('Aksi')],
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
            child: controller.subKategoriProduk.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.subKategoriProduk.length,
                    itemBuilder: (context, index) {
                      final customer = controller.subKategoriProduk;

                      return customer[index].aktif == 1
                          ? Card(
                              color: Colors.white,
                              margin: EdgeInsets.only(bottom: 25),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                // leading: ClipOval(
                                //   child: customer[index].foto != '-'
                                //       ? controller.isBase64Svg(customer[index].i!)
                                //           ? SvgPicture.memory(
                                //               base64Decode(customer[index].foto!),
                                //               width: 60,
                                //               height: 70,
                                //               fit: BoxFit.cover,
                                //             )
                                //           : Image.memory(
                                //               base64Decode(customer[index].foto!),
                                //               width: 60,
                                //               height: 70,
                                //               fit: BoxFit.cover,
                                //             )
                                //       : Image.asset(
                                //           AppString.defaultImg,
                                //           width: 60,
                                //           height: 70,
                                //           fit: BoxFit.cover,
                                //         ),
                                // ),
                                title: Text(
                                  customer[index].namaSubkelompok!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  customer[index].namakategori!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: DropdownButton2(
                                  hint: Text('Pilih tampilan'),
                                  customButton: const FaIcon(
                                    FontAwesomeIcons.list,
                                    // color: Colors.white,
                                    size: 25,
                                  ),
                                  items: [
                                    ...MenuItems.firstItems.map(
                                      (item) => DropdownMenuItem<MenuItem>(
                                        value: item,
                                        child: MenuItems.buildItem(item),
                                      ),
                                    ),
                                    const DropdownMenuItem<Divider>(
                                        enabled: false, child: Divider()),
                                    ...MenuItems.secondItems.map(
                                      (item) => DropdownMenuItem<MenuItem>(
                                        value: item,
                                        child: MenuItems.buildItem(item),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    MenuItems.onChanged(
                                        context,
                                        value! as MenuItem,
                                        controller,
                                        customer[index]);
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    width: 160,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    offset: const Offset(0, 8),
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    customHeights: [
                                      ...List<double>.filled(
                                          MenuItems.firstItems.length, 48),
                                      8,
                                      ...List<double>.filled(
                                          MenuItems.secondItems.length, 48),
                                    ],
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                  ),
                                ),
                              ),
                            )
                          : Card(
                              color: Colors.grey[300],
                              margin: EdgeInsets.only(bottom: 25),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                // leading: ClipOval(
                                //   child: customer[index].foto != '-'
                                //       ? controller.isBase64Svg(customer[index].i!)
                                //           ? SvgPicture.memory(
                                //               base64Decode(customer[index].foto!),
                                //               width: 60,
                                //               height: 70,
                                //               fit: BoxFit.cover,
                                //             )
                                //           : Image.memory(
                                //               base64Decode(customer[index].foto!),
                                //               width: 60,
                                //               height: 70,
                                //               fit: BoxFit.cover,
                                //             )
                                //       : Image.asset(
                                //           AppString.defaultImg,
                                //           width: 60,
                                //           height: 70,
                                //           fit: BoxFit.cover,
                                //         ),
                                // ),
                                title: Text(
                                  customer[index].namaSubkelompok!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Nonaktif',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                trailing: DropdownButton2(
                                  hint: Text('Pilih tampilan'),
                                  customButton: const FaIcon(
                                    FontAwesomeIcons.list,
                                    // color: Colors.white,
                                    size: 25,
                                  ),
                                  items: [
                                    ...MenuItems.firstItems.map(
                                      (item) => DropdownMenuItem<MenuItem>(
                                        value: item,
                                        child: MenuItems.buildItem(item),
                                      ),
                                    ),
                                    const DropdownMenuItem<Divider>(
                                        enabled: false, child: Divider()),
                                    ...MenuItems.secondItems.map(
                                      (item) => DropdownMenuItem<MenuItem>(
                                        value: item,
                                        child: MenuItems.buildItem(item),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    MenuItems.onChanged(
                                        context,
                                        value! as MenuItem,
                                        controller,
                                        customer[index]);
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    width: 160,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    offset: const Offset(0, 8),
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    customHeights: [
                                      ...List<double>.filled(
                                          MenuItems.firstItems.length, 48),
                                      8,
                                      ...List<double>.filled(
                                          MenuItems.secondItems.length, 48),
                                    ],
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                  ),
                                ),
                              ),
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
      BaseMenuProdukController controller, DataSubKategoriProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editsubkategoriproduk', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deleteSubkategori(controller, data);
        break;
    }
  }
}
