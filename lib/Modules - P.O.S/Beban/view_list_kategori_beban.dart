import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/controller_basemenu_beban.dart';

import '../../Controllers/CentralController.dart';
import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';

class ListKategoriBeban extends GetView<BasemenuBebanController> {
  const ListKategoriBeban({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralBebanController>();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daftar Kategori'),
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
            child: con.listKategoriBeban.isNotEmpty
                ? Padding(
                    padding: AppPading.customListPadding(),
                    child: ListView.builder(
                      itemCount: con.listKategoriBeban.length,
                      itemBuilder: (context, index) {
                        final kategoriBeban = con.listKategoriBeban;

                        return custom_list_produk(
                          controller: con,
                          isDeleted:
                              kategoriBeban[index].aktif == 1 ? false : true,
                          usingGambar: false,
                          title: kategoriBeban[index].namaKategoriBeban!,
                          trailing: kategoriBeban[index].aktif == 1
                              ? customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/edit_kategori_beban',
                                            arguments: kategoriBeban[index]);
                                        break;
                                      case 'Hapus':
                                        Popscreen().deleteKategroiBeban(
                                            controller, kategoriBeban[index]);
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
                                    ])
                              : customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/edit_kategori_beban',
                                            arguments: kategoriBeban[index]);
                                        break;
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
                                    ]),
                        );
                      },
                    ),
                  )
                : EmptyData(),
          );
        })
      ],
    );
  }
}
