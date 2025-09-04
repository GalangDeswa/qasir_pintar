import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import 'controller_tambah_kategori_beban.dart';

class TambahKategoriBeban extends GetView<TambahKategoriBebanController> {
  const TambahKategoriBeban({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Tambah Kategori Beban',
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
                    controller: controller.nama.value,
                    labelText: 'Kategori beban',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kategori beban harus diisi';
                      }
                      return null;
                    },
                  ),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahKategoriBeban();
                        }
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
