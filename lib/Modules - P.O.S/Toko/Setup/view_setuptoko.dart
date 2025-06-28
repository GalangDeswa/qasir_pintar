import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules - P.O.S/Toko/Setup/controller_setuptoko.dart';
import 'package:flutter/material.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';

class SetupToko extends GetView<SetupTokoController> {
  const SetupToko({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Informasi Usaha',
        NeedBottom: false,
      ),
      body: Form(
        key: controller.registerlocalKey.value,
        child: Padding(
          padding: AppPading.defaultBodyPadding(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Usaha',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Detail usaha anda'),
                          ],
                        ),
                      ),
                      Text("2/2"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.primary),
                      )),
                      Expanded(
                          child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColor.primary,
                        ),
                      ))
                    ],
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        controller.pikedImagePath.value == ''
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
                                        if (androidInfo.version.sdkInt >= 33) {
                                          var status =
                                              await Permission.camera.status;
                                          if (!status.isGranted) {
                                            await Permission.camera.request();
                                          }
                                        } else {
                                          var status =
                                              await Permission.camera.status;
                                          if (!status.isGranted) {
                                            await Permission.camera.request();
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
                                      child: Image.file(
                                        File(controller.pickedImageFile!.path),
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
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
                                          var status =
                                              await Permission.camera.status;
                                          if (!status.isGranted) {
                                            await Permission.camera.request();
                                          }
                                        } else {
                                          var status =
                                              await Permission.camera.status;
                                          if (!status.isGranted) {
                                            await Permission.camera.request();
                                          }
                                        }
                                        controller.pilihsourcefoto();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.secondary,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
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
                                  if (controller.pikedImagePath.value != '')
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
                                                color: Colors.black
                                                    .withOpacity(0.2),
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
                              ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.namausaha.value,
                      decoration: InputDecoration(
                        labelText: 'Nama usaha',
                        labelStyle: AppFont.regular(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Masukan nama usaha';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: DropdownButtonFormField2(
                      key: UniqueKey(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'jenis usaha harus diisi';
                        }
                        return null;
                      },
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white)),
                      hint: Text('Jenis Usaha', style: AppFont.regular()),
                      value: controller.jenisvalue,
                      items: controller.jenislistlocal.map((x) {
                        return DropdownMenuItem(
                          child: Text(x.nama!),
                          value: x.uuid,
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.jenisvalue = val;
                      },
                    ),
                  );
                }),
                button_solid_custom(
                    onPressed: () {
                      if (controller.registerlocalKey.value.currentState!
                          .validate()) {
                        controller.registerUserLocal();
                      }
                      //Get.toNamed('/setuptoko');
                      // Get.toNamed('/loginform');
                    },
                    child: Text(
                      'Daftar',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
