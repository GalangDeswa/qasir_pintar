import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/edit/controller_editisiproduk.dart';

import '../../../../Widget/widget.dart';

class EditIsiProduk extends GetView<EditIsiProdukController> {
  const EditIsiProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Edit produk', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  // Check if all lists are empty
                  final isEmpty = controller.gambarlist.isEmpty &&
                      controller.gambarlist.length == 0 &&
                      controller.pickedImageFiles.isEmpty &&
                      controller.selectedIconPaths.isEmpty;

                  return Container(
                    margin: AppPading.customBottomPadding(),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: isEmpty
                          ? Center(
                              // Show empty state UI
                              child: GestureDetector(
                                onTap: () async {
                                  // Handle permission and image picker
                                  DeviceInfoPlugin deviceInfo =
                                      DeviceInfoPlugin();
                                  AndroidDeviceInfo androidInfo =
                                      await deviceInfo.androidInfo;
                                  if (androidInfo.version.sdkInt >= 33) {
                                    var status = await Permission.photos.status;
                                    if (!status.isGranted)
                                      await Permission.photos.request();
                                  } else {
                                    var status =
                                        await Permission.storage.status;
                                    if (!status.isGranted)
                                      await Permission.storage.request();
                                  }
                                  controller.pilihsourcefoto();
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DashedBorderContainer(
                                      child: Icon(
                                        FontAwesomeIcons.image,
                                        color: AppColor.primary,
                                        size: 35,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Tambah Gambar',
                                      style: AppFont.regular(),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: Get.width,
                              child: Center(
                                child: Wrap(
                                  spacing: 10, // Horizontal spacing
                                  runSpacing: 15, // Vertical spacing

                                  children: [
                                    // Existing images from database
                                    ...controller.gambarlist.map((gambar) =>
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 85,
                                              height: 85,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                  //shape: BoxShape.circle,
                                                  //color: AppColor.primary,
                                                  ),
                                              child: controller.isBase64Svg(
                                                      gambar.gambar)
                                                  ? SvgPicture.memory(
                                                      base64Decode(
                                                          gambar.gambar),
                                                      width: 85,
                                                      height: 85,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : Image.memory(
                                                      base64Decode(
                                                          gambar.gambar),
                                                      width: 85,
                                                      height: 85,
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColor.warning,
                                                ),
                                                child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      controller.deletegambar(
                                                          uuid: gambar.uuid);
                                                    }),
                                              ),
                                            ),
                                          ],
                                        )),

                                    // Newly picked images
                                    ...controller.pickedImageFiles.map((file) =>
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 85,
                                              height: 85,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                //shape: BoxShape.circle,
                                                color: AppColor.primary,
                                              ),
                                              child: Image.file(
                                                File(file.path),
                                                width: 85,
                                                height: 85,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColor.warning,
                                                ),
                                                child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      controller
                                                          .removeImage(file);
                                                    }),
                                              ),
                                            ),
                                          ],
                                        )),

                                    // SVG icons

                                    ...controller.selectedIconPaths
                                        .map((file) => Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: 85,
                                                  height: 85,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      //shape: BoxShape.circle,
                                                      //color: AppColor.primary,
                                                      ),
                                                  child: ClipOval(
                                                    child: SvgPicture.asset(
                                                      file,
                                                      width: 85,
                                                      height: 85,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Container(
                                                    padding: EdgeInsets.zero,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColor.warning,
                                                    ),
                                                    child: IconButton(
                                                        icon: Icon(Icons.close,
                                                            color:
                                                                Colors.white),
                                                        onPressed: () {
                                                          controller
                                                              .removeIcon(file);
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            )),
                                    // Always show add button
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        DashedBorderContainer(
                                          child: Icon(
                                            FontAwesomeIcons.image,
                                            color: AppColor.primary,
                                            size: 35,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(8),
                                              backgroundColor:
                                                  AppColor.secondary,
                                            ),
                                            onPressed: () async {
                                              DeviceInfoPlugin deviceInfo =
                                                  DeviceInfoPlugin();
                                              AndroidDeviceInfo androidInfo =
                                                  await deviceInfo.androidInfo;
                                              if (androidInfo.version.sdkInt >=
                                                  33) {
                                                var status = await Permission
                                                    .photos.status;
                                                if (!status.isGranted)
                                                  await Permission.photos
                                                      .request();
                                              } else {
                                                var status = await Permission
                                                    .storage.status;
                                                if (!status.isGranted)
                                                  await Permission.storage
                                                      .request();
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  );
                }),

                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.namaProduk.value,
                      decoration: InputDecoration(
                        labelText: 'Nama Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Produk harus diisi';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.kodeProduk.value,
                      decoration: InputDecoration(
                        labelText: 'Kode Produk (Opsional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Kode Produk harus diisi';
                      //   }
                      //   return null;
                      // },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField2(
                            key: UniqueKey(),
                            decoration: InputDecoration(
                              labelText: 'Kategori',
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
                            hint: Text('kategori', style: AppFont.regular()),
                            value: controller.kategorivalue,
                            items: controller.kategorilist.map((x) {
                              return DropdownMenuItem(
                                child: Text(x.namakelompok!),
                                value: x.uuid,
                              );
                            }).toList(),
                            onChanged: (val) async {
                              controller.kategorivalue = val;
                              controller.subKategorivalue = null;
                              await controller.fetchSubKategoriProdukLocal(
                                  id_toko: controller.id_toko, kategori: val);
                              print(controller.kategorivalue);
                            },
                          ),
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(left: 15),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: AppColor.primary),
                        //     child: IconButton(
                        //         onPressed: () {
                        //           Get.toNamed('/tambahkategoriproduk',
                        //               arguments: Get.put(
                        //                   TambahSubKategoriController()));
                        //         },
                        //         icon: Icon(
                        //           Icons.add,
                        //           color: Colors.white,
                        //         ))),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField2(
                            key: UniqueKey(),
                            decoration: InputDecoration(
                              labelText: 'Sub kategori',
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
                            hint:
                                Text('Sub kategori', style: AppFont.regular()),
                            value: controller.subKategorivalue,
                            items: controller.subKategorilist.map((x) {
                              return DropdownMenuItem(
                                child: Text(x.namaSubkelompok!),
                                value: x.uuid,
                              );
                            }).toList(),
                            onChanged: (val) {
                              controller.subKategorivalue = val;
                              print(controller.subKategorivalue);
                            },
                          ),
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(left: 15),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: AppColor.primary),
                        //     child: IconButton(
                        //         onPressed: () {
                        //           Get.toNamed(
                        //             '/tambahsubkategori',
                        //           );
                        //         },
                        //         icon: Icon(
                        //           Icons.add,
                        //           color: Colors.white,
                        //         ))),
                      ],
                    ),
                  );
                }),

                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField2(
                            key: UniqueKey(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'jenis produk harus dipilih';
                              }
                              return null;
                            },
                            isExpanded: true,
                            dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white)),
                            hint:
                                Text('Jenis produk', style: AppFont.regular()),
                            value: controller.jenisvalue,
                            items: controller.jenisproduklist.map((x) {
                              return DropdownMenuItem(
                                child: Text(x),
                                value: x,
                              );
                            }).toList(),
                            onChanged: (val) {
                              controller.jenisvalue = val;
                              print(controller.jenisvalue);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Container(
                  width: Get.width,
                  height: 1,
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: 40, top: 20),
                ),

                /// ------------------------------------------------------------------------
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.hargaBeli.value,
                      inputFormatters: [ThousandsFormatter()],
                      decoration: InputDecoration(
                        labelText: 'Harga Beli',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Harga Beli harus diisi';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.hpp.value,
                        inputFormatters: [ThousandsFormatter()],
                        decoration: InputDecoration(
                          labelText: 'HPP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'HPP harus diisi';
                          }
                          return null;
                        },
                      ));
                }),

                Obx(() {
                  return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.hargaJualGrosir.value,
                              inputFormatters: [ThousandsFormatter()],
                              decoration: InputDecoration(
                                labelText: 'Harga Jual grosir',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Harga Jual grosir harus diisi';
                                }
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
                      ));
                }),
                Obx(() {
                  return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.hargaJualEceran.value,
                              inputFormatters: [ThousandsFormatter()],
                              decoration: InputDecoration(
                                labelText: 'Harga Jual Eceran',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Harga Jual grosir harus diisi';
                                }
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
                      ));
                }),
                Obx(() {
                  return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.hargaJualPelanggan.value,
                              inputFormatters: [ThousandsFormatter()],
                              decoration: InputDecoration(
                                labelText: 'Harga Jual pelanggan',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Harga Jual eceran harus diisi';
                                }
                                if (double.parse(controller
                                        .hargaJualPelanggan.value.text
                                        .replaceAll(',', '')) <
                                    double.parse(controller.hpp.value.text
                                        .replaceAll(',', ''))) {
                                  return 'harga jual pelanggan harus >= HPP';
                                }
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
                      ));
                }),

                Container(
                  width: Get.width,
                  height: 1,
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: 40, top: 20),
                ),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.serialKey.value,
                      decoration: InputDecoration(
                        labelText: 'Serial Key (opsional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Serial Key harus diisi';
                      //   }
                      //   return null;
                      // },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.imei.value,
                      decoration: InputDecoration(
                        labelText: 'IMEI (opsional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'IMEI harus diisi';
                      //   }
                      //   return null;
                      // },
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
                  );
                }),

                Obx(
                  () {
                    // Update text field when radio changes
                    final isNominal = controller.selecteddiskon.value ==
                        controller.opsidiskon[0];
                    final currentValue = isNominal
                        ? controller.diskonvalue.value.toStringAsFixed(0)
                        : controller.diskonvalue.value.toStringAsFixed(0);

                    // Update controller text when value changes
                    if (controller.diskon.value.text != currentValue) {
                      controller.diskon.value.text = currentValue;
                    }

                    return controller.showdiskon.value == false
                        ? Container()
                        : Padding(
                            padding: AppPading.customBottomPadding(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.diskon.value,
                                    decoration: InputDecoration(
                                      prefixIcon: isNominal
                                          ? const Icon(Icons.money)
                                          : const Icon(Icons.percent),
                                      labelText: 'Nilai Diskon',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Diskon harus diisi';
                                      final parsed = double.tryParse(value);
                                      if (parsed == null)
                                        return 'Masukkan angka valid';
                                      if (isNominal && parsed <= 0)
                                        return 'Nominal harus > 0';
                                      if (!isNominal &&
                                          (parsed <= 0 || parsed > 100)) {
                                        return 'Persen harus 1-100';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      final parsed = double.tryParse(value);
                                      if (parsed == null) return;

                                      if (isNominal) {
                                        controller.diskonvalue.value = parsed;
                                      } else {
                                        controller.diskonvalue.value = parsed;
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Obx(
                                    () => Row(
                                      children: [
                                        Expanded(
                                          child: RadioMenuButton(
                                            value: controller.opsidiskon[0],
                                            groupValue:
                                                controller.selecteddiskon.value,
                                            onChanged: (x) {
                                              controller.selecteddiskon.value =
                                                  x!;
                                            },
                                            child: const Text('Rp.'),
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioMenuButton(
                                            value: controller.opsidiskon[1],
                                            groupValue:
                                                controller.selecteddiskon.value,
                                            onChanged: (x) {
                                              controller.selecteddiskon.value =
                                                  x!;
                                            },
                                            child: const Text('%'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pajak ?',
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

                Obx(() {
                  return controller.pajakdisplay.value == true
                      ? Padding(
                          padding: AppPading.customBottomPadding(),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField2(
                                  key: UniqueKey(),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null) {
                                  //     return 'Sub Kategori dipilih';
                                  //   }
                                  //   return null;
                                  // },
                                  isExpanded: true,
                                  dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white)),
                                  hint: Text('Pajak (opsional)',
                                      style: AppFont.regular()),
                                  value: controller.pajakValue,
                                  items: controller.pajakList.map((x) {
                                    return DropdownMenuItem(
                                      child: Text(x.nama_pajak! +
                                          ' - ' +
                                          'Rp.' +
                                          x.nominal_pajak.toString()),
                                      value: x.uuid,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    print('asdasdasdasd');
                                    controller.pajakValue = val;
                                    var matchingPajak =
                                        controller.pajakList.firstWhere(
                                      (e) => e.uuid == val,
                                    );

                                    // If a matching pajak is found, update nominalPajak
                                    if (matchingPajak != null) {
                                      controller.nominalPajak.value.text =
                                          matchingPajak.nominal_pajak
                                              .toString();
                                    } else {
                                      // Handle the case where no matching pajak is found
                                      controller.nominalPajak.value.text =
                                          '0'; // or any default value
                                    }
                                    print(controller.pajakValue);
                                  },
                                ),
                              ),
                              // Container(
                              //     margin: EdgeInsets.only(left: 15),
                              //     decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         color: AppColor.primary),
                              //     child: IconButton(
                              //         onPressed: () {
                              //           Get.toNamed(
                              //             '/tambahpajak',
                              //           );
                              //         },
                              //         icon: Icon(
                              //           Icons.add,
                              //           color: Colors.white,
                              //         ))),
                            ],
                          ),
                        )
                      : Container();
                }),

                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hitung Stok',
                          style: AppFont.regular(),
                        ),
                        Switch(
                          value: controller.hitungStok.value,
                          onChanged: (value) {
                            controller.hitungStok.value = value;
                          },
                        ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return controller.hitungStok.value == true
                      ? Padding(
                          padding: AppPading.customBottomPadding(),
                          child: TextFormField(
                            controller: controller.infostock.value,
                            decoration: InputDecoration(
                              labelText: 'Info stock habis',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            // validator: (value) {
                            //            if (value!.isEmpty) {
                            //              return 'Pajak harus diisi';
                            //            }
                            //            return null;
                            //          },
                          ))
                      : Container();
                }),

                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ukuran?',
                          style: AppFont.regular(),
                        ),
                        Switch(
                          value: controller.ukurandisplay.value,
                          onChanged: (value) {
                            controller.ukurandisplay.value = value;
                          },
                        ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return controller.ukurandisplay.value == true
                      ? Padding(
                          padding: AppPading.customBottomPadding(),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField2(
                                  key: UniqueKey(),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null) {
                                  //     return 'Sub Kategori dipilih';
                                  //   }
                                  //   return null;
                                  // },
                                  isExpanded: true,
                                  dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white)),
                                  hint: Text('Ukuran (opsional)',
                                      style: AppFont.regular()),
                                  value: controller.ukuranValue,
                                  items: controller.ukuranList.map((x) {
                                    return DropdownMenuItem(
                                      child: Text(x.ukuran!),
                                      value: x.uuid,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    controller.ukuranValue = val;
                                  },
                                ),
                              ),
                              // Container(
                              //     margin: EdgeInsets.only(left: 15),
                              //     decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         color: AppColor.primary),
                              //     child: IconButton(
                              //         onPressed: () {
                              //           Get.toNamed(
                              //             '/tambahukuran',
                              //           );
                              //         },
                              //         icon: Icon(
                              //           Icons.add,
                              //           color: Colors.white,
                              //         ))),
                            ],
                          ),
                        )
                      : Container();
                }),

                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dimensi?',
                          style: AppFont.regular(),
                        ),
                        Switch(
                          value: controller.dimensi.value,
                          onChanged: (value) {
                            controller.dimensi.value = value;
                          },
                        ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return controller.dimensi == true
                      ? Padding(
                          padding: AppPading.customBottomPadding(),
                          child: TextFormField(
                            controller: controller.berat.value,
                            inputFormatters: [ThousandsFormatter()],
                            decoration: InputDecoration(
                              labelText: 'Berat (Kg) (opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Berat harus diisi';
                            //   }
                            //   return null;
                            // },
                          ))
                      : Container();
                }),
                Obx(() {
                  return controller.dimensi == true
                      ? Padding(
                          padding: AppPading.customBottomPadding(),
                          child: TextFormField(
                            controller: controller.volumePanjang.value,
                            inputFormatters: [ThousandsFormatter()],
                            decoration: InputDecoration(
                              labelText: 'Volume Panjang (opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Volume Panjang harus diisi';
                              //   }
                              //   return null;
                            },
                          ))
                      : Container();
                }),
                Obx(() {
                  return controller.dimensi == true
                      ? Padding(
                          padding: AppPading.customBottomPadding(),
                          child: TextFormField(
                            controller: controller.volumeLebar.value,
                            inputFormatters: [ThousandsFormatter()],
                            decoration: InputDecoration(
                              labelText: 'Volume Lebar (opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Volume Lebar harus diisi';
                              //   }
                              //   return null;
                            },
                          ))
                      : Container();
                }),
                Obx(() {
                  return controller.dimensi == true
                      ? Padding(
                          padding: AppPading.customBottomPadding(),
                          child: TextFormField(
                            controller: controller.volumeTinggi.value,
                            inputFormatters: [ThousandsFormatter()],
                            decoration: InputDecoration(
                              labelText: 'Volume Tinggi (opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Volume Tinggi harus diisi';
                              //   }
                              //   return null;
                            },
                          ))
                      : Container();
                }),
                // Switch for hitung_stok

                // Switch for tampilkan_di_produk
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tampilkan di Produk'),
                        Switch(
                          value: controller.tampilkanDiProduk.value,
                          onChanged: (value) {
                            controller.tampilkanDiProduk.value = value;
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
                        controller.editProduklocal();
                      }
                    },
                    child: Text('Edit'),
                    width: context.res_width)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
