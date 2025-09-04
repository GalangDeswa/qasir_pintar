import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/edit/controller_edit_beban.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class EditBeban extends GetView<EditBebanController> {
  const EditBeban({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Edit Beban',
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
                          return 'Nama beban harus disini';
                        }
                        return null;
                      },
                      controller: controller.nama.value,
                      keyboardType: TextInputType.text,
                      labelText: 'Nama beban'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(() {
                          return customDropdownField(
                            hintText: 'Kategori beban',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kategori harus dipilih';
                              }
                              return null;
                            },
                            items: controller.con.listKategoriBeban
                                .where((y) => y.aktif == 1)
                                .map((x) {
                              return DropdownMenuItem(
                                child: Text(x.namaKategoriBeban!),
                                value: x.uuid,
                              );
                            }).toList(),
                            value: controller.kategorivalue.value,
                            onChanged: (val) async {
                              controller.kategorivalue.value = val.toString();
                            },
                          );
                        }),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: AppColor.primary),
                          child: IconButton(
                              onPressed: () {
                                Get.toNamed('/tambah_kategori_beban');
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ))),
                    ],
                  ),
                  customTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah beban harus diisi';
                        }
                        return null;
                      },
                      controller: controller.jumlahbeban.value,
                      labelText: 'Jumlah beban',
                      inputFormatters: [ThousandsFormatter()],
                      keyboardType: TextInputType.number),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Container(
                        child: TextFormField(
                          style: AppFont.regular(),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      content: Container(
                                          width: context.res_width * 0.9,
                                          height: context.res_height * 0.6,
                                          child:
                                              CalendarDatePicker2WithActionButtons(
                                            config:
                                                CalendarDatePicker2WithActionButtonsConfig(
                                              dayMaxWidth:
                                                  MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          7 -
                                                      10,
                                              controlsTextStyle: TextStyle(
                                                fontSize: 10,
                                                // Adjust font size
                                                fontWeight: FontWeight.bold,
                                                // Make it bold
                                                color: Colors
                                                    .blue, // Change text color
                                              ),

                                              // Adjust day width based on screen width
                                              weekdayLabelTextStyle:
                                                  TextStyle(fontSize: 10),
                                              weekdayLabels: [
                                                'Ming',
                                                'Sen',
                                                'Sel',
                                                'Rab',
                                                'Kam',
                                                'Jum',
                                                'Sab',
                                              ],
                                              firstDayOfWeek: 1,

                                              calendarType:
                                                  CalendarDatePicker2Type
                                                      .single,
                                            ),
                                            onCancelTapped: () {
                                              Get.back();
                                            },
                                            value: controller.datedata,
                                            onValueChanged: (dates) {
                                              print(dates);
                                              controller.datedata = dates;
                                              controller.stringdate();
                                              Get.back();
                                            },
                                          )),
                                    ));
                          },
                          controller: controller.tanggal.value,
                          onChanged: ((String pass) {}),
                          decoration: InputDecoration(
                            labelText: "Tanggal beban",
                            labelStyle: AppFont.regular(),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Pilih tanggal beban';
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  }),
                  customTextField(
                    controller: controller.keterangan.value,
                    labelText: 'Keterangan beban',
                    validator: (value) {
                      print('print value validator');
                      print(value);
                      if (value == null || value.isEmpty) {
                        return 'keterangan harus dipilih';
                      }
                      return null;
                    },
                  ),
                  customDropdownField(
                    validator: (value) {
                      if (value == null) {
                        return 'Karyawan harus dipilih';
                      }
                      return null;
                    },
                    hintText: 'Ditambah oleh',
                    items: controller.conKar.karyawanList.map((x) {
                      return DropdownMenuItem(
                        child: Text(x.nama_karyawan!),
                        value: x.uuid,
                      );
                    }).toList(),
                    value: controller.karyawanvalue.value,
                    onChanged: (val) async {
                      controller.karyawanvalue.value = val.toString();
                    },
                  ),
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
                          controller.editBebanLocal();
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
