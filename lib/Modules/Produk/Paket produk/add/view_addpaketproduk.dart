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
import 'package:qasir_pintar/Modules/Produk/Data%20produk/model_produk.dart';

import '../../../../Config/config.dart';
import '../../../../Widget/widget.dart';
import '../../Produk/model_kategoriproduk.dart';
import '../../controller_basemenuproduk.dart';
import 'controller_addpaketproduk.dart';

class TambahPaketProduk extends GetView<TambahPaketProdukController> {
  const TambahPaketProduk({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Text(
                //   'Informasi produk',
                //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text.rich(
                //         TextSpan(
                //           children: [
                //             TextSpan(text: 'Informasi Detail'),
                //           ],
                //         ),
                //       ),
                //       Text("2/2"),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 50),
                //   child: Row(
                //     children: [
                //       Expanded(
                //           child: Container(
                //             height: 3,
                //             decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(20),
                //                 color: AppColor.primary),
                //           )),
                //       Expanded(
                //           child: Container(
                //             height: 3,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(20),
                //               color: AppColor.primary,
                //             ),
                //           ))
                //     ],
                //   ),
                // ),

                Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 100, top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        controller.pikedImagePath.value == '' &&
                                controller.pickedIconPath.value == ''
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.primary,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.image,
                                      color: Colors.white,
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
                                        if (androidInfo.version.sdkInt >= 33) {
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
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.primary,
                                    ),
                                    child: ClipOval(
                                      child: controller.pikedImagePath != ''
                                          ? Image.file(
                                              File(controller
                                                  .pickedImageFile!.path),
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : SvgPicture.asset(
                                              controller.pickedIconPath.value,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.contain,
                                            ),
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
                                        if (androidInfo.version.sdkInt >= 33) {
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
                                      child: FaIcon(
                                        FontAwesomeIcons.pencil,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  );
                }),

                Padding(
                  padding: AppPading.customBottomPadding(),
                  child: button_border_custom(
                      onPressed: () {
                        controller.popaddprodukv2();
                      },
                      child: Text('Tambah produk kedalam paket'),
                      width: context.res_width),
                ),

                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5)),
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
                                          leading: ClipOval(
                                            child: customer[index]
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
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.memory(
                                                        base64Decode(customer[
                                                                index]
                                                            .gambar_produk_utama!),
                                                        width: 30,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      )
                                                : Image.asset(
                                                    AppString.defaultImg,
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          title: Text(
                                            customer[index].nama_produk!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text('QTY :' +
                                              customer[index].qty.toString()),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            print('min-------------->');
                                            customer[index].qty--;

                                            // Get the individual product values to subtract
                                            final hargaBeliPerItem =
                                                customer[index]
                                                    .harga_jual_eceran!;
                                            final hppPerItem =
                                                customer[index].hpp!;

                                            // Subtract from totals
                                            controller.harga_modal.value -=
                                                hargaBeliPerItem;
                                            controller.harga_hpp.value -=
                                                hppPerItem;

                                            controller.hargaModal.value.text =
                                                controller.harga_modal.value
                                                    .toString();
                                            controller.hpp.value.text =
                                                controller.harga_hpp.value
                                                    .toString();

                                            if (customer[index].qty <= 0) {
                                              var x = customer.removeAt(index);
                                              controller.deletedDetailIds
                                                  .add(x.uuid!);
                                              controller.produktemp.refresh();
                                            }

                                            controller.produktemp.refresh();
                                          },
                                          icon: Icon(Icons.remove)),
                                      IconButton(
                                          onPressed: () {
                                            customer[index].qty++;
                                            controller.harga_modal.value +=
                                                customer[index]
                                                    .harga_jual_eceran!;
                                            controller.harga_hpp.value +=
                                                customer[index].hpp!;
                                            controller.hargaModal.value.text =
                                                controller.harga_modal.value
                                                    .toString();
                                            controller.hpp.value.text =
                                                controller.harga_hpp.value
                                                    .toString();
                                            print('sum harga modal --->' +
                                                controller.harga_modal.value
                                                    .toString());
                                            print('sum harga hpp --->' +
                                                controller.harga_hpp.value
                                                    .toString());
                                            controller.produktemp.refresh();
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
                  );
                }),
                Obx(() {
                  return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.namaPaket.value,
                              decoration: InputDecoration(
                                labelText: 'Nama Paket',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                      ));
                }),

                Obx(() {
                  return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.hargaModal.value,
                              inputFormatters: [ThousandsFormatter()],
                              decoration: InputDecoration(
                                labelText: 'Harga modal',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Harga modal harus diisi';
                                }
                                if (double.parse(controller
                                        .hargaModal.value.text
                                        .replaceAll(',', '')) <
                                    double.parse(controller.hpp.value.text
                                        .replaceAll(',', ''))) {
                                  return 'harga modal harus >= dengan HPP';
                                }
                                return null;
                              },
                            ),
                          ),
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
                      ));
                }),

                Obx(() {
                  return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.hargaJualPaket.value,
                              inputFormatters: [ThousandsFormatter()],
                              decoration: InputDecoration(
                                labelText: 'Harga Jual Paket',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                    double.parse(controller.hpp.value.text
                                        .replaceAll(',', ''))) {
                                  return 'harga jual paket harus >= HPP';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ));
                }),

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
                                          'Rp ${NumberFormat('#,###').format(x.nominal_pajak)}'),
                                      value: x.uuid,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
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

                // Switch for tampilkan_di_produk
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tampilkan di paket'),
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
                      if (controller.registerKey2.value.currentState!
                          .validate()) {
                        controller.tambahPaketProduk();
                      }
                    },
                    child: Text('tambah'),
                    width: context.res_width)
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
