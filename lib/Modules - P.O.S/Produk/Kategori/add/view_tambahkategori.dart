import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/add/controller_tambahkategori.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../../../Config/config.dart';

class TambahSubKategori extends GetView<TambahSubKategoriController> {
  const TambahSubKategori({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Tambah Sub Kategori',
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
                      validator: (value) {
                        if (value == null) {
                          return 'kategori harus dipilih';
                        }
                        return null;
                      },
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
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahSubKategoriProdukLocal();
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
