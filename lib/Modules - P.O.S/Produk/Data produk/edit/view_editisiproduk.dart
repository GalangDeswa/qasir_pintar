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

                customTextField(
                  controller: controller.namaProduk.value,
                  labelText: 'Nama produk',
                  validator: (value) {
                    print('print value validator');
                    print(value);
                    if (value == null || value.isEmpty) {
                      return 'keterangan harus dipilih';
                    }
                    return null;
                  },
                ),
                customTextField(
                  controller: controller.kodeProduk.value,
                  labelText: 'Kode produk (opsional)',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return customDropdownField(
                          hintText: 'Kategori produk',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kategori harus dipilih';
                            }
                            return null;
                          },
                          items: controller.kategorilist.map((x) {
                            return DropdownMenuItem(
                              child: Text(x.namakelompok!),
                              value: x.uuid,
                            );
                          }).toList(),
                          value: controller.kategorivalue,
                          onChanged: (val) async {
                            controller.kategorivalue = val;
                            controller.subKategorivalue = null;
                            await controller.fetchSubKategoriProdukLocal(
                                id_toko: controller.id_toko, kategori: val);
                          },
                        );
                      }),
                    ),
                    // Container(
                    //     margin: EdgeInsets.only(left: 15),
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle, color: AppColor.primary),
                    //     child: IconButton(
                    //         onPressed: () {
                    //           Get.toNamed('/tambahkategoriproduk');
                    //         },
                    //         icon: Icon(
                    //           Icons.add,
                    //           color: Colors.white,
                    //         ))),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return customDropdownField(
                          hintText: 'Sub Kategori produk',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Sub Kategori harus dipilih';
                            }
                            return null;
                          },
                          items: controller.subKategorilist.map((x) {
                            return DropdownMenuItem(
                              child: Text(x.namaSubkelompok!),
                              value: x.uuid,
                            );
                          }).toList(),
                          value: controller.subKategorivalue,
                          onChanged: (val) {
                            controller.subKategorivalue = val;
                            print(controller.subKategorivalue);
                          },
                        );
                      }),
                    ),
                    // Container(
                    //     margin: EdgeInsets.only(left: 15),
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle, color: AppColor.primary),
                    //     child: IconButton(
                    //         onPressed: () {
                    //           print('ke sub kat');
                    //           Get.toNamed('/tambahsubkategori',
                    //               arguments: controller.kategorivalue);
                    //         },
                    //         icon: Icon(
                    //           Icons.add,
                    //           color: Colors.white,
                    //         ))),
                  ],
                ),

                Obx(() {
                  return customDropdownField(
                    hintText: 'Jenis produk',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis produk harus dipilih';
                      }
                      return null;
                    },
                    items: controller.jenisproduklist.map((x) {
                      return DropdownMenuItem(
                        child: Text(x),
                        value: x,
                      );
                    }).toList(),
                    value: controller.jenisvalue,
                    onChanged: (val) {
                      controller.jenisvalue = val;
                      print(controller.jenisvalue);
                    },
                  );
                }),
                Container(
                  width: Get.width,
                  height: 1,
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: 40, top: 20),
                ),

                /// ------------------------------------------------------------------------
                customTextField(
                  controller: controller.hargaBeli.value,
                  labelText: 'Harga beli',
                  validator: (value) {
                    print('print value validator');
                    print(value);
                    if (value == null || value.isEmpty) {
                      return 'harga beli harus dipilih';
                    }
                    return null;
                  },
                  inputFormatters: [ThousandsFormatter()],
                  keyboardType: TextInputType.number,
                ),
                customTextField(
                  controller: controller.hpp.value,
                  labelText: 'HPP',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'HPP harus diisi';
                    }
                    if (double.parse(
                            controller.hpp.value.text.replaceAll(',', '')) <
                        double.parse(controller.hargaBeli.value.text
                            .replaceAll(',', ''))) {
                      return 'HPP harus >= dari Harga Beli';
                    }
                    return null;
                  },
                  inputFormatters: [ThousandsFormatter()],
                  keyboardType: TextInputType.number,
                ),

                customTextField(
                  controller: controller.hargaJualEceran.value,
                  labelText: 'Harga jual eceran',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harga Jual eceran harus diisi';
                    }
                    if (double.parse(controller.hargaJualEceran.value.text
                            .replaceAll(',', '')) <
                        double.parse(
                            controller.hpp.value.text.replaceAll(',', ''))) {
                      return 'harga eceran harus >= HPP';
                    }
                    return null;
                  },
                  inputFormatters: [ThousandsFormatter()],
                  keyboardType: TextInputType.number,
                ),
                customTextField(
                  controller: controller.hargaJualGrosir.value,
                  labelText: 'Harga jual grosir (opsional)',
                  inputFormatters: [ThousandsFormatter()],
                  keyboardType: TextInputType.number,
                ),

                customTextField(
                  controller: controller.hargaJualPelanggan.value,
                  labelText: 'Harga jual pelanggan (opsional)',
                  inputFormatters: [ThousandsFormatter()],
                  keyboardType: TextInputType.number,
                ),

                Container(
                  width: Get.width,
                  height: 1,
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: 40, top: 20),
                ),
                // Obx(() {
                //   return Padding(
                //     padding: AppPading.customBottomPadding(),
                //     child: TextFormField(
                //       controller: controller.serialKey.value,
                //       decoration: InputDecoration(
                //         labelText: 'Serial Key (opsional)',
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //       // validator: (value) {
                //       //   if (value!.isEmpty) {
                //       //     return 'Serial Key harus diisi';
                //       //   }
                //       //   return null;
                //       // },
                //     ),
                //   );
                // }),
                // Obx(() {
                //   return Padding(
                //     padding: AppPading.customBottomPadding(),
                //     child: TextFormField(
                //       controller: controller.imei.value,
                //       decoration: InputDecoration(
                //         labelText: 'IMEI (opsional)',
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //       // validator: (value) {
                //       //   if (value!.isEmpty) {
                //       //     return 'IMEI harus diisi';
                //       //   }
                //       //   return null;
                //       // },
                //     ),
                //   );
                // }),

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
                            controller.diskon.value.text = '0';
                            controller.diskonvalue.value = 0.0;
                            controller.selecteddiskon.value =
                                controller.opsidiskon[0];
                          },
                        ),
                      ],
                    ),
                  );
                }),

                Obx(
                  () {
                    return controller.showdiskon.value == false
                        ? Container()
                        : Padding(
                            padding: AppPading.customBottomPadding(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    return TextFormField(
                                      style: AppFont.regular(),
                                      inputFormatters: [ThousandsFormatter()],
                                      controller: controller.diskon.value,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            controller.selecteddiskon.value ==
                                                    controller.opsidiskon[0]
                                                ? const Icon(Icons.money)
                                                : const Icon(Icons.percent),
                                        labelText: 'Nilai Diskon',
                                        labelStyle: AppFont.regular(),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Diskon harus diisi';
                                        final parsed = double.tryParse(
                                            value.replaceAll(
                                                RegExp(r'[^0-9.]'), ''));
                                        if (parsed == null)
                                          return 'Masukkan angka valid';
                                        if (controller.selecteddiskon.value ==
                                                controller.opsidiskon[0] &&
                                            parsed <= 0) {
                                          return 'Nominal harus > 0';
                                        }
                                        if (controller.selecteddiskon.value !=
                                                controller.opsidiskon[0] &&
                                            (parsed <= 0 || parsed > 100)) {
                                          return 'Persen harus 1-100';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        final cleanValue = value.replaceAll(
                                            RegExp(r'[^0-9.]'), '');
                                        final parsed =
                                            double.tryParse(cleanValue);
                                        if (parsed == null) return;

                                        if (controller.selecteddiskon.value ==
                                            controller.opsidiskon[0]) {
                                          controller.diskonvalue.value = parsed;
                                        } else {
                                          controller.diskonvalue.value = parsed;
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
                                            value: controller.opsidiskon[0],
                                            groupValue:
                                                controller.selecteddiskon.value,
                                            onChanged: (x) => controller
                                                .selecteddiskon.value = x!,
                                            child: const Text('Rp.'),
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioMenuButton(
                                            value: controller.opsidiskon[1],
                                            groupValue:
                                                controller.selecteddiskon.value,
                                            onChanged: (x) => controller
                                                .selecteddiskon.value = x!,
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
                            controller.pajak.value.text = '';
                            controller.pajakValue = null;
                          },
                        ),
                      ],
                    ),
                  );
                }),

                Obx(() {
                  return controller.pajakdisplay.value == true
                      ? customDropdownField(
                          hintText: 'Pajak',
                          items: controller.pajakList.map((x) {
                            return DropdownMenuItem(
                              child: Text(x.nama_pajak! +
                                  ' - ' +
                                  '' +
                                  x.nominal_pajak!.toString() +
                                  '%'),
                              value: x.uuid,
                            );
                          }).toList(),
                          value: controller.pajakValue,
                          onChanged: (val) {
                            controller.pajakValue = val;
                            var matchingPajak = controller.pajakList.firstWhere(
                              (e) => e.uuid == val,
                            );

                            // If a matching pajak is found, update nominalPajak
                            if (matchingPajak != null) {
                              controller.nominalPajak.value.text =
                                  matchingPajak.nominal_pajak.toString();
                            } else {
                              // Handle the case where no matching pajak is found
                              controller.nominalPajak.value.text =
                                  '0'; // or any default value
                            }
                            print(controller.pajakValue);
                          },
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
                            controller.stockAwal.value.text = '0';
                            controller.minimumStock.value.text = '0';
                          },
                        ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return controller.hitungStok.value == true
                      ? customTextField(
                          controller: controller.stockAwal.value,
                          labelText: 'Stock awal',
                          validator: (value) {
                            if (controller.hitungStok.value == true &&
                                value!.isEmpty) {
                              return 'Stock awal harus diisi';
                            }
                            return null;
                          },
                          inputFormatters: [ThousandsFormatter()],
                          keyboardType: TextInputType.number,
                        )
                      : Container();
                }),
                Obx(() {
                  return controller.hitungStok.value == true
                      ? customTextField(
                          controller: controller.minimumStock.value,
                          labelText: 'Minimum stock',
                          validator: (value) {
                            if (controller.hitungStok.value == true &&
                                value!.isEmpty) {
                              return 'Minimum stock harus diisi';
                            }
                            if (value!.isNotEmpty && int.parse(value) < 0)
                              return 'Minimum stock tidak boleh lebih kecil dari 0';
                            if (value!.isNotEmpty &&
                                int.parse(value) >
                                    int.parse(controller.stockAwal.value.text))
                              return 'Minimum stock tidak boleh lebih kecil besar dari stock awal';
                          },
                          inputFormatters: [ThousandsFormatter()],
                          keyboardType: TextInputType.number,
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
                          'Ukuran?',
                          style: AppFont.regular(),
                        ),
                        Switch(
                          value: controller.ukurandisplay.value,
                          onChanged: (value) {
                            controller.ukurandisplay.value = value;
                            controller.ukuran.value.text = '';
                            controller.ukuranValue = null;
                          },
                        ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return controller.ukurandisplay.value == true
                      ? customDropdownField(
                          hintText: 'Ukuran',
                          items: controller.ukuranList.map((x) {
                            return DropdownMenuItem(
                              child: Text(x.ukuran!),
                              value: x.uuid,
                            );
                          }).toList(),
                          value: controller.ukuranValue,
                          onChanged: (val) {
                            controller.ukuranValue = val;
                          },
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
                            controller.berat.value.text = '0';
                            controller.volumePanjang.value.text = '0';
                            controller.volumeLebar.value.text = '0';
                            controller.volumeTinggi.value.text = '0';
                          },
                        ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return controller.dimensi.value == true
                      ? customTextField(
                          controller: controller.berat.value,
                          labelText: 'Berat (KG) (opsional)',
                          inputFormatters: [ThousandsFormatter()],
                          keyboardType: TextInputType.number)
                      : Container();
                }),
                Obx(() {
                  return controller.dimensi.value == true
                      ? customTextField(
                          controller: controller.volumePanjang.value,
                          labelText: 'Pajang (M) (opsional)',
                          inputFormatters: [ThousandsFormatter()],
                          keyboardType: TextInputType.number)
                      : Container();
                }),
                Obx(() {
                  return controller.dimensi.value == true
                      ? customTextField(
                          controller: controller.volumeLebar.value,
                          labelText: 'lebar (M) (opsional)',
                          inputFormatters: [ThousandsFormatter()],
                          keyboardType: TextInputType.number)
                      : Container();
                }),
                Obx(() {
                  return controller.dimensi.value == true
                      ? customTextField(
                          controller: controller.volumeTinggi.value,
                          labelText: 'Tinggi (M) (opsional)',
                          inputFormatters: [ThousandsFormatter()],
                          keyboardType: TextInputType.number)
                      : Container();
                }),

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
