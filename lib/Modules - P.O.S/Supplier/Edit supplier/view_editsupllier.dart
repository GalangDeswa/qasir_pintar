import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/Edit%20supplier/controller_editsupplier.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class EditSupplier extends GetView<EditSupplierController> {
  const EditSupplier({super.key});

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
                          controller.editSupplierlocal();
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
