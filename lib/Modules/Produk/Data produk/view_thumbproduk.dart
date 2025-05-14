import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qasir_pintar/Config/config.dart';

import '../../../Controllers/CentralController.dart';
import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../../Karyawan/view_karyawan.dart';
import '../controller_basemenuproduk.dart';
import 'model_produk.dart';

class ThumbProduk extends GetView<BaseMenuProdukController> {
  const ThumbProduk({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();
    return Column(
      children: [
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
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: context.res_height / 3.5,
                    maxCrossAxisExtent: context.res_width / 2.0,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: con.produk.length,
                itemBuilder: (BuildContext context, index) {
                  var produk = con.produk;
                  return produk[index].tampilkan_di_produk == 1
                      ? GestureDetector(
                          onTap: () {
                            Get.toNamed('/isiproduk', arguments: produk[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  // Shadow color
                                  spreadRadius: 1,
                                  // Spread radius
                                  blurRadius: 5,
                                  // Blur radius
                                  offset: Offset(2,
                                      3), // Changes the position of the shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,

                                  // color: Colors.purpleAccent,
                                  height: 120,
                                  width: context.res_width,
                                  child: produk[index].gambar_produk_utama !=
                                              '' &&
                                          produk[index].gambar_produk_utama !=
                                              null
                                      ? controller.isBase64Svg(produk[index]
                                              .gambar_produk_utama!)
                                          ? SvgPicture.memory(
                                              base64Decode(produk[index]
                                                  .gambar_produk_utama!),
                                              width: 60,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              base64Decode(produk[index]
                                                  .gambar_produk_utama!),
                                              width: 60,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            )
                                      : Image.asset(
                                          AppString.defaultImg,
                                          width: 60,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    width: context.res_width,
                                    //height: context.res_height * 0.1,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          produk[index].nama_produk!,
                                          style: AppFont.regular_bold(),
                                        ),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          produk[index].namaKategori!,
                                          style: AppFont.regular(),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: DropdownButton2(
                                            hint: Text('Pilih tampilan'),
                                            customButton: const FaIcon(
                                              FontAwesomeIcons.list,
                                              // color: Colors.white,
                                              size: 20,
                                            ),
                                            items: [
                                              ...MenuItems.firstItems.map(
                                                (item) =>
                                                    DropdownMenuItem<MenuItem>(
                                                  value: item,
                                                  child:
                                                      MenuItems.buildItem(item),
                                                ),
                                              ),
                                              const DropdownMenuItem<Divider>(
                                                  enabled: false,
                                                  child: Divider()),
                                              ...MenuItems.secondItems.map(
                                                (item) =>
                                                    DropdownMenuItem<MenuItem>(
                                                  value: item,
                                                  child:
                                                      MenuItems.buildItem(item),
                                                ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              MenuItems.onChanged(
                                                  context,
                                                  value! as MenuItem,
                                                  controller,
                                                  produk[index]);
                                            },
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              width: 160,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              offset: const Offset(0, 8),
                                            ),
                                            menuItemStyleData:
                                                MenuItemStyleData(
                                              customHeights: [
                                                ...List<double>.filled(
                                                    MenuItems.firstItems.length,
                                                    48),
                                                8,
                                                ...List<double>.filled(
                                                    MenuItems
                                                        .secondItems.length,
                                                    48),
                                              ],
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                            ),
                                          ),
                                        ),

                                        // Expanded(
                                        //   child: x[index].diskonBarang == 0
                                        //       ? Text(
                                        //           'Rp. ' +
                                        //               controller.nominal.format(x[index].harga),
                                        //           style: font().produkharga,
                                        //         )
                                        //       : Row(
                                        //           children: [
                                        //             Text(
                                        //               'Rp. ' +
                                        //                   controller.nominal
                                        //                       .format(hargadiskon),
                                        //               style: font().produkharga,
                                        //             ),
                                        //             const SizedBox(
                                        //               width: 10,
                                        //             ),
                                        //             Container(
                                        //               padding: const EdgeInsets.symmetric(
                                        //                   vertical: 3, horizontal: 5),
                                        //               child: Text(
                                        //                 display_diskon + '%',
                                        //                 style: const TextStyle(
                                        //                     fontWeight: FontWeight.bold,
                                        //                     color: Colors.white,
                                        //                     fontSize: 12),
                                        //               ),
                                        //               decoration: BoxDecoration(
                                        //                   color: color_template().secondary,
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(10)),
                                        //             )
                                        //           ],
                                        //         ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Get.toNamed('/isiproduk', arguments: produk[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  // Shadow color
                                  spreadRadius: 1,
                                  // Spread radius
                                  blurRadius: 5,
                                  // Blur radius
                                  offset: Offset(2,
                                      3), // Changes the position of the shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.grey[300],

                                  // color: Colors.purpleAccent,
                                  height: 120,
                                  width: context.res_width,
                                  child: produk[index].gambar_produk_utama !=
                                              '' &&
                                          produk[index].gambar_produk_utama !=
                                              null
                                      ? controller.isBase64Svg(produk[index]
                                              .gambar_produk_utama!)
                                          ? SvgPicture.memory(
                                              base64Decode(produk[index]
                                                  .gambar_produk_utama!),
                                              width: 60,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              base64Decode(produk[index]
                                                  .gambar_produk_utama!),
                                              width: 60,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            )
                                      : Image.asset(
                                          AppString.defaultImg,
                                          width: 60,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    width: context.res_width,
                                    //height: context.res_height * 0.1,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          produk[index].nama_produk!,
                                          style: AppFont.regular_bold(),
                                        ),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          'Nonaktif',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: DropdownButton2(
                                            hint: Text('Pilih tampilan'),
                                            customButton: const FaIcon(
                                              FontAwesomeIcons.list,
                                              // color: Colors.white,
                                              size: 20,
                                            ),
                                            items: [
                                              ...MenuItems.firstItems.map(
                                                (item) =>
                                                    DropdownMenuItem<MenuItem>(
                                                  value: item,
                                                  child:
                                                      MenuItems.buildItem(item),
                                                ),
                                              ),
                                              const DropdownMenuItem<Divider>(
                                                  enabled: false,
                                                  child: Divider()),
                                              ...MenuItems.secondItems.map(
                                                (item) =>
                                                    DropdownMenuItem<MenuItem>(
                                                  value: item,
                                                  child:
                                                      MenuItems.buildItem(item),
                                                ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              MenuItems.onChanged(
                                                  context,
                                                  value! as MenuItem,
                                                  controller,
                                                  produk[index]);
                                            },
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              width: 160,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              offset: const Offset(0, 8),
                                            ),
                                            menuItemStyleData:
                                                MenuItemStyleData(
                                              customHeights: [
                                                ...List<double>.filled(
                                                    MenuItems.firstItems.length,
                                                    48),
                                                8,
                                                ...List<double>.filled(
                                                    MenuItems
                                                        .secondItems.length,
                                                    48),
                                              ],
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                            ),
                                          ),
                                        ),

                                        // Expanded(
                                        //   child: x[index].diskonBarang == 0
                                        //       ? Text(
                                        //           'Rp. ' +
                                        //               controller.nominal.format(x[index].harga),
                                        //           style: font().produkharga,
                                        //         )
                                        //       : Row(
                                        //           children: [
                                        //             Text(
                                        //               'Rp. ' +
                                        //                   controller.nominal
                                        //                       .format(hargadiskon),
                                        //               style: font().produkharga,
                                        //             ),
                                        //             const SizedBox(
                                        //               width: 10,
                                        //             ),
                                        //             Container(
                                        //               padding: const EdgeInsets.symmetric(
                                        //                   vertical: 3, horizontal: 5),
                                        //               child: Text(
                                        //                 display_diskon + '%',
                                        //                 style: const TextStyle(
                                        //                     fontWeight: FontWeight.bold,
                                        //                     color: Colors.white,
                                        //                     fontSize: 12),
                                        //               ),
                                        //               decoration: BoxDecoration(
                                        //                   color: color_template().secondary,
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(10)),
                                        //             )
                                        //           ],
                                        //         ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                }),
          );
        }),
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
