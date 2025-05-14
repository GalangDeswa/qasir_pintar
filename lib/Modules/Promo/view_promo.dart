import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Promo/controller_promo.dart';

import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';
import 'model_promo.dart';

class Promo extends GetView<PromoController> {
  const Promo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Promo', NeedBottom: false),
      body: Column(
        children: [
          Container(
            height: 60, padding: EdgeInsets.all(15),
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.maps_ugc_outlined),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      //controller.serachKategoriProdukLocal();
                    },
                    //controller: controller.search.value,
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
          button_border_custom(
              margin: EdgeInsets.all(15),
              onPressed: () {
                Get.toNamed('/tambah_promo');
              },
              child: Text('Tambah promo'),
              width: context.res_width),
          Container(
            //height: 100,
            //color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Daftar promo'), Text('Aksi')],
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
              child: controller.promo.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.promo.length,
                      itemBuilder: (context, index) {
                        final promo = controller.promo;

                        return custom_list(
                          controller: controller,
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
                              MenuItems.onChanged(context, value! as MenuItem,
                                  controller, promo[index]);
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
                              customHeights: [
                                ...List<double>.filled(
                                    MenuItems.firstItems.length, 48),
                                8,
                                ...List<double>.filled(
                                    MenuItems.secondItems.length, 48),
                              ],
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                            ),
                          ),
                          subtitle: promo[index].tglMulai! +
                              ' - ' +
                              promo[index].tglSelesai!,
                          title: promo[index].namaPromo,
                          gestureroute: '/detail_promo',
                          gestureArgument: promo[index],
                        );
                      },
                    )
                  : EmptyData(),
            );
          })
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
      PromoController controller, DataPromo data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/edit_promo', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deletePromo(controller, data);
        break;
    }
  }
}
