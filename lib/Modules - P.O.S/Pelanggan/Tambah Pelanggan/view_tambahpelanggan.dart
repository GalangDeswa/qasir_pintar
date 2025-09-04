import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import '../List kategori pelanggan/controller_kategoripelanggan.dart';
import 'controller_tambahpelanggan.dart';

class TambahPelanggan extends GetView<TambahPelangganController> {
  const TambahPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Pelanggan Baru',
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
                    return Container(
                      margin: AppPading.customBottomPadding(),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 0.5)),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 40, top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            controller.pikedImagePath.value == '' &&
                                    controller.pickedIconPath.value == ''
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.primary,
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.image,
                                          color: Colors.white,
                                          size: 55,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(8),
                                            backgroundColor: AppColor.secondary,
                                          ),
                                          onPressed: () async {
                                            DeviceInfoPlugin deviceInfo =
                                                DeviceInfoPlugin();
                                            AndroidDeviceInfo androidInfo =
                                                await deviceInfo.androidInfo;
                                            if (androidInfo.version.sdkInt >=
                                                33) {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            } else {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            }

                                            controller.pilihsourcefoto();
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.primary,
                                        ),
                                        child: ClipOval(
                                          child: controller.pikedImagePath != ''
                                              ? Image.file(
                                                  File(controller
                                                      .pickedImageFile!.path),
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                )
                                              : SvgPicture.asset(
                                                  controller
                                                      .pickedIconPath.value,
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(8),
                                            backgroundColor: AppColor.secondary,
                                          ),
                                          onPressed: () async {
                                            DeviceInfoPlugin deviceInfo =
                                                DeviceInfoPlugin();
                                            AndroidDeviceInfo androidInfo =
                                                await deviceInfo.androidInfo;
                                            if (androidInfo.version.sdkInt >=
                                                33) {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            } else {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            }

                                            controller.pilihsourcefoto();
                                          },
                                          child: FaIcon(
                                            FontAwesomeIcons.pencil,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_border_custom(
                        onPressed: () async {
                          if (await controller.checkContactPermission()) {
                            controller.selectContact();
                          } else {
                            Get.snackbar(
                              'Izin Diperlukan',
                              'Silakan berikan izin akses kontak terlebih dahulu',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Text('Tambah dari kontak'),
                        width: context.res_width),
                  ),
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama pelanggan harus disini';
                        }
                        return null;
                      },
                      controller: controller.nama.value,
                      keyboardType: TextInputType.text,
                      labelText: 'Nama pelanggan'),
                  customTextField(
                      controller: controller.email.value,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email (opsional)'),
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'nomor hp harus disini';
                        }
                        return null;
                      },
                      controller: controller.telepon.value,
                      keyboardType: TextInputType.phone,
                      labelText: 'Nomor hp'),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: customDropdownField(
                            validator: (value) {
                              if (value == null) {
                                return 'kategori harus dipilih';
                              }
                              return null;
                            },
                            hintText: 'Kategori pelanggan',
                            items: controller.kategoripelangganList.map((x) {
                              return DropdownMenuItem(
                                child: Text(x.kategori!),
                                value: x.uuid,
                              );
                            }).toList(),
                            value: controller.kategorivalue,
                            onChanged: (val) {
                              controller.kategorivalue = val;
                              print(controller.kategorivalue);
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.primary),
                            child: IconButton(
                                onPressed: () {
                                  Get.toNamed('/tambahkategoripelanggan',
                                      arguments: Get.put(
                                          KategoriPelangganController()));
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ))),
                      ],
                    );
                  }),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Container(
                      child: TextFormField(
                        style: AppFont.regular(),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Container(
                                        width: context.res_width * 0.9,
                                        height: context.res_height * 0.6,
                                        child:
                                            CalendarDatePicker2WithActionButtons(
                                          config:
                                              CalendarDatePicker2WithActionButtonsConfig(
                                            dayMaxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    7 -
                                                10,
                                            controlsTextStyle: TextStyle(
                                              fontSize: 10, // Adjust font size
                                              fontWeight: FontWeight
                                                  .bold, // Make it bold
                                              color: Colors
                                                  .blue, // Change text color
                                            ),

                                            // Adjust day width based on screen width
                                            weekdayLabelTextStyle:
                                                TextStyle(fontSize: 10),
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
                                            calendarType:
                                                CalendarDatePicker2Type.single,
                                          ),
                                          onCancelTapped: () {
                                            Get.back();
                                          },
                                          value: controller.datedata,
                                          onValueChanged: (dates) {
                                            print(dates);
                                            controller.datedata = dates;
                                            controller.stringdate();
                                            Get.back();
                                          },
                                        )),
                                  ));
                        },
                        controller: controller.tanggal.value,
                        onChanged: ((String pass) {}),
                        decoration: InputDecoration(
                          labelText: "Tanggal Lahir (opsional)",
                          labelStyle: AppFont.regular(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  customTextField(
                      controller: controller.alamat.value,
                      labelText: 'Alamat (opsional)'),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahPelangganLocal();
                        }
                        //Get.toNamed('/setuptoko');
                        // Get.toNamed('/loginform');
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
