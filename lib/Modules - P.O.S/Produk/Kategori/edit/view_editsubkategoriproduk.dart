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
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Sub Kategori dipilih';
                          }
                          return null;
                        },
                        isExpanded: true,
                        dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white)),
                        hint: Text('Sub Kategori', style: AppFont.regular()),
                        value: controller.kategorivalue,
                        items: controller.kategoriprodukList.map((x) {
                          return DropdownMenuItem(
                            child: Text(x.namakelompok!),
                            value: x.uuid,
                          );
                        }).toList(),
                        onChanged: (val) {
                          print('asdasdasdasd');
                          controller.kategorivalue = val;
                          print(controller.kategorivalue);
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nama.value,
                        decoration: InputDecoration(
                          labelText: 'Sub Kategori Produk',
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
