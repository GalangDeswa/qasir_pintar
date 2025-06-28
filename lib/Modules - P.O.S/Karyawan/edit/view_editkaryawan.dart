import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/edit/controller_editkaryawan.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class EditKaryawan extends GetView<EditKaryawanController> {
  const EditKaryawan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Edit Karyawan',
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
                          labelText: 'Nama Karyawan',
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
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.telepon.value,
                        decoration: InputDecoration(
                          labelText: 'Nomor telepon',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nomor telepon harus diisi';
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
                        controller: controller.email.value,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email harus diisi';
                          }
                          return null;
                        },
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
                            'Ubah pin?',
                            style: AppFont.regular(),
                          ),
                          Switch(
                            value: controller.ubahpin.value,
                            onChanged: (value) {
                              controller.ubahpin.value = value;
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return controller.ubahpin.value == false
                        ? Container()
                        : Padding(
                            padding: AppPading.customBottomPadding(),
                            child: TextFormField(
                              obscureText: controller.showpin.value,
                              controller: controller.pinlama.value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'PIN lama',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: controller.showpin == false
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: () {
                                    controller.showpin.value =
                                        !controller.showpin.value;
                                    print(controller.showpin.value);
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'PIN harus diisi';
                                } else if (value.length < 6) {
                                  return 'PIN harus 6 digit';
                                } else if (value.length > 6) {
                                  return 'PIN tidak boleh lebih dari 6 digit';
                                }
                                if (value != controller.data.pin) {
                                  return 'PIN lama tidak sesuai';
                                }
                                return null; // Valid PIN
                              },
                            ),
                          );
                  }),
                  Obx(() {
                    return controller.ubahpin.value == false
                        ? Container()
                        : Padding(
                            padding: AppPading.customBottomPadding(),
                            child: TextFormField(
                              obscureText: controller.showpin.value,
                              controller: controller.pin.value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'PIN baru',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: controller.showpin == false
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: () {
                                    controller.showpin.value =
                                        !controller.showpin.value;
                                    print(controller.showpin.value);
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'PIN harus diisi';
                                } else if (value.length < 6) {
                                  return 'PIN harus 6 digit';
                                } else if (value.length > 6) {
                                  return 'PIN tidak boleh lebih dari 6 digit';
                                }
                                return null; // Valid PIN
                              },
                            ),
                          );
                  }),
                  Obx(() {
                    return controller.ubahpin.value == false
                        ? Container()
                        : Padding(
                            padding: AppPading.customBottomPadding(),
                            child: TextFormField(
                              obscureText: controller.showkonpin.value,
                              controller: controller.konpin.value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: controller.showkonpin == false
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: () {
                                    controller.showkonpin.value =
                                        !controller.showkonpin.value;
                                    print(controller.showkonpin.value);
                                  },
                                ),
                                labelText: 'Konfirmasi PIN',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value != controller.pin.value.text) {
                                  return 'PIN tidak sesuai';
                                }
                                return null;
                              },
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
                          controller.editKaryawanlocal();
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
