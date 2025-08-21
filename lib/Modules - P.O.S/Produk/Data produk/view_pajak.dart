import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';

import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';
import '../controller_basemenuproduk.dart';

class ViewPajak extends GetView<BaseMenuProdukController> {
  const ViewPajak({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPajakController>();
    return Column(
      children: [
        Obx(() {
          return customSearch(
            controller: con.search.value,
            sortValue: con.isAsc.value,
            onSortPressed: () {
              con.toggleSortPajak();
            },
            onChanged: (x) {
              con.searchPajakLocal(id_toko: con.id_toko, search: x);
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
            children: [Text('Daftar Pajak'), Text('Aksi')],
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
            child: con.pajakList.isNotEmpty
                ? Padding(
                    padding: AppPading.customListPadding(),
                    child: ListView.builder(
                      itemCount: con.pajakList.length,
                      itemBuilder: (context, index) {
                        final pajak = con.pajakList;

                        return custom_list(
                          controller: controller,
                          isDeleted: pajak[index].aktif == 1 ? false : true,
                          usingGambar: false,
                          title: pajak[index].nama_pajak!,
                          subtitle: Text(
                              '% ' + pajak[index].nominal_pajak.toString()),
                          trailing: pajak[index].aktif == 1
                              ? customDropdown(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Ubah':
                                        Get.toNamed('/editpajak',
                                            arguments: pajak[index]);
                                        break;
                                      case 'Hapus':
                                        Popscreen().deletepajak(
                                            controller, pajak[index]);
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
                                        Get.toNamed('/editpajak',
                                            arguments: pajak[index]);
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
        }),
      ],
    );
  }
}
