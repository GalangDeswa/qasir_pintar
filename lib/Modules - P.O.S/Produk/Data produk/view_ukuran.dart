import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';

import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../controller_basemenuproduk.dart';

class ViewUkuran extends GetView<BaseMenuProdukController> {
  const ViewUkuran({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralUkuranProdukController>();
    return Column(
      children: [
        Obx(() {
          return customSearch(
            controller: con.search.value,
            sortValue: con.isAsc.value,
            onSortPressed: () {
              con.toggleSortUkuran();
            },
            onChanged: (x) {
              con.searchUkuranLocal(id_toko: con.id_toko, search: x);
            },
          );
        }),
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
            child: con.ukuranList.isNotEmpty
                ? Padding(
                    padding: AppPading.customListPadding(),
                    child: ListView.builder(
                      itemCount: con.ukuranList.length,
                      itemBuilder: (context, index) {
                        final ukuran = con.ukuranList;

                        return custom_list(
                          controller: controller,
                          isDeleted: ukuran[index].aktif == 1 ? false : true,
                          usingGambar: false,
                          title: ukuran[index].ukuran,
                          trailing: ukuran[index].aktif == 1
                              ? customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/editukuran',
                                            arguments: ukuran[index]);
                                        break;
                                      case 'Hapus':
                                        Popscreen().deleteukuran(
                                            controller, ukuran[index]);
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
                                        Get.toNamed('/editukuran',
                                            arguments: ukuran[index]);
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
