import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';
import '../Beban/model_beban_laporan.dart';
import 'controller_reversal_laporan.dart';
import 'model_reversal_laporan.dart';

class ReversalLaporan extends GetView<ReversalLaporanController> {
  const ReversalLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Laporan Reversal',
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
                                'Minggu',
                                'Senin',
                                'Selasa',
                                'Rabu',
                                'Kamis',
                                'Jumat',
                                'Sabtu',
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
                              var list = <String>[];
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
                  controller.fetchReportReversal(
                      idToko: controller.id_toko,
                      dateFrom: controller.date1,
                      dateTo: controller.date2);
                },
                child: Text('Buat laporan'),
                width: Get.width),
            Obx(() {
              return controller.summaryReversal.isEmpty
                  ? Container()
                  : button_border_custom(
                      onPressed: () {
                        controller.createPDF(
                          summaryList: controller.summaryReversal,
                          date1: controller.date1.toString(),
                          date2: controller.date2.toString(),
                        );
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
              final list = controller.summaryReversal;
              if (list.isEmpty) {
                return Center(child: EmptyData());
              }

              // 1) Group by date
              final Map<String, List<ReversalReportSummary>> byDate = {};
              final dateFmt = DateFormat('yyyy-MM-dd');
              for (final item in list) {
                // assume item.tanggalBeban is a DateTime
                final dayKey = dateFmt.format(item.tanggal);
                byDate.putIfAbsent(dayKey, () => []).add(item);
              }

              // 2) Sort the dates (optional)
              final sortedDates = byDate.keys.toList()
                ..sort((a, b) => b.compareTo(a)); // newest first

              // 3) Build the grouped list
              return Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedDates.length,
                    itemBuilder: (context, idx) {
                      final dateKey = sortedDates[idx];
                      final itemsForDay = byDate[dateKey]!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- DATE HEADER ---
                            Container(
                              padding: EdgeInsets.all(10),
                              width: Get.width,
                              color: AppColor.primary.withValues(alpha: 0.2),
                              child: Text(
                                DateFormat('EEEE, MMM d, yyyy')
                                    .format(DateTime.parse(dateKey)),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // --- LIST OF ITEMS FOR THAT DATE ---
                            ...itemsForDay.map((item) {
                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      // Row 1
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                "total reversal",
                                                style: AppFont.regular_bold(),
                                              ),
                                              subtitle: Text(item.countReversal
                                                  .toString()),
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                  "total nilai reversal",
                                                  style:
                                                      AppFont.regular_bold()),
                                              subtitle: Text(AppFormat()
                                                  .moneyFormat(
                                                      item.totalReversedValue)),
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // Row 2
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
