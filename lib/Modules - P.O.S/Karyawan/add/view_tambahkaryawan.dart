import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/add/controller_tambahkaryawan.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class TambahKaryawan extends GetView<TambahKaryawanController> {
  const TambahKaryawan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Tambah Karyawan',
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
                          return 'Nama karyawan harus disini';
                        }
                        return null;
                      },
                      controller: controller.nama.value,
                      labelText: 'Nama karyawan'),
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor hp harus disini';
                        }
                        return null;
                      },
                      controller: controller.telepon.value,
                      keyboardType: TextInputType.phone,
                      labelText: 'Nomor Hp'),
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email harus disini';
                        }
                        return null;
                      },
                      controller: controller.email.value,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email'),
                  Obx(() {
                    return customDropdownField(
                      validator: (value) {
                        if (value == null) {
                          return 'jabatan harus disini';
                        }
                        return null;
                      },
                      hintText: 'Pilih jabatan',
                      items: controller.rolelist.map((x) {
                        return DropdownMenuItem(
                          child: Text(x),
                          value: x,
                        );
                      }).toList(),
                      value: controller.rolevalue,
                      onChanged: (val) async {
                        controller.rolevalue = val;
                      },
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        style: AppFont.regular(),
                        obscureText: controller.showpin.value,
                        controller: controller.pin.value,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'PIN',
                          labelStyle: AppFont.regular(),
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
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        style: AppFont.regular(),
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
                          labelStyle: AppFont.regular(),
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
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahKaryawanLocal();
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
