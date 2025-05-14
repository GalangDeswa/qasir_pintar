import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules/Produk/controller_basemenuproduk.dart';

import '../../../Config/config.dart';
import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../Produk/model_kategoriproduk.dart';

class ViewDataDetailProduk extends GetView<BaseMenuProdukController> {
  const ViewDataDetailProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   height: 50, padding: EdgeInsets.all(15),
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
        button_border_custom(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15),
            onPressed: () {
              Get.toNamed('/tambahpajak');
            },
            child: Text('Tambah PPN'),
            width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Daftar data'), Text('Aksi')],
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
            child: controller.pajakList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.pajakList.length,
                    itemBuilder: (context, index) {
                      final customer = controller.pajakList;

                      return customer[index].aktif == 1
                          ? Column(
                              children: [
                                ListTile(
                                  subtitle: Text(
                                      'Rp ${NumberFormat('#,###').format(customer[index].nominal_pajak)}',
                                      style: AppFont.small()),
                                  title: Text(customer[index].nama_pajak!,
                                      style: AppFont.regular()),
                                  // subtitle: Text(
                                  //   customer[index].harga_jual_utama.toString(),
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  trailing: DropdownButton2(
                                    hint: Text('Pilih tampilan'),
                                    customButton: const FaIcon(
                                      FontAwesomeIcons.list,
                                      // color: Colors.white,
                                      size: 20,
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
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
                                Container(
                                  height: 0.2,
                                  color: Colors.black,
                                  width: context.res_width,
                                  margin: EdgeInsets.only(bottom: 0),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  color: Colors.grey[300],
                                  child: ListTile(
                                    subtitle: Text('Nonaktif',
                                        style: TextStyle(color: Colors.red)),
                                    title: Text(customer[index].nama_pajak!,
                                        style: AppFont.regular()),
                                    // subtitle: Text(
                                    //   customer[index].harga_jual_utama.toString(),
                                    //   style: TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    trailing: DropdownButton2(
                                      hint: Text('Pilih tampilan'),
                                      customButton: const FaIcon(
                                        FontAwesomeIcons.list,
                                        // color: Colors.white,
                                        size: 20,
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                ),
                                Container(
                                  height: 0.2,
                                  color: Colors.black,
                                  width: context.res_width,
                                  margin: EdgeInsets.only(bottom: 0),
                                ),
                              ],
                            );
                    },
                  )
                : EmptyData(),
          );
        }),
        // Container(
        //   height: 50,
        //   padding: EdgeInsets.all(15),
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
        button_border_custom(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15),
            onPressed: () {
              Get.toNamed('/tambahukuran');
            },
            child: Text('Tambah Ukuran'),
            width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Daftar data'), Text('Aksi')],
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
            child: controller.ukuranList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.ukuranList.length,
                    itemBuilder: (context, index) {
                      final customer = controller.ukuranList;

                      return customer[index].aktif == 1
                          ? Column(
                              children: [
                                ListTile(
                                  subtitle: Text(
                                    'Ukuran',
                                    style: AppFont.small(),
                                  ),
                                  title: Text(
                                    customer[index].ukuran!,
                                    style: AppFont.regular(),
                                  ),
                                  // subtitle: Text(
                                  //   customer[index].harga_jual_utama.toString(),
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  trailing: DropdownButton2(
                                    hint: Text('Pilih tampilan'),
                                    customButton: const FaIcon(
                                      FontAwesomeIcons.list,
                                      // color: Colors.white,
                                      size: 20,
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
                                      MenuItemsv2.onChanged(
                                          context,
                                          value! as MenuItem,
                                          controller,
                                          customer[index]);
                                    },
                                    dropdownStyleData: DropdownStyleData(
                                      width: 160,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
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
                                Container(
                                  height: 0.2,
                                  color: Colors.black,
                                  width: context.res_width,
                                  margin: EdgeInsets.only(bottom: 0),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  color: Colors.grey[300],
                                  child: ListTile(
                                    subtitle: Text(
                                      'Nonaktif',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    title: Text(
                                      customer[index].ukuran!,
                                      style: AppFont.regular(),
                                    ),
                                    // subtitle: Text(
                                    //   customer[index].harga_jual_utama.toString(),
                                    //   style: TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    trailing: DropdownButton2(
                                      hint: Text('Pilih tampilan'),
                                      customButton: const FaIcon(
                                        FontAwesomeIcons.list,
                                        // color: Colors.white,
                                        size: 20,
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
                                        MenuItemsv2.onChanged(
                                            context,
                                            value! as MenuItem,
                                            controller,
                                            customer[index]);
                                      },
                                      dropdownStyleData: DropdownStyleData(
                                        width: 160,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                ),
                                Container(
                                  height: 0.2,
                                  color: Colors.black,
                                  width: context.res_width,
                                  margin: EdgeInsets.only(bottom: 0),
                                ),
                              ],
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
      BaseMenuProdukController controller, DataPajakProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editpajak', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deletepajak(controller, data);
        break;
    }
  }
}

class MenuItemv2 {
  const MenuItemv2({
    required this.text,
    required this.icon,
    this.iconcolor,
  });

  final String text;
  final IconData icon;
  final bool? iconcolor;
}

abstract class MenuItemsv2 {
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
      BaseMenuProdukController controller, DataUkuranProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editukuran', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deleteukuran(controller, data);
        break;
    }
  }
}
