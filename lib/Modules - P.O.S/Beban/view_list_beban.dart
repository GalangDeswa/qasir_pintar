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
        Obx(() {
          return customDatesearch(
              onReset: () {
                con.fetchBeban();
              },
              sortValue: con.isAsc.value,
              onSortPressed: () {
                con.toggleSortBeban();
              },
              onOkTap: () {
                print('custom dates');
                con.searchBebanByTanggal(
                    id_toko: con.id_toko,
                    startDate: con.date1.toString(),
                    endDate: con.date2.toString());
              },
              textController: con.pickdate.value,
              dates: con.dates,
              onDateChanged: (dates) {
                var list = <String>[];
                var start = dates.first;
                final end = dates.last;
                con.pickdate.value.text = (con.dateformat.format(start!) +
                    ' - ' +
                    con.dateformat.format(end!));

                con.date1 = start;
                con.date2 = end;
                print(con.date1);
                print(con.date2);
              });
        }),
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

                      return custom_list(
                        controller: controller,
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
                              AppFormat()
                                  .dateFormat(beban[index].tanggalBeban!),
                            )
                          ],
                        ),
                        trailing: beban[index].aktif == 1
                            ? customDropdown(
                                onSelected: (value) {
                                  switch (value) {
                                    case 'Ubah':
                                      Get.toNamed('/edit_beban',
                                          arguments: beban[index]);
                                      break;
                                    case 'Hapus':
                                      Popscreen().deleteBeban(
                                          controller, beban[index]);
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
                                      Get.toNamed('/edit_beban',
                                          arguments: beban[index]);
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
                  )
                : EmptyData(),
          );
        })
      ],
    );
  }
}
