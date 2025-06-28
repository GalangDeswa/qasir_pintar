import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Tambah%20kategori%20pelanggan/controller_tambahkategoripelanggan.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class TambahKategoriPelanggan
    extends GetView<TambahKategoriPelangganController> {
  const TambahKategoriPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Kategori Baru',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    return Container(
                      margin: AppPading.customBottomPadding(),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 0.5)),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50, top: 50),
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
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nama.value,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Kategori harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahKategoriPelangganLocal();
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
