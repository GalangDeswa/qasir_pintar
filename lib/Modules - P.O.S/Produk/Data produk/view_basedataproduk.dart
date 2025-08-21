import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/view_listproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/view_thumbproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/controller_basemenuproduk.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Controllers/CentralController.dart';
import '../../../Widget/popscreen.dart';

class ViewBaseDataproduk extends GetView<BaseMenuProdukController> {
  const ViewBaseDataproduk({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Obx(() {
              return customSearch(
                controller: con.searchproduk.value,
                sortValue: con.isAsc.value,
                onSortPressed: () {
                  con.toggleSortProduk();
                },
                onChanged: (x) {
                  con.searchProdukLocal(id_toko: con.id_toko, search: x);
                },
              );
            })),
            Obx(() {
              return controller.thumb.value == true
                  ? IconButton(
                      onPressed: () {
                        controller.thumb.value = !controller.thumb.value;
                      },
                      icon: FaIcon(FontAwesomeIcons.image))
                  : IconButton(
                      onPressed: () {
                        controller.thumb.value = !controller.thumb.value;
                      },
                      icon: FaIcon(FontAwesomeIcons.list));
            })
          ],
        ),

        SizedBox(
          height: 20,
        ),
        Obx(() {
          return controller.thumb.value == true
              ? Expanded(child: ThumbProduk())
              : Expanded(child: ListProduk());
        }),
        //Expanded(child: ThumbProduk()),
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
