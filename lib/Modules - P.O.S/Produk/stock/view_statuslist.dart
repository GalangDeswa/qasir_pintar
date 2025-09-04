import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../Config/config.dart';
import '../../../Controllers/CentralController.dart';
import '../../../Widget/widget.dart';
import 'controller_basemenustock.dart';

class ListStatusPenerimaan extends GetView<BasemenuStockController> {
  const ListStatusPenerimaan({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPenerimaanController>();
    return Column(
      children: [
        Obx(() {
          return customDatesearch(
              onReset: () {
                print('fetch ulang');
                con.fetchPenerimaanLocal(id_toko: con.id_toko);
              },
              sortValue: con.isAsc.value,
              onSortPressed: () {
                con.toggleSortPenerimaan();
              },
              onOkTap: () {
                print('custom dates');
                con.searchPenerimaanByDateLocal(
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
        SizedBox(
          height: 20,
        ),
        Container(
          //height: 100,
          //color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Riwayat Penerimaan'), Text('Aksi')],
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
            child: con.penerimaan.isNotEmpty || con.penerimaan != null
                ? Padding(
                    padding: AppPading.customListPadding(),
                    child: ListView.builder(
                      itemCount: con.penerimaan.length,
                      itemBuilder: (context, index) {
                        final penerimaan = con.penerimaan;

                        return custom_list(
                          usingGambar: false,
                          controller: controller,
                          trailing: Text(
                            'Total produk :' +
                                penerimaan[index].jumlahQty.toString(),
                            style: AppFont.small(),
                          ),
                          // trailing: customDropdown(
                          //     onSelected: (value) {
                          //       switch (value) {
                          //         case 'Ubah':
                          //           Get.toNamed('/editpaketproduk',
                          //               arguments: penerimaan[index]);
                          //           break;
                          //         case 'Hapus':
                          //           Popscreen().deletePaketProduk(
                          //               controller, penerimaan[index]);
                          //       }
                          //     },
                          //     dropdownColor: Colors.white, // Custom color
                          //     customButton: const Icon(Icons.menu),
                          //     items: [
                          //       {
                          //         'title': 'Ubah',
                          //         'icon': Icons.edit,
                          //         'color': AppColor.primary
                          //       },
                          //       {'divider': true},
                          //       {
                          //         'title': 'Hapus',
                          //         'icon': Icons.delete,
                          //         'color': AppColor.warning
                          //       },
                          //     ]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                penerimaan[index].tanggal.toString(),
                                style: AppFont.small(),
                              ),
                            ],
                          ),
                          title: penerimaan[index].nomorFaktur,
                          gestureroute: '/detail_penerimaan_produk',
                          gestureArgument: penerimaan[index],
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
