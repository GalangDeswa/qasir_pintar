import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Laporan/Ringkasan%20penjualan/controller_ringkasanpenjualan.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';

class RingkasanPenjualan extends GetView<RingkasanPenjualanController> {
  const RingkasanPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Ringkasan Penjualan',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Container(
                //color: Colors.red,
                margin: AppPading.customBottomPadding(),
                //width: 200,
                child: TextFormField(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Get.dialog(AlertDialog(
                      surfaceTintColor: Colors.white,
                      content: Container(
                        width: context.res_width / 1.5,
                        //height: context.height_query / 1.5,
                        child: CalendarDatePicker2WithActionButtons(
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              weekdayLabels: [
                                'Ming',
                                'Sen',
                                'Sel',
                                'Rab',
                                'Kam',
                                'Jum',
                                'Sab',
                              ],
                              firstDayOfWeek: 1,
                              calendarType: CalendarDatePicker2Type.range,
                              centerAlignModePicker: true,
                            ),
                            value: controller.dates,
                            onOkTapped: () {
                              Get.back();
                              print('tgl-----------------------------');
                            },
                            onValueChanged: (dates) {
                              var start = dates.first;
                              final end = dates.last;
                              controller.pickdate.value.text =
                                  (controller.dateformat.format(start!) +
                                      ' - ' +
                                      controller.dateformat.format(end!));

                              controller.date1 = start;
                              controller.date2 = end;
                              print(controller.date1);
                              print(controller.date2);
                            }),
                      ),
                    ));
                  },
                  readOnly: true,
                  controller: controller.pickdate.value,
                  onChanged: ((String pass) {
                    // controller.fetchDataBeban();
                  }),
                  decoration: InputDecoration(
                      labelText: "Pilih tanggal",
                      labelStyle: AppFont.regular(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Pilih masa berlaku';
                    }
                    return null;
                  },
                ),
              );
            }),
            button_solid_custom(
                onPressed: () {
                  controller.fetchReport(
                      idToko: controller.id_toko,
                      dateFrom: controller.date1,
                      dateTo: controller.date2);
                },
                child: Text('Buat laporan'),
                width: Get.width),
            Obx(() {
              return controller.summary.isEmpty
                  ? Container()
                  : button_border_custom(
                      onPressed: () {
                        controller.createPDF();
                      },
                      child: Text(
                        'Cetak PDF',
                        style: AppFont.regular_bold(),
                      ),
                      width: Get.width);
            }),
            Container(
              height: 0.9,
              color: Colors.black,
              margin: EdgeInsets.only(bottom: 10),
              width: context.res_width,
            ),
            Obx(() {
              return controller.summary.isEmpty
                  ? Container(
                      child: Center(child: EmptyData()),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: Get.width,
                          color: AppColor.primary.withValues(alpha: 0.2),
                          child: Text(
                            controller.pickdate.value.text = (controller
                                    .dateformat
                                    .format(controller.date1!) +
                                ' - ' +
                                controller.dateformat
                                    .format(controller.date2!)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Obx(() {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "Total Penjualan",
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(AppFormat()
                                              .moneyFormat(controller.summary
                                                  .first.totalPenjualan)),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "Total Keuntungan",
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(AppFormat()
                                              .moneyFormat(controller.summary
                                                  .first.totalKeuntungan)),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                Divider(),
                                Obx(() {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "total tansaksi",
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(controller
                                              .summary.first.totalTransaksi
                                              .toString()),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "total produk",
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(controller
                                              .summary.first.totalProdukTerjual
                                              .toString()),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                Divider(),
                                Obx(() {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "total beban",
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(controller
                                              .summary.first.totalBeban
                                              .toString()),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "total jumlah beban",
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(AppFormat()
                                              .moneyFormat(controller.summary
                                                  .first.totalJumlahBeban)),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                Divider(),
                                Obx(() {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "Net profit",
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(AppFormat()
                                              .moneyFormat(
                                                  controller.netProfit.value)),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
            }),
          ],
        ),
      ),
    );
  }
}
