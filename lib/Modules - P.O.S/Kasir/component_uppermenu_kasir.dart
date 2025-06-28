import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';

class UpperMenuKasir extends GetView<KasirController> {
  const UpperMenuKasir({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();
    return Container(
      // color: Colors.red,
      width: context.res_width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (val) {
                    print(val);
                    con.searchProdukLocal(id_toko: controller.id_toko);
                  },
                  controller: con.searchproduk.value,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Pencarian',
                      hintStyle: AppFont.regular(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton2(
              hint: Text('Pilih tampilan'),
              customButton: const FaIcon(
                FontAwesomeIcons.list,
                // color: Colors.white,
                size: 20,
              ),
              items: [
                ...MenuItems.thirdItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                // const DropdownMenuItem<Divider>(
                //     enabled: false, child: Divider()),
                // ...MenuItems.secondItems.map(
                //   (item) => DropdownMenuItem<MenuItem>(
                //     value: item,
                //     child: MenuItems.buildItem(item),
                //   ),
                // ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value! as MenuItem, controller);
              },
              dropdownStyleData: DropdownStyleData(
                width: 160,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                offset: const Offset(0, 8),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 35,
                // customHeights: [
                //   ...List<double>.filled(MenuItems.firstItems.length, 48),
                //   1,
                //   ...List<double>.filled(
                //       MenuItems.secondItems.length, 48),
                //   ...List<double>.filled(MenuItems.thirdItems.length, 48),
                //   1,
                // ],
                padding: const EdgeInsets.only(left: 16, right: 16),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(right: 50, left: 20),
          //   width: 210,
          //   child: DropdownButtonFormField2(
          //     decoration: InputDecoration(
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //     ),
          //     validator: (value) {
          //       if (value == null) {
          //         return 'Pilih jenis usaha';
          //       }
          //       return null;
          //     },
          //     isExpanded: true,
          //     dropdownStyleData: DropdownStyleData(
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: Colors.white)),
          //     hint: Text('Semua kategori', style: AppFont.regular()),
          //     value: controller.jenisvalue,
          //     items: controller.jenislistlocal.map((x) {
          //       return DropdownMenuItem(
          //         child: Text(x),
          //         value: x.toString(),
          //       );
          //     }).toList(),
          //     onChanged: (val) {
          //       controller.jenisvalue = val!.toString();
          //       print(controller.jenisvalue);
          //     },
          //   ),
          // ),
          // Expanded(
          //   child: Row(
          //     children: [
          //       // Expanded(
          //       //   child: FaIcon(
          //       //     FontAwesomeIcons.magnifyingGlass,
          //       //     //  color: Colors.white,
          //       //     size: 25,
          //       //   ),
          //       // ),
          //       // Expanded(
          //       //   child: FaIcon(
          //       //     FontAwesomeIcons.barcode,
          //       //     //   color: Colors.white,
          //       //     size: 25,
          //       //   ),
          //       // ),
          //
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}

class UpperMenuMeja extends GetView<KasirController> {
  const UpperMenuMeja({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: context.res_width,
      //color: Colors.purpleAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(right: 50, left: 20),
            width: 210,
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Pilih jenis usaha';
                }
                return null;
              },
              isExpanded: true,
              dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white)),
              hint: Text('Lantai 1', style: AppFont.regular()),
              value: controller.jenisvalue,
              items: controller.jenislistlocal.map((x) {
                return DropdownMenuItem(
                  child: Text(x),
                  value: x.toString(),
                );
              }).toList(),
              onChanged: (val) {
                controller.jenisvalue = val!.toString();
                print(controller.jenisvalue);
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    // color: Colors.white,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: DropdownButton2(
                    hint: Text('Pilih tampilan'),
                    customButton: const FaIcon(
                      FontAwesomeIcons.list,
                      //  color: Colors.white,
                      size: 25,
                    ),
                    items: [
                      ...MenuItems.thirdItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                          value: item,
                          child: MenuItems.buildItem(item),
                        ),
                      ),
                      const DropdownMenuItem<Divider>(
                          enabled: false, child: Divider()),
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
                          context, value! as MenuItem, controller);
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: 160,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      offset: const Offset(0, 8),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 35,
                      // customHeights: [
                      //   ...List<double>.filled(MenuItems.firstItems.length, 30),
                      //   ...List<double>.filled(
                      //       MenuItems.secondItems.length, 30),
                      //   ...List<double>.filled(MenuItems.thirdItems.length, 30),
                      // ],
                      padding: const EdgeInsets.only(left: 16, right: 16),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
  static const List<MenuItem> firstItems = [list];
  static const List<MenuItem> secondItems = [meja];
  static const List<MenuItem> thirdItems = [thumb];

  static const list =
      MenuItem(text: 'List', icon: Icons.edit, iconcolor: false);
  static const meja =
      MenuItem(text: 'Meja', icon: Icons.table_bar, iconcolor: true);
  static const thumb = MenuItem(
      text: 'Thumbnail', icon: Icons.picture_in_picture, iconcolor: true);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color:
                item.iconcolor == false ? AppColor.primary : AppColor.secondary,
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

  static void onChanged(
      BuildContext context, MenuItem item, KasirController controller) {
    switch (item) {
      case MenuItems.list:
        print('edit');
        controller.tampilan.value = 'list';
        break;
      case MenuItems.meja:
        controller.tampilan.value = 'meja';
        break;
      case MenuItems.thumb:
        controller.tampilan.value = 'thumb';
        break;
    }
  }
}
