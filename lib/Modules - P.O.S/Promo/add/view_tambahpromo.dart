import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/add/controller_tambahpromo.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class TambahPromo extends GetView<TambahPromoController> {
  const TambahPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Tambah Promo',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama promo harus disini';
                        }
                        return null;
                      },
                      controller: controller.nama.value,
                      keyboardType: TextInputType.text,
                      labelText: 'Nama promo'),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Obx(() {
                            return TextFormField(
                              style: AppFont.regular(),
                              inputFormatters: [ThousandsFormatter()],
                              controller: controller.promovalue.value,
                              decoration: InputDecoration(
                                prefixIcon: controller.selecteddiskon.value ==
                                        controller.opsidiskon[0]
                                    ? const Icon(Icons.attach_money)
                                    : const Icon(Icons.percent),
                                labelText: 'Nilai Promo',
                                labelStyle: AppFont.regular(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Diskon harus diisi';
                                final parsed = double.tryParse(
                                    value.replaceAll(RegExp(r'[^0-9.]'), ''));
                                if (parsed == null)
                                  return 'Masukkan angka valid';
                                if (controller.selecteddiskon.value ==
                                        controller.opsidiskon[0] &&
                                    parsed <= 0) {
                                  return 'Nominal harus > 0';
                                }
                                if (controller.selecteddiskon.value !=
                                        controller.opsidiskon[0] &&
                                    (parsed <= 0 || parsed > 100)) {
                                  return 'Persen harus 1-100';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                final cleanValue =
                                    value.replaceAll(RegExp(r'[^0-9.]'), '');
                                final parsed = double.tryParse(cleanValue);
                                if (parsed == null) return;

                                if (controller.selecteddiskon.value ==
                                    controller.opsidiskon[0]) {
                                  controller.diskonpersen.value = 0.0;
                                  controller.diskonnominal.value = parsed;
                                  print('nominal');
                                  print('nominal --> ' +
                                      controller.diskonnominal.value
                                          .toString() +
                                      'persen --> ' +
                                      controller.diskonpersen.value.toString());
                                } else {
                                  controller.diskonnominal.value = 0.0;
                                  controller.diskonpersen.value = parsed;
                                  print('persen');
                                  print('nominal --> ' +
                                      controller.diskonnominal.value
                                          .toString() +
                                      'persen --> ' +
                                      controller.diskonpersen.value.toString());
                                }
                              },
                            );
                          }),
                        ),
                        Expanded(
                          child: Obx(() {
                            return Row(
                              children: [
                                Expanded(
                                  child: RadioMenuButton(
                                    value: controller.opsidiskon[0],
                                    groupValue: controller.selecteddiskon.value,
                                    onChanged: (x) =>
                                        controller.selecteddiskon.value = x!,
                                    child: const Text('Rp.'),
                                  ),
                                ),
                                Expanded(
                                  child: RadioMenuButton(
                                    value: controller.opsidiskon[1],
                                    groupValue: controller.selecteddiskon.value,
                                    onChanged: (x) =>
                                        controller.selecteddiskon.value = x!,
                                    child: const Text('%'),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return Container(
                      //color: Colors.red,
                      margin: AppPading.customBottomPadding(),
                      //width: 200,
                      child: TextFormField(
                        style: AppFont.regular(),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Get.dialog(AlertDialog(
                            surfaceTintColor: Colors.white,
                            content: Container(
                              width: context.res_width / 1.5,
                              //height: context.height_query / 1.5,
                              child: CalendarDatePicker2WithActionButtons(
                                  config:
                                      CalendarDatePicker2WithActionButtonsConfig(
                                    controlsTextStyle:
                                        const TextStyle(fontSize: 10),
                                    weekdayLabels: [
                                      'Min',
                                      'Sen',
                                      'Sel',
                                      'Rab',
                                      'Kam',
                                      'Jum',
                                      'Sab',
                                    ],
                                    weekdayLabelTextStyle:
                                        const TextStyle(fontSize: 10),
                                    firstDayOfWeek: 1,
                                    calendarType: CalendarDatePicker2Type.range,
                                    centerAlignModePicker: true,
                                  ),
                                  value: controller.dates,
                                  onCancelTapped: () {
                                    Get.back();
                                  },
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

                                    controller.date1 =
                                        AppFormat().dateISO(start);
                                    controller.date2 = AppFormat().dateISO(end);
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
                            labelText: "Masa Berlaku",
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
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'keterangan harus disini';
                        }
                        return null;
                      },
                      controller: controller.keterangan.value,
                      labelText: 'Keterangan'),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahPromo();
                        }
                      },
                      child: Text(
                        'Tambah',
                        style: AppFont.regular_white_bold(),
                      ),
                      width: context.res_width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
