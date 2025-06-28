import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/controller_promo.dart';

import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';
import 'model_promo.dart';

class Promo extends GetView<PromoController> {
  const Promo({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        floatingActionButton: customFloat(onPressed: () {
          Get.toNamed('/tambah_promo');
        }),
        appBar: AppbarCustom(title: 'Promo', NeedBottom: false),
        body: Padding(
          padding: AppPading.defaultBodyPadding(),
          child: Column(
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
                        onChanged: (val) {
                          controller.searchPromoLocal();
                        },
                        controller: controller.search.value,
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
              // button_border_custom(
              //     margin: EdgeInsets.all(15),
              //     onPressed: () {
              //       Get.toNamed('/tambah_promo');
              //     },
              //     child: Text('Tambah promo'),
              //     width: context.res_width),
              SizedBox(
                height: 20,
              ),
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
                //TODO : CHECK PROMO VALUE EMNG BISA 2 ang sm persen atau hanya 1
                return Expanded(
                  child: controller.promo.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.promo.length,
                          itemBuilder: (context, index) {
                            final promo = controller.promo;

                            return custom_list(
                              usingGambar: false,
                              isDeleted: promo[index].aktif == 1 ? false : true,
                              controller: controller,
                              trailing: customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/edit_promo',
                                            arguments: promo[index]);
                                        break;
                                      case 'Hapus':
                                        Popscreen().deletePromo(
                                            controller, promo[index]);
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      style: AppFont.small(),
                                      promo[index].promoNominal != 0.0
                                          ? 'Rp. ' +
                                              AppFormat().numFormat(
                                                  promo[index].promoNominal)
                                          : promo[index].promoNominal != 0.0
                                              ? '% ' +
                                                  AppFormat().numFormat(
                                                      promo[index].promoPersen)
                                              : '% 12312313'),
                                  Text(
                                    style: AppFont.small(),
                                    promo[index].tglMulai! +
                                        ' - ' +
                                        promo[index].tglSelesai!,
                                  )
                                ],
                              ),
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
        ),
      );
    });
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
