import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Karyawan/add/controller_tambahkaryawan.dart';

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
                      child: TextFormField(
                        obscureText: controller.showpin.value,
                        controller: controller.pin.value,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'PIN',
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
