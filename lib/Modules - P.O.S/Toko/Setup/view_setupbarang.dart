import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules - P.O.S/Toko/Setup/controller_setuptoko.dart';
import 'package:flutter/material.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../Config/config.dart';

class SetupBarang extends GetView<SetupTokoController> {
  const SetupBarang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarCustom(
          title: "Informasi usaha",
          NeedBottom: false,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buat Produk Pertama',
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
                              // TextSpan(
                              //     text:
                              //         'Info produk dapat diatur ulang dimenu pengaturan'),
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
                              color: Colors.grey),
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
                    return Expanded(
                      child: Row(
                        children: [
                          controller.checkfoto == false
                              ? Expanded(
                                  child: Container(
                                    // color: Colors.red,
                                    // width: 100,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            //color: Colors.green,
                                            // width: 80,
                                            child: ListTile(
                                              title: Text('Foto produk',
                                                  style: AppFont.regular()),
                                              subtitle: Text(
                                                'opsional',
                                                style: AppFont.regular(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Checkbox(
                                          value: controller.checkfoto.value,
                                          onChanged: (bool? value) {
                                            controller.checkfoto.value = value!;
                                            if (controller.checkfoto.value ==
                                                false) {
                                              controller.pikedImagePath.value =
                                                  '';
                                              controller.image64 = null;
                                            }
                                            print(controller.checkfoto.value);
                                            // controller.check == true;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  // width: 40,
                                  child: Checkbox(
                                    value: controller.checkfoto.value,
                                    onChanged: (bool? value) {
                                      controller.checkfoto.value = value!;
                                      if (controller.checkfoto.value == false) {
                                        controller.pikedImagePath.value = '';
                                        controller.image64 = null;
                                      }
                                      print(controller.checkfoto.value);
                                      // controller.check == true;
                                    },
                                  ),
                                ),
                          controller.checkfoto.value == false
                              ? Container()
                              : controller.pikedImagePath.value == ''
                                  ? Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            // margin: EdgeInsets.only(left: 10),
                                            width: 80,
                                            height: 80,
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColor.secondary,
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.image,
                                              color: Colors.white,
                                              size: 70,
                                            ),
                                          ),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      AppColor.secondary),
                                              onPressed: () async {
                                                DeviceInfoPlugin deviceInfo =
                                                    DeviceInfoPlugin();
                                                AndroidDeviceInfo androidInfo =
                                                    await deviceInfo
                                                        .androidInfo;
                                                if (androidInfo
                                                        .version.sdkInt >=
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
                                              child: Text('Tambah foto')),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              width: 80,
                                              height: 80,
                                              child: Image.file(
                                                File(controller
                                                    .pickedImageFile!.path),
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      AppColor.secondary),
                                              onPressed: () async {
                                                DeviceInfoPlugin deviceInfo =
                                                    DeviceInfoPlugin();
                                                AndroidDeviceInfo androidInfo =
                                                    await deviceInfo
                                                        .androidInfo;
                                                if (androidInfo
                                                        .version.sdkInt >=
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
                                              child: Text('Tambah foto'))
                                        ],
                                      ),
                                    ),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return TextField(
                      controller: controller.emailController.value,
                      decoration: InputDecoration(
                        labelText: 'Nama Produk',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    );
                  }),
                  SizedBox(height: 16.0),
                  Obx(() {
                    return TextField(
                      controller: controller.passwordController.value,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      obscureText: true,
                    );
                  }),
                  SizedBox(height: 16.0),
                  Obx(() {
                    return TextField(
                      controller: controller.passwordController.value,
                      decoration: InputDecoration(
                        labelText: 'satuan',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      obscureText: true,
                    );
                  }),
                  SizedBox(height: 16.0),
                  Obx(() {
                    return TextField(
                      controller: controller.passwordController.value,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      obscureText: true,
                    );
                  }),
                  SizedBox(height: 16.0),
                  Obx(() {
                    return TextField(
                      controller: controller.passwordController.value,
                      decoration: InputDecoration(
                        labelText: 'Harga jual',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      obscureText: true,
                    );
                  }),
                  SizedBox(height: 16.0),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: context.res_width * 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.secondary),
                      onPressed: () {
                        Get.offAndToNamed('/otp');
                      },
                      child: Text('Simpan'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ])));
  }
}
