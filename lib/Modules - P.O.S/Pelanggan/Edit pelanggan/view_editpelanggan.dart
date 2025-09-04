import 'dart:convert';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Edit%20pelanggan/controller_editpelanggan.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class EditPelanggan extends GetView<EditPelangganController> {
  const EditPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Edit Pelanggan',
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Obx(() {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: controller.pikedImagePath.value != ''
                                  ? ClipOval(
                                      child: Image.file(
                                        File(controller.pickedImageFile!.path),
                                        width: 140,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : controller.pickedIconPath.value != ''
                                      ? ClipOval(
                                          child: SvgPicture.asset(
                                            controller.pickedIconPath.value,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : controller.logo.value != '-'
                                          ? controller.isBase64Svg(
                                                  controller.logo.value)
                                              ? ClipOval(
                                                  child: SvgPicture.memory(
                                                    base64Decode(
                                                        controller.logo.value),
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Image.memory(
                                                    base64Decode(
                                                        controller.logo.value),
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                          : Icon(
                                              FontAwesomeIcons.image,
                                              color: Colors.white,
                                              size: 60,
                                            ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  DeviceInfoPlugin deviceInfo =
                                      DeviceInfoPlugin();
                                  AndroidDeviceInfo androidInfo =
                                      await deviceInfo.androidInfo;
                                  if (androidInfo.version.sdkInt >= 33) {
                                    var status = await Permission.camera.status;
                                    if (!status.isGranted) {
                                      await Permission.camera.request();
                                    }
                                  } else {
                                    var status = await Permission.camera.status;
                                    if (!status.isGranted) {
                                      await Permission.camera.request();
                                    }
                                  }
                                  controller.pilihsourcefoto();
                                  // Popscreen().pilihSourceFoto(
                                  //     camera: controller.pickImageCamera(),
                                  //     galery: controller.pickImageGallery(),
                                  //     ikon: controller.pilihIcon(context));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.secondary,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    controller.pikedImagePath.value == ''
                                        ? Icons.add
                                        : FontAwesomeIcons.pencil,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            if (controller.pikedImagePath.value != '' ||
                                controller.logo.value != '-' ||
                                controller.logo.value != null)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // Call a method in the controller to delete the image
                                    controller.deleteImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors
                                          .red, // Red color for delete button
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        );
                      }),
                    ),
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
                    return customDropdownField(
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
                          controller.editPelangganLocal();
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
