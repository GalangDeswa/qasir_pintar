import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/controller_supplier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/model_supplier.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Widget/popscreen.dart';

class Supplier extends GetView<SupplierController> {
  const Supplier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: customFloat(onPressed: () {
        Get.toNamed('/tambahsupplier');
      }),
      appBar: AppbarCustom(title: 'Supplier', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: Column(
          children: [
            Container(
              height: 60,
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
                      controller: controller.search.value,
                      onChanged: (val) async {
                        await controller.serachSupplierLocal();
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
            //       Get.toNamed('/tambahsupplier');
            //     },
            //     child: Text('Tambah Supplier'),
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
                children: [
                  Text(
                    'Daftar Supplier',
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
                child: controller.supplierList.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.supplierList.length,
                        itemBuilder: (context, index) {
                          final supplier = controller.supplierList;

                          return custom_list(
                            title: supplier[index].nama_supplier,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  supplier[index].nohp.toString(),
                                  style: AppFont.small(),
                                ),
                                Text(
                                  supplier[index].alamat,
                                  style: AppFont.small(),
                                )
                              ],
                            ),
                            isDeleted:
                                supplier[index].aktif == 1 ? false : true,
                            usingGambar: false,
                            trailing: customDropdown(
                                onSelected: (value) {
                                  switch (value) {
                                    case 'Ubah':
                                      Get.toNamed('/editsupplier',
                                          arguments: supplier[index]);
                                      break;
                                    case 'Hapus':
                                      Popscreen().deleteSupllier(
                                          controller, supplier[index]);
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
        ),
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
      SupplierController controller, DataSupplier data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editsupplier', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deleteSupllier(controller, data);
        break;
    }
  }
}
