import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/controller_basemenu_beban.dart';

import '../../Config/config.dart';
import '../../Controllers/CentralController.dart';
import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';

class ListBeban extends GetView<BasemenuBebanController> {
  const ListBeban({super.key});

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
              Text('Daftar Beban'),
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
            child: con.listBeban.isNotEmpty
                ? ListView.builder(
                    itemCount: con.listBeban.length,
                    itemBuilder: (context, index) {
                      final beban = con.listBeban;
                      //TODO : detail beban,edit beban
                      return custom_list_produk(
                        controller: con,
                        gestureroute: '/detail_beban',
                        gestureArgument: beban[index],
                        isDeleted: beban[index].aktif == 1 ? false : true,
                        usingGambar: false,
                        title: beban[index].namaBeban!,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(beban[index].kategoriBeban!),
                            Text(
                              AppFormat().formatRupiah(
                                beban[index].jumlahBeban!,
                              ),
                              style: AppFont.small(),
                            ),
                            Text(
                              beban[index].tanggalBeban!,
                            )
                          ],
                        ),
                        trailing: customDropdown(
                            onSelected: (value) {
                              switch (value) {
                                case 'Ubah':
                                  Get.toNamed('/edit_beban',
                                      arguments: beban[index]);
                                  break;
                                case 'Hapus':
                                  Popscreen()
                                      .deleteBeban(controller, beban[index]);
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
