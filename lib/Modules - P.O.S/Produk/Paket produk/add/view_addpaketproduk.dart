import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/model_produk.dart';

import '../../../../Config/config.dart';
import '../../../../Controllers/CentralController.dart';
import '../../../../Widget/widget.dart';

import 'controller_addpaketproduk.dart';

class TambahPaketProduk extends GetView<TambahPaketProdukController> {
  const TambahPaketProduk({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralProdukController>();
    return Scaffold(
      appBar: AppbarCustom(title: 'Tambah Paket', NeedBottom: false),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey2.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.pikedImagePath.value == '' &&
                                  controller.pickedIconPath.value == ''
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    DashedBorderContainer(
                                      child: Icon(
                                        FontAwesomeIcons.image,
                                        color: AppColor.primary,
                                        size: 55,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(8),
                                          backgroundColor: AppColor.secondary,
                                        ),
                                        onPressed: () async {
                                          DeviceInfoPlugin deviceInfo =
                                              DeviceInfoPlugin();
                                          AndroidDeviceInfo androidInfo =
                                              await deviceInfo.androidInfo;
                                          if (androidInfo.version.sdkInt >=
                                              33) {
                                            var status =
                                                await Permission.camera.status;
                                            if (!status.isGranted) {
                                              await Permission.camera.request();
                                            }
                                          } else {
                                            var status =
                                                await Permission.camera.status;
                                            if (!status.isGranted) {
                                              await Permission.camera.request();
                                            }
                                          }

                                          controller.pilihsourcefoto();
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                          // shape: BoxShape.circle,
                                          // color: AppColor.primary,
                                          ),
                                      child: controller.pikedImagePath != ''
                                          ? Image.file(
                                              File(controller
                                                  .pickedImageFile!.path),
                                              width: 85,
                                              height: 85,
                                              fit: BoxFit.cover,
                                            )
                                          : SvgPicture.asset(
                                              controller.pickedIconPath.value,
                                              width: 85,
                                              height: 85,
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 50,
                                      child: IconButton(
                                        iconSize: 15,
                                        visualDensity: VisualDensity.compact,
                                        style: TextButton.styleFrom(
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(0),
                                          backgroundColor: AppColor.secondary,
                                        ),
                                        onPressed: () async {
                                          DeviceInfoPlugin deviceInfo =
                                              DeviceInfoPlugin();
                                          AndroidDeviceInfo androidInfo =
                                              await deviceInfo.androidInfo;
                                          if (androidInfo.version.sdkInt >=
                                              33) {
                                            var status =
                                                await Permission.camera.status;
                                            if (!status.isGranted) {
                                              await Permission.camera.request();
                                            }
                                          } else {
                                            var status =
                                                await Permission.camera.status;
                                            if (!status.isGranted) {
                                              await Permission.camera.request();
                                            }
                                          }

                                          controller.pilihsourcefoto();
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.pencil,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20),
                Padding(
                  padding: AppPading.customBottomPadding(),
                  child: button_solid_custom(
                      onPressed: () {
                        controller.popaddprodukv2();
                      },
                      child: Text('Tambah produk kedalam paket'),
                      width: context.res_width),
                ),
                Obx(() {
                  return controller.produktemp.isEmpty
                      ? Container()
                      : Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black, width: 0.5)),
                              height: 200,
                              margin: AppPading.customBottomPadding(),
                              child: controller.produktemp.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: controller.produktemp.length,
                                      itemBuilder: (context, index) {
                                        final customer = controller.produktemp;

                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ListTile(
                                                    leading: customer[index]
                                                                    .gambar_produk_utama !=
                                                                '' &&
                                                            customer[index]
                                                                    .gambar_produk_utama !=
                                                                null
                                                        ? controller.isBase64Svg(
                                                                customer[index]
                                                                    .gambar_produk_utama!)
                                                            ? SvgPicture.memory(
                                                                base64Decode(customer[
                                                                        index]
                                                                    .gambar_produk_utama!),
                                                                width: 30,
                                                                height: 30,
                                                                fit: BoxFit
                                                                    .contain,
                                                              )
                                                            : Image.memory(
                                                                base64Decode(customer[
                                                                        index]
                                                                    .gambar_produk_utama!),
                                                                width: 30,
                                                                height: 30,
                                                                fit: BoxFit
                                                                    .contain,
                                                              )
                                                        : Image.asset(
                                                            AppString
                                                                .defaultImg,
                                                            width: 30,
                                                            height: 30,
                                                            fit: BoxFit.contain,
                                                          ),
                                                    title: Text(
                                                      customer[index]
                                                          .nama_produk!,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      'Qty : ' +
                                                          customer[index]
                                                              .qty
                                                              .toString(),
                                                      style: AppFont.small(),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Modal : ' +
                                                              AppFormat().numFormat(
                                                                  customer[
                                                                          index]
                                                                      .harga_beli),
                                                          style:
                                                              AppFont.small(),
                                                        ),
                                                        Text(
                                                            'HPP : ' +
                                                                AppFormat().numFormat(
                                                                    customer[
                                                                            index]
                                                                        .hpp),
                                                            style:
                                                                AppFont.small())
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    iconSize: 20.0,
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    onPressed: () {
                                                      print(
                                                          'min-------------->');
                                                      customer[index].qty--;

                                                      // Get the individual product values to subtract
                                                      final hargaBeliPerItem =
                                                          customer[index]
                                                              .harga_beli!;
                                                      final hppPerItem =
                                                          customer[index].hpp!;

                                                      // Subtract from totals
                                                      controller.harga_modal
                                                              .value -=
                                                          hargaBeliPerItem;
                                                      controller.harga_hpp
                                                          .value -= hppPerItem;

                                                      controller.hargaModal
                                                              .value.text =
                                                          AppFormat().numFormat(
                                                              controller
                                                                  .harga_modal
                                                                  .value);
                                                      controller
                                                              .hpp.value.text =
                                                          AppFormat().numFormat(
                                                              controller
                                                                  .harga_hpp
                                                                  .value);

                                                      if (customer[index].qty <=
                                                          0) {
                                                        var x = customer
                                                            .removeAt(index);
                                                        controller
                                                            .deletedDetailIds
                                                            .add(x.uuid!);
                                                        controller.produktemp
                                                            .refresh();
                                                      }

                                                      controller.produktemp
                                                          .refresh();
                                                    },
                                                    icon: Icon(Icons.remove)),
                                                IconButton(
                                                    iconSize: 20.0,
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    onPressed: () {
                                                      var check = con.produk
                                                          .where((element) =>
                                                              element.uuid ==
                                                              customer[index]
                                                                  .uuid)
                                                          .first;
                                                      final existingIndex =
                                                          controller.produktemp
                                                              .indexWhere((item) =>
                                                                  item.uuid ==
                                                                  customer[
                                                                          index]
                                                                      .uuid);
                                                      if (check.qty == 0 &&
                                                          check.hitung_stok ==
                                                              1 &&
                                                          check.tampilkan_di_produk ==
                                                              1) {
                                                        Get.showSnackbar(toast()
                                                            .bottom_snackbar_error(
                                                                "Error",
                                                                'Stock sudah habis! harap isi stock terlebih dahulu'));
                                                        return;
                                                      }
                                                      if (controller
                                                                  .produktemp[
                                                                      existingIndex]
                                                                  .qty >=
                                                              check.qty! &&
                                                          check.tampilkan_di_produk ==
                                                              1 &&
                                                          check.hitung_stok ==
                                                              1) {
                                                        Get.showSnackbar(toast()
                                                            .bottom_snackbar_error(
                                                                "Error",
                                                                'Stock tidak mencukupi'));

                                                        return;
                                                      }
                                                      customer[index].qty++;
                                                      controller.harga_modal
                                                              .value +=
                                                          customer[index]
                                                              .harga_beli!;
                                                      controller.harga_hpp
                                                              .value +=
                                                          customer[index].hpp!;
                                                      controller.hargaModal
                                                              .value.text =
                                                          AppFormat().numFormat(
                                                              controller
                                                                  .harga_modal
                                                                  .value);
                                                      controller
                                                              .hpp.value.text =
                                                          AppFormat().numFormat(
                                                              controller
                                                                  .harga_hpp
                                                                  .value);
                                                      print(
                                                          'sum harga modal --->' +
                                                              controller
                                                                  .harga_modal
                                                                  .value
                                                                  .toString());
                                                      print(
                                                          'sum harga hpp --->' +
                                                              controller
                                                                  .harga_hpp
                                                                  .value
                                                                  .toString());
                                                      controller.produktemp
                                                          .refresh();
                                                    },
                                                    icon: Icon(Icons.add))
                                              ],
                                            ),
                                            Container(
                                              height: 0.5,
                                              color: Colors.black,
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  : Center(child: Text('Paket kosong')),
                            ),
                            Padding(
                                padding: AppPading.customBottomPadding(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: controller.namaPaket.value,
                                        decoration: InputDecoration(
                                          labelText: 'Nama Paket',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'nama paket harus diisi';
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            Padding(
                                padding: AppPading.customBottomPadding(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: controller.hargaModal.value,
                                        inputFormatters: [ThousandsFormatter()],
                                        decoration: InputDecoration(
                                          labelText: 'Harga modal',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return 'Harga modal harus diisi';
                                        //   }
                                        //   if (double.parse(controller
                                        //           .hargaModal.value.text
                                        //           .replaceAll(',', '')) <
                                        //       double.parse(controller.hpp.value.text
                                        //           .replaceAll(',', ''))) {
                                        //     return 'harga modal harus >= dengan HPP';
                                        //   }
                                        //   return null;
                                        // },
                                      ),
                                    ),
                                  ],
                                )),

                            Padding(
                                padding: AppPading.customBottomPadding(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: controller.hpp.value,
                                        inputFormatters: [ThousandsFormatter()],
                                        decoration: InputDecoration(
                                          labelText: 'HPP',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'HPP harus diisi';
                                          }
                                          // if (double.parse(controller
                                          //         .hargaJualEceran.value.text
                                          //         .replaceAll(',', '')) <
                                          //     double.parse(controller.hpp.value.text
                                          //         .replaceAll(',', ''))) {
                                          //   return 'harga eceran harus >= HPP';
                                          // }
                                          return null;
                                        },
                                      ),
                                    ),
                                    // Container(
                                    //     margin: EdgeInsets.only(left: 15),
                                    //     decoration: BoxDecoration(
                                    //         shape: BoxShape.circle,
                                    //         color: AppColor.primary),
                                    //     child: IconButton(
                                    //         onPressed: () {},
                                    //         icon: Icon(
                                    //           Icons.add,
                                    //           color: Colors.white,
                                    //         )))
                                  ],
                                )),

                            Padding(
                                padding: AppPading.customBottomPadding(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller:
                                            controller.hargaJualPaket.value,
                                        inputFormatters: [ThousandsFormatter()],
                                        decoration: InputDecoration(
                                          labelText: 'Harga Jual Paket',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Harga Jual paket harus diisi';
                                          }
                                          if (double.parse(controller
                                                  .hargaJualPaket.value.text
                                                  .replaceAll(',', '')) <
                                              double.parse(controller
                                                  .hpp.value.text
                                                  .replaceAll(',', ''))) {
                                            return 'harga jual paket harus >= HPP';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            Padding(
                              padding: AppPading.customBottomPadding(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Diskon',
                                    style: AppFont.regular(),
                                  ),
                                  Switch(
                                    value: controller.showdiskon.value,
                                    onChanged: (value) {
                                      controller.showdiskon.value = value;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Obx(
                              () {
                                return controller.showdiskon.value == false
                                    ? Container()
                                    : Padding(
                                        padding:
                                            AppPading.customBottomPadding(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Obx(() {
                                                return TextFormField(
                                                  inputFormatters: [
                                                    ThousandsFormatter()
                                                  ],
                                                  controller:
                                                      controller.diskon.value,
                                                  decoration: InputDecoration(
                                                    prefixIcon: controller
                                                                .selecteddiskon
                                                                .value ==
                                                            controller
                                                                .opsidiskon[0]
                                                        ? const Icon(
                                                            Icons.money)
                                                        : const Icon(
                                                            Icons.percent),
                                                    labelText: 'Nilai Diskon',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty)
                                                      return 'Diskon harus diisi';
                                                    final parsed =
                                                        double.tryParse(
                                                            value.replaceAll(
                                                                RegExp(
                                                                    r'[^0-9.]'),
                                                                ''));
                                                    if (parsed == null)
                                                      return 'Masukkan angka valid';
                                                    if (controller
                                                                .selecteddiskon
                                                                .value ==
                                                            controller
                                                                    .opsidiskon[
                                                                0] &&
                                                        parsed <= 0) {
                                                      return 'Nominal harus > 0';
                                                    }
                                                    if (controller
                                                                .selecteddiskon
                                                                .value !=
                                                            controller
                                                                    .opsidiskon[
                                                                0] &&
                                                        (parsed <= 0 ||
                                                            parsed > 100)) {
                                                      return 'Persen harus 1-100';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    final cleanValue =
                                                        value.replaceAll(
                                                            RegExp(r'[^0-9.]'),
                                                            '');
                                                    final parsed =
                                                        double.tryParse(
                                                            cleanValue);
                                                    if (parsed == null) return;

                                                    if (controller
                                                            .selecteddiskon
                                                            .value ==
                                                        controller
                                                            .opsidiskon[0]) {
                                                      controller.diskonvalue
                                                          .value = parsed;
                                                    } else {
                                                      controller.diskonvalue
                                                          .value = parsed;
                                                    }
                                                  },
                                                );
                                              }),
                                            ),
                                            Expanded(
                                              child: Obx(() {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: RadioMenuButton(
                                                        value: controller
                                                            .opsidiskon[0],
                                                        groupValue: controller
                                                            .selecteddiskon
                                                            .value,
                                                        onChanged: (x) =>
                                                            controller
                                                                .selecteddiskon
                                                                .value = x!,
                                                        child:
                                                            const Text('Rp.'),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: RadioMenuButton(
                                                        value: controller
                                                            .opsidiskon[1],
                                                        groupValue: controller
                                                            .selecteddiskon
                                                            .value,
                                                        onChanged: (x) =>
                                                            controller
                                                                .selecteddiskon
                                                                .value = x!,
                                                        child: const Text('%'),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            ),

                            Obx(() {
                              return Padding(
                                padding: AppPading.customBottomPadding(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pajak',
                                      style: AppFont.regular(),
                                    ),
                                    Switch(
                                      value: controller.pajakdisplay.value,
                                      onChanged: (value) {
                                        controller.pajakdisplay.value = value;
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),

                            controller.pajakdisplay.value == true
                                ? Padding(
                                    padding: AppPading.customBottomPadding(),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField2(
                                            // key: UniqueKey(),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            // validator: (value) {
                                            //   if (value == null) {
                                            //     return 'Sub Kategori dipilih';
                                            //   }
                                            //   return null;
                                            // },
                                            isExpanded: true,
                                            dropdownStyleData:
                                                DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white)),
                                            hint: Text('Pajak (opsional)',
                                                style: AppFont.regular()),
                                            value: controller.pajakValue,
                                            items:
                                                controller.pajakList.map((x) {
                                              return DropdownMenuItem(
                                                child: Text(x.nama_pajak! +
                                                    ' - ' +
                                                    ' ${NumberFormat('#,###').format(x.nominal_pajak)} %'),
                                                value: x.uuid,
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              controller.pajakValue = val;
                                              var matchingPajak = controller
                                                  .pajakList
                                                  .firstWhere(
                                                (e) => e.uuid == val,
                                              );

                                              // If a matching pajak is found, update nominalPajak
                                              if (matchingPajak != null) {
                                                controller.nominalPajak.value
                                                        .text =
                                                    matchingPajak.nominal_pajak
                                                        .toString();
                                              } else {
                                                // Handle the case where no matching pajak is found
                                                controller.nominalPajak.value
                                                        .text =
                                                    '0'; // or any default value
                                              }
                                              print(controller.pajakValue);
                                            },
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(left: 15),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.primary),
                                            child: IconButton(
                                                onPressed: () {
                                                  Get.toNamed(
                                                    '/tambahpajak',
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ))),
                                      ],
                                    ),
                                  )
                                : Container(),

                            // Switch for tampilkan_di_produk
                            Padding(
                              padding: AppPading.customBottomPadding(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tampilkan di paket'),
                                  Switch(
                                    value: controller.tampilkanDiProduk.value,
                                    onChanged: (value) {
                                      controller.tampilkanDiProduk.value =
                                          value;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            button_solid_custom(
                                onPressed: () {
                                  if (controller
                                      .registerKey2.value.currentState!
                                      .validate()) {
                                    controller.tambahPaketProduk();
                                  }
                                },
                                child: Text('Tambah',
                                    style: AppFont.regular_white()),
                                width: context.res_width)
                          ],
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
    this.iconcolor,
  });

  final String text;
  final IconData icon;
  final bool? iconcolor;
}

abstract class MenuItems {
  static const List<MenuItem> secondItems = [Hapus];

  static const Hapus =
      MenuItem(text: 'Hapus', icon: Icons.delete, iconcolor: true);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color:
                item.iconcolor == false ? AppColor.primary : AppColor.warning,
            size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: AppFont.regular(),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item,
      TambahPaketProdukController controller, DataProdukTemp data) {
    switch (item) {
      case MenuItems.Hapus:
        // Popscreen().deleteKategoriProduk(controller, data);
        break;
    }
  }
}
