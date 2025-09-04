import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/edit/controller_editkategoriproduk.dart';

import '../../../../Config/config.dart';
import '../../../../Widget/widget.dart';

class EditKategoriProduk extends GetView<EditKategoriProdukController> {
  const EditKategoriProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Edit Kategori',
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
                  Text(
                    'Foto / Ikon',
                    style: AppFont.regular(),
                  ),
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
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : controller.logo.value != null &&
                                              controller.logo.value != '-'
                                          ? controller.isBase64Svg(
                                                  controller.logo.value)
                                              ? ClipOval(
                                                  child: SvgPicture.memory(
                                                    base64Decode(
                                                        controller.logo.value),
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Image.memory(
                                                    base64Decode(
                                                        controller.logo.value),
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.contain,
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
                        return 'Nama kategori harus diisi';
                      }
                      return null;
                    },
                    controller: controller.nama.value,
                    labelText: 'Nama kategori',
                  ),
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
                          controller.editKategoriProduklocal();
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
