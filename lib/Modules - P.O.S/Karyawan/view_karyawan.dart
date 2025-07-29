import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/controller_karyawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/model_karyawan.dart';

import '../../Config/config.dart';
import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';

class Karyawan extends GetView<KaryawanController> {
  const Karyawan({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralKaryawanController>();
    return Scaffold(
      floatingActionButton: customFloat(
        onPressed: () {
          Get.toNamed('/tambahkaryawan');
        },
      ),
      appBar: AppbarCustom(title: 'Karyawan', NeedBottom: false),
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
                    child: Icon(FontAwesomeIcons.magnifyingGlass),
                  ),
                  Expanded(
                    child: TextField(
                      controller: con.search.value,
                      onChanged: (val) async {
                        await con.searchKaryawanLocal();
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
            // button_border_custom(
            //     margin: EdgeInsets.all(15),
            //     onPressed: () {
            //       Get.toNamed('/tambahkaryawan');
            //     },
            //     child: Text('Tambah Karyawan'),
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
                    'Daftar Karyawan',
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
                child: con.karyawanList.isNotEmpty
                    ? ListView.builder(
                        itemCount: con.karyawanList.length,
                        itemBuilder: (context, index) {
                          final karyawan = con.karyawanList;

                          return custom_list(
                            gestureroute: '/detailkaryawan',
                            gestureArgument: karyawan[index],
                            isDeleted:
                                karyawan[index].aktif == 1 ? false : true,
                            usingGambar: false,
                            title: karyawan[index].nama_karyawan,
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    karyawan[index].email,
                                    style: AppFont.regular(),
                                  ),
                                  Text(
                                    karyawan[index].nohp,
                                    style: AppFont.regular(),
                                  ),
                                  Text(
                                    karyawan[index].role!,
                                    style: AppFont.regular_bold(),
                                  )
                                ]),
                            //TODO : edit karyawan role, sistem login karyawan kasir
                            trailing: customDropdown(
                                dropdownColor: Colors.white,
                                onSelected: (value) {
                                  switch (value) {
                                    case 'Ubah':
                                      Get.toNamed('/editkaryawan',
                                          arguments: karyawan[index]);
                                      break;
                                    case 'Hapus':
                                      Popscreen().deleteKaryawan(
                                          controller, karyawan[index]);
                                  }
                                },
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
      KaryawanController controller, DataKaryawan data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editkaryawan', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deleteKaryawan(controller, data);
        break;
    }
  }
}
