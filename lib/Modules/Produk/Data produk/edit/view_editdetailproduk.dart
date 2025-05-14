import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

import '../../../../Config/config.dart';
import '../../../../Widget/widget.dart';
import 'controller_editdetailproduk.dart';
import 'controller_editisiproduk.dart';

class EditPajakProduk extends GetView<EditDetailProdukController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Edit pajak', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: Form(
          key: controller.pajakkey.value,
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.namaPajak.value,
                    decoration: InputDecoration(
                      labelText: 'Nama Pajak',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama Pajak harus diisi';
                      }
                      return null;
                    },
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.nominalPajak.value,
                    inputFormatters: [ThousandsFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Nominal Pajak',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nominal Pajak harus diisi';
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
                        value: controller.isAktifpajak.value,
                        onChanged: (value) {
                          controller.isAktifpajak.value = value;
                          print(controller.isAktifpajak.value);
                        },
                      ),
                    ],
                  ),
                );
              }),
              button_solid_custom(
                  onPressed: () {
                    if (controller.pajakkey.value.currentState!.validate()) {
                      controller.editpajaklocal();
                    }
                  },
                  child: Text('Edit'),
                  width: context.res_width)
            ],
          ),
        ),
      ),
    );
  }
}

class EditUkuranProduk extends GetView<EditDetailProdukController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Edit ukuran', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: Form(
          key: controller.ukurankey.value,
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller.ukuranProduk.value,
                    decoration: InputDecoration(
                      labelText: 'Ukuran',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ukuran harus diisi';
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
                        value: controller.isAktifukuran.value,
                        onChanged: (value) {
                          controller.isAktifukuran.value = value;
                        },
                      ),
                    ],
                  ),
                );
              }),
              button_solid_custom(
                  onPressed: () {
                    if (controller.ukurankey.value.currentState!.validate()) {
                      controller.editukuranlocal();
                    }
                  },
                  child: Text('Edit'),
                  width: context.res_width)
            ],
          ),
        ),
      ),
    );
  }
}
