import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20Pelanggan/controller_pelanggan.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Controllers/CentralController.dart';
import '../../../Widget/popscreen.dart';
import 'model_pelanggan.dart';

class Pelanggan extends GetView<PelangganController> {
  const Pelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPelangganController>();
    return Column(
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
                  onChanged: (val) {
                    con.serachPelangganLocal();
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
        SizedBox(
          height: 20,
        ),
        // button_border_custom(
        //     margin: EdgeInsets.all(15),
        //     onPressed: () {
        //       Get.toNamed('/tambahpelanggan');
        //     },
        //     child: Text('Tambah Pelanggan'),
        //     width: context.res_width),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar pelanggan',
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
            child: con.pelangganList.isNotEmpty
                ? ListView.builder(
                    itemCount: con.pelangganList.length,
                    itemBuilder: (context, index) {
                      final customer = con.pelangganList;

                      return custom_list(
                        gestureroute: '/detailpelanggan',
                        gestureArgument: customer[index],
                        isDeleted:
                            customer[index].statusPelanggan == 1 ? false : true,
                        trailing: customDropdown(
                            onSelected: (value) {
                              switch (value) {
                                case 'Ubah':
                                  Get.toNamed('/editpelanggan',
                                      arguments: customer[index]);
                                  break;
                                case 'Hapus':
                                  Popscreen().deletePelanggan(
                                      controller, customer[index]);
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
                        usingGambar: true,
                        gambar: customer[index].foto,
                        title: customer[index].namaPelanggan,
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer[index].noHp!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              customer[index].kategoriNama!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        controller: controller,
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
      MenuItem(text: 'Ubah', icon: Icons.edit, iconcolor: false);
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
      PelangganController controller, DataPelanggan data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editpelanggan', arguments: data);
        break;
      case MenuItems.Hapus:
        Popscreen().deletePelanggan(controller, data);
        break;
    }
  }
}

DropdownMenuItem<String> _buildMenuItem(String text, IconData icon) {
  return DropdownMenuItem(
    value: text,
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}

void _handleSelection(BuildContext context, String value) {
  switch (value) {
    case 'Home':
      // Handle Home
      break;
    case 'Share':
      // Handle Share
      break;
    case 'Settings':
      // Handle Settings
      break;
    case 'Log Out':
      // Handle Log Out
      break;
  }
}
