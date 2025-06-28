import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/controller_basemenustock.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/model_penerimaan.dart';

import '../../../Widget/widget.dart';

class Listpenerimaan extends GetView<BasemenuStockController> {
  const Listpenerimaan({super.key});

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
                  onChanged: (val) {
                    // controller.serachKategoriProdukLocal();
                  },
                  controller: controller.search.value,
                  decoration: InputDecoration(hintText: 'Pencarian'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                    onPressed: () {
                      Get.dialog(AlertDialog(
                        surfaceTintColor: Colors.white,
                        content: Container(
                          width: context.res_width,
                          //height: context.height_query / 1.5,
                          child: CalendarDatePicker2WithActionButtons(
                              config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                weekdayLabels: [
                                  'Minggu',
                                  'Senin',
                                  'Selasa',
                                  'Rabu',
                                  'Kamis',
                                  'Jumat',
                                  'Sabtu',
                                ],
                                firstDayOfWeek: 1,
                                weekdayLabelTextStyle: AppFont.small(),
                                dayTextStyle: AppFont.small(),
                                calendarType: CalendarDatePicker2Type.range,
                                selectedDayTextStyle: AppFont.small(),
                                selectedMonthTextStyle: AppFont.small(),
                                selectedYearTextStyle: AppFont.small(),
                                monthTextStyle: AppFont.small(),
                                yearTextStyle: AppFont.small(),
                                centerAlignModePicker: true,
                              ),
                              value: controller.dates,
                              onOkTapped: () {
                                controller.searchPenerimaanByDateLocal(
                                    id_toko: controller.id_toko,
                                    startDate: controller.date1,
                                    endDate: controller.date2);
                                Get.back();
                                print('tgl-----------------------------');
                              },
                              onValueChanged: (dates) {
                                var list = <String>[];
                                var start = dates.first;
                                final end = dates.last;
                                controller.pickdate.value.text =
                                    (controller.dateformat.format(start!) +
                                        ' - ' +
                                        controller.dateformat.format(end!));

                                controller.date1 =
                                    controller.dateformat.format(start);
                                controller.date2 =
                                    controller.dateformat.format(end);
                                print(controller.date1);
                                print(controller.date2);
                              }),
                        ),
                      ));
                    },
                    icon: Icon(Icons.calendar_month)),
              )
            ],
          ),
        ),
        // button_border_custom(
        //     margin: EdgeInsets.all(15),
        //     onPressed: () {
        //       Get.toNamed('/penerimaan_produk');
        //     },
        //     child: Text('Tambah Penerimaan'),
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
            child: controller.penerimaan.isNotEmpty ||
                    controller.penerimaan != null
                ? ListView.builder(
                    itemCount: controller.penerimaan.length,
                    itemBuilder: (context, index) {
                      final penerimaan = controller.penerimaan;

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
      BasemenuStockController controller, DataPenerimaanProduk data) {
    switch (item) {
      case MenuItems.Edit:
        print('edit');
        Get.toNamed('/editpaketproduk', arguments: data);
        break;
      case MenuItems.Hapus:
        // Popscreen().deleteKategoriProduk(controller, data);
        break;
    }
  }
}
