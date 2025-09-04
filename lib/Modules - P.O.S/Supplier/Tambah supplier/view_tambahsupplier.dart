import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:qasir_pintar/Modules - P.O.S/Supplier/Tambah%20supplier/controller_tambahsupllier.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class TambahSupplier extends GetView<TambahSupplierController> {
  const TambahSupplier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Tambah Supplier',
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
                          return 'Nama supplier harus disini';
                        }
                        return null;
                      },
                      controller: controller.nama.value,
                      labelText: 'Nama supplier'),
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor hp harus disini';
                        }
                        return null;
                      },
                      controller: controller.telepon.value,
                      keyboardType: TextInputType.phone,
                      labelText: 'Nomor hp'),
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat harus disini';
                        }
                        return null;
                      },
                      controller: controller.alamat.value,
                      labelText: 'Alamat'),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahSupplierLocal();
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
