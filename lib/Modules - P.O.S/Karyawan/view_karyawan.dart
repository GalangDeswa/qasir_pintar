import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/controller_karyawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/model_karyawan.dart';

import '../../Config/config.dart';
import '../../Middleware/customPageRole.dart';
import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';

class Karyawan extends GetView<KaryawanController> {
  const Karyawan({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralKaryawanController>();
    return CustomRole(
      allowedRoles: ['ADMIN', 'MANAGER'],
      child: Scaffold(
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
              Obx(() {
                return customSearch(
                  controller: con.search.value,
                  sortValue: con.isAsc.value,
                  onSortPressed: () {
                    con.toggleSortKaryawan();
                  },
                  onChanged: (x) {
                    con.searchKaryawanLocal(id_toko: con.id_toko, search: x);
                  },
                );
              }),
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
                      ? Padding(
                          padding: AppPading.customListPadding(),
                          child: ListView.builder(
                            itemCount: con.karyawanList.length,
                            itemBuilder: (context, index) {
                              final karyawan = con.karyawanList;

                              return custom_list(
                                gestureroute: '/detailkaryawan',
                                gestureArgument: karyawan[index],
                                isDeleted:
                                    karyawan[index].aktif == 1 ? false : true,
                                usingGambar: false,
                                title: karyawan[index].nama_karyawan! +
                                    ' - ' +
                                    karyawan[index].role!,
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        karyawan[index].email,
                                        style: AppFont.regular(),
                                      ),
                                      Text(
                                        karyawan[index].nohp,
                                        style: AppFont.regular(),
                                      ),
                                    ]),
                                trailing: karyawan[index].aktif == 1
                                    ? customDropdown(
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
                                          ])
                                    : customDropdown(
                                        dropdownColor: Colors.white,
                                        onSelected: (value) {
                                          switch (value) {
                                            case 'Ubah':
                                              Get.toNamed('/editkaryawan',
                                                  arguments: karyawan[index]);
                                              break;
                                          }
                                        },
                                        customButton: const Icon(Icons.menu),
                                        items: [
                                            {
                                              'title': 'Ubah',
                                              'icon': Icons.edit,
                                              'color': AppColor.primary
                                            },
                                          ]),
                              );
                            },
                          ),
                        )
                      : EmptyData(),
                );
              })
            ],
          ),
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
