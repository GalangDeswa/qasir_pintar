import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import 'controller_kategori_edit.dart';

class EditKategoriBeban extends GetView<EditKategoriBebanController> {
  const EditKategoriBeban({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Edit Kategori',
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
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Aktif'),
                          Switch(
                            value: controller.aktif.value,
                            onChanged: (value) {
                              controller.aktif.value = value;
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
                          controller.editKategoriLocal();
                        }
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
