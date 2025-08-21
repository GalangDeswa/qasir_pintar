import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/edit/controller_editpromo.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class EditPromo extends GetView<EditPromoController> {
  const EditPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Edit Promo',
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
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nama.value,
                        decoration: InputDecoration(
                          labelText: 'Kode Promo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'kode promo harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  Obx(
                    () {
                      // Update text field when radio changes
                      final isNominal = controller.selecteddiskon.value ==
                          controller.opsidiskon[0];
                      final currentValue = isNominal
                          ? controller.diskonnominal.value.toStringAsFixed(0)
                          : controller.diskonpersen.value.toStringAsFixed(0);

                      // Update controller text when value changes
                      if (controller.promovalue.value.text != currentValue) {
                        controller.promovalue.value.text = currentValue;
                      }

                      return Padding(
                        padding: AppPading.customBottomPadding(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.promovalue.value,
                                decoration: InputDecoration(
                                  prefixIcon: isNominal
                                      ? const Icon(Icons.money)
                                      : const Icon(Icons.percent),
                                  labelText: 'Nilai Promo',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Diskon harus diisi';
                                  final parsed = double.tryParse(value);
                                  if (parsed == null)
                                    return 'Masukkan angka valid';
                                  if (isNominal && parsed <= 0)
                                    return 'Nominal harus > 0';
                                  if (!isNominal &&
                                      (parsed <= 0 || parsed > 100)) {
                                    return 'Persen harus 1-100';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed == null) return;

                                  if (isNominal) {
                                    controller.diskonpersen.value = 0.0;
                                    controller.diskonnominal.value = parsed;
                                    print('nominal');
                                    print('nominal --> ' +
                                        controller.diskonnominal.value
                                            .toString() +
                                        'persen --> ' +
                                        controller.diskonpersen.value
                                            .toString());
                                  } else {
                                    controller.diskonnominal.value = 0.0;
                                    controller.diskonpersen.value = parsed;
                                    print('persen');
                                    print('nominal --> ' +
                                        controller.diskonnominal.value
                                            .toString() +
                                        'persen --> ' +
                                        controller.diskonpersen.value
                                            .toString());
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => Row(
                                  children: [
                                    Expanded(
                                      child: RadioMenuButton(
                                        value: controller.opsidiskon[0],
                                        groupValue:
                                            controller.selecteddiskon.value,
                                        onChanged: (x) {
                                          controller.selecteddiskon.value = x!;
                                        },
                                        child: const Text('Rp.'),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioMenuButton(
                                        value: controller.opsidiskon[1],
                                        groupValue:
                                            controller.selecteddiskon.value,
                                        onChanged: (x) {
                                          controller.selecteddiskon.value = x!;
                                        },
                                        child: const Text('%'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                                        controller.dateformat.format(start);
                                    controller.date2 =
                                        controller.dateformat.format(end);
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
                            labelText: "Masa Berlaku)",
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
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.keterangan.value,
                        decoration: InputDecoration(
                          labelText: 'Keterangan',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Alamat harus diisi';
                        //   }
                        //   return null;
                        // },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Aktif',
                            style: AppFont.regular(),
                          ),
                          Switch(
                            value: controller.isAktif.value,
                            onChanged: (value) {
                              controller.isAktif.value = value;
                              print(controller.isAktif.value);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.editPromoLocal();
                        }
                        //Get.toNamed('/setuptoko');
                        // Get.toNamed('/loginform');
                      },
                      child: Text(
                        'Edit',
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
