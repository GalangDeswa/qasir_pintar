import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';

import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../controller_basemenuproduk.dart';

class ViewUkuran extends GetView<BaseMenuProdukController> {
  const ViewUkuran({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Icon(FontAwesomeIcons.magnifyingGlass),
              ),
              Expanded(
                child: TextField(
                  controller: controller.subsearch.value,
                  onChanged: (val) {
                    controller.serachSubKategoriProdukLocal();
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
        SizedBox(
          height: 20,
        ),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Daftar data'), Text('Aksi')],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 0.9,
          color: Colors.black,
          width: context.res_width,
          margin: EdgeInsets.only(bottom: 10),
        ),
        Obx(() {
          return Expanded(
            child: controller.ukuranList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.ukuranList.length,
                    itemBuilder: (context, index) {
                      final ukuran = controller.ukuranList;

                      return custom_list(
                        isDeleted: ukuran[index].aktif == 1 ? false : true,
                        usingGambar: false,
                        title: ukuran[index].ukuran,
                        trailing: customDropdown(
                            onSelected: (value) {
                              switch (value) {
                                case 'Ubah':
                                  Get.toNamed('/editukuran',
                                      arguments: ukuran[index]);
                                  break;
                                case 'Hapus':
                                  Popscreen()
                                      .deleteukuran(controller, ukuran[index]);
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
    );
  }
}
