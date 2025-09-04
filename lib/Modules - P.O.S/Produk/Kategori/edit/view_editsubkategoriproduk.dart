import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/edit/controller_editsubkategoriproduk.dart';

import '../../../../Config/config.dart';
import '../../../../Widget/widget.dart';

class EditSubKategoriProduk extends GetView<EditSubKategoriProdukController> {
  const EditSubKategoriProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Edit Sub Kategori',
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
                    return customDropdownField(
                      hintText: 'Kategori produk',
                      items: controller.kategoriprodukList.map((x) {
                        return DropdownMenuItem(
                          child: Text(x.namakelompok!),
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

                  //TODO custom fom pajak dll
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sub kategori harus disini';
                        }
                        return null;
                      },
                      controller: controller.nama.value,
                      keyboardType: TextInputType.text,
                      labelText: 'Sub kategori produk'),
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
                          controller.editSubKategoriProduklocal();
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
