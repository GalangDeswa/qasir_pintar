import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/model_produk.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import 'controller_basemenustock.dart';

class StockList extends GetView<BasemenuStockController> {
  const StockList({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();
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
                child: Icon(Icons.sort),
              ),
              Expanded(
                child: Obx(() {
                  return TextField(
                    onChanged: (val) async {
                      if (controller.filterstock.value.text.isEmpty) {
                        await con.fetchProdukLocal(id_toko: controller.id_toko);
                        controller.filterval.value = 0;
                      } else {
                        controller.filterval.value = int.parse(val);
                      }
                      print(controller.filterstock.value.text);
                    },
                    controller: controller.filterstock.value,
                    decoration: InputDecoration(hintText: 'Filter'),
                  );
                }),
              ),
              Obx(() {
                return controller.filterval.value == 0
                    ? Container()
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: IconButton(
                                onPressed: () {
                                  con.filterStock(
                                      id_toko: controller.id_toko,
                                      stock: int.parse(
                                          controller.filterstock.value.text),
                                      filter: "<");
                                },
                                icon: Icon(FontAwesomeIcons.lessThan)),
                          ),
                          IconButton(
                              onPressed: () {
                                con.filterStock(
                                    id_toko: controller.id_toko,
                                    stock: int.parse(
                                        controller.filterstock.value.text),
                                    filter: "=");
                              },
                              icon: Icon(FontAwesomeIcons.equals)),
                          IconButton(
                              onPressed: () {
                                con.filterStock(
                                    id_toko: controller.id_toko,
                                    stock: int.parse(
                                        controller.filterstock.value.text),
                                    filter: ">");
                              },
                              icon: Icon(FontAwesomeIcons.greaterThan)),
                        ],
                      );
              })
            ],
          ),
        ),
        // button_border_custom(
        //     margin: EdgeInsets.all(15),
        //     onPressed: () {
        //       Get.toNamed('/penerimaan_produk');
        //     },
        //     child: Text('Tambah Penerimaan'),
        //     width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Produk'), Text('Stock')],
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
                        usingGambar: false,
                        controller: controller,
                        trailing: Text(
                          produk[index].hitung_stok == 1
                              ? 'Qty :' + produk[index].qty.toString()
                              : 'Nonstock',
                          style: AppFont.regular_bold(),
                        ),
                        // trailing: DropdownButton2(
                        //   hint: Text('Pilih tampilan'),
                        //   customButton: const FaIcon(
                        //     FontAwesomeIcons.list,
                        //     // color: Colors.white,
                        //     size: 25,
                        //   ),
                        //   items: [
                        //     ...MenuItems.firstItems.map(
                        //       (item) => DropdownMenuItem<MenuItem>(
                        //         value: item,
                        //         child: MenuItems.buildItem(item),
                        //       ),
                        //     ),
                        //     const DropdownMenuItem<Divider>(
                        //         enabled: false, child: Divider()),
                        //     ...MenuItems.secondItems.map(
                        //       (item) => DropdownMenuItem<MenuItem>(
                        //         value: item,
                        //         child: MenuItems.buildItem(item),
                        //       ),
                        //     ),
                        //   ],
                        //   onChanged: (value) {
                        //     // MenuItems.onChanged(context, value! as MenuItem,
                        //     //     controller, penerimaan[index]);
                        //   },
                        //   dropdownStyleData: DropdownStyleData(
                        //     width: 160,
                        //     padding: const EdgeInsets.symmetric(vertical: 5),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(4),
                        //     ),
                        //     offset: const Offset(0, 8),
                        //   ),
                        //   menuItemStyleData: MenuItemStyleData(
                        //     customHeights: [
                        //       ...List<double>.filled(
                        //           MenuItems.firstItems.length, 48),
                        //       8,
                        //       ...List<double>.filled(
                        //           MenuItems.secondItems.length, 48),
                        //     ],
                        //     padding: const EdgeInsets.only(left: 16, right: 16),
                        //   ),
                        // ),
                        subtitle: Text('Rp. ' +
                            AppFormat()
                                .numFormat(produk[index].harga_jual_eceran)),
                        title: produk[index].nama_produk,
                        gestureroute: '/detail_stock',
                        gestureArgument: produk[index],
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
      BasemenuStockController controller, DataProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editpaketproduk', arguments: data);
        break;
      case MenuItems.Hapus:
        // Popscreen().deleteKategoriProduk(controller, data);
        break;
    }
  }
}
