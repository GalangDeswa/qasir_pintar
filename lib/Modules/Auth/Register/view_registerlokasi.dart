import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qasir_pintar/Modules/Auth/Register/controller_register.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class RegisterLokasi extends GetView<RegisterController> {
  const RegisterLokasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Daftar',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerLokasiKey(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Daftar akun',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Informasi Lokasi'),
                          ],
                        ),
                      ),
                      Text("2/2"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.primary),
                      )),
                      Expanded(
                          child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.primary),
                      )),
                    ],
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.nama.value,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Alamat harus diisi';
                        }
                        return null;
                      },
                    ),
                  );
                }),
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
                          return 'Pilih provinsi';
                        }
                        return null;
                      },
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white)),
                      hint: Text('Pilih provinsi', style: AppFont.regular()),
                      value: controller.jenisvalue,
                      items: controller.jenislistlocal.map((x) {
                        return DropdownMenuItem(
                          child: Text(x),
                          value: x.toString(),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.jenisvalue = val!.toString();
                        print(controller.jenisvalue);
                      },
                    ),
                  );
                }),
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
                          return 'Pilih Kabupaten';
                        }
                        return null;
                      },
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white)),
                      hint: Text('Pilih Kabupaten', style: AppFont.regular()),
                      value: controller.jenisvalue,
                      items: controller.jenislistlocal.map((x) {
                        return DropdownMenuItem(
                          child: Text(x),
                          value: x.toString(),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.jenisvalue = val!.toString();
                        print(controller.jenisvalue);
                      },
                    ),
                  );
                }),
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
                          return 'Pilih Kecamatan';
                        }
                        return null;
                      },
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white)),
                      hint: Text('Pilih Kecamatan', style: AppFont.regular()),
                      value: controller.jenisvalue,
                      items: controller.jenislistlocal.map((x) {
                        return DropdownMenuItem(
                          child: Text(x),
                          value: x.toString(),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.jenisvalue = val!.toString();
                        print(controller.jenisvalue);
                      },
                    ),
                  );
                }),
                button_solid_custom(
                    onPressed: () {
                      if (controller.registerKey.value.currentState!
                          .validate()) {
                        controller.registerUser();
                        // Get.offAndToNamed('/setuptoko');
                      }
                    },
                    child: Text(
                      'Daftar',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
