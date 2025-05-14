import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Promo/controller_promo.dart';

import '../../Config/config.dart';
import '../../Widget/widget.dart';
import 'controller_detailpromo.dart';

class DetailPromo extends GetView<DetailPromoController> {
  const DetailPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Detail Promo',
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
                  // Obx(() {
                  //   return Padding(
                  //     padding: EdgeInsets.only(bottom: 100, top: 50),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         controller.pikedImagePath.value == '' &&
                  //             controller.pickedIconPath.value == ''
                  //             ? Stack(
                  //           alignment: Alignment.center,
                  //           children: [
                  //             Container(
                  //               width: 120,
                  //               height: 120,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: AppColor.primary,
                  //               ),
                  //               child: Icon(
                  //                 FontAwesomeIcons.image,
                  //                 color: Colors.white,
                  //                 size: 55,
                  //               ),
                  //             ),
                  //             Positioned(
                  //               bottom: 0,
                  //               right: 0,
                  //               child: TextButton(
                  //                 style: TextButton.styleFrom(
                  //                   shape: CircleBorder(),
                  //                   padding: EdgeInsets.all(8),
                  //                   backgroundColor: AppColor.secondary,
                  //                 ),
                  //                 onPressed: () async {
                  //                   DeviceInfoPlugin deviceInfo =
                  //                   DeviceInfoPlugin();
                  //                   AndroidDeviceInfo androidInfo =
                  //                   await deviceInfo.androidInfo;
                  //                   if (androidInfo.version.sdkInt >=
                  //                       33) {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   } else {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   }
                  //
                  //                   controller.pilihsourcefoto();
                  //                 },
                  //                 child: Icon(
                  //                   Icons.add,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //             : Stack(
                  //           alignment: Alignment.center,
                  //           children: [
                  //             Container(
                  //               width: 120,
                  //               height: 120,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: AppColor.primary,
                  //               ),
                  //               child: ClipOval(
                  //                 child: controller.pikedImagePath != ''
                  //                     ? Image.file(
                  //                   File(controller
                  //                       .pickedImageFile!.path),
                  //                   width: 120,
                  //                   height: 120,
                  //                   fit: BoxFit.cover,
                  //                 )
                  //                     : SvgPicture.asset(
                  //                   controller.pickedIconPath.value,
                  //                   width: 120,
                  //                   height: 120,
                  //                   fit: BoxFit.contain,
                  //                 ),
                  //               ),
                  //             ),
                  //             Positioned(
                  //               bottom: 0,
                  //               right: 0,
                  //               child: TextButton(
                  //                 style: TextButton.styleFrom(
                  //                   shape: CircleBorder(),
                  //                   padding: EdgeInsets.all(8),
                  //                   backgroundColor: AppColor.secondary,
                  //                 ),
                  //                 onPressed: () async {
                  //                   DeviceInfoPlugin deviceInfo =
                  //                   DeviceInfoPlugin();
                  //                   AndroidDeviceInfo androidInfo =
                  //                   await deviceInfo.androidInfo;
                  //                   if (androidInfo.version.sdkInt >=
                  //                       33) {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   } else {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   }
                  //
                  //                   controller.pilihsourcefoto();
                  //                 },
                  //                 child: FaIcon(
                  //                   FontAwesomeIcons.pencil,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }),
                  // Padding(
                  //   padding: AppPading.customBottomPadding(),
                  //   child: button_border_custom(
                  //       onPressed: () async {
                  //         if (await controller.checkContactPermission()) {
                  //           controller.selectContact();
                  //         } else {
                  //           Get.snackbar(
                  //             'Izin Diperlukan',
                  //             'Silakan berikan izin akses kontak terlebih dahulu',
                  //             snackPosition: SnackPosition.BOTTOM,
                  //           );
                  //         }
                  //       },
                  //       child: Text('Tambah dari kontak'),
                  //       width: context.res_width),
                  // ),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nama.value,
                        decoration: InputDecoration(
                          labelText: 'Nama Promo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama harus diisi';
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
                          ? controller.diskonnominal.value.toString()
                          : controller.diskonpersen.value.toString();

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
                                    controller.diskonnominal.value = parsed;
                                  } else {
                                    controller.diskonpersen.value = parsed;
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
                  // button_solid_custom(
                  //     onPressed: () {
                  //       if (controller.registerKey.value.currentState!
                  //           .validate()) {
                  //         controller.tambahPromo();
                  //       }
                  //       //Get.toNamed('/setuptoko');
                  //       // Get.toNamed('/loginform');
                  //     },
                  //     child: Text(
                  //       'Tambah',
                  //       style: AppFont.regular_white_bold(),
                  //     ),
                  //     width: context.res_width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
