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

import '../../../../Config/config.dart';
import '../../../../Widget/widget.dart';
import '../../Data produk/model_produk.dart';
import 'controller_editpaketproduk.dart';

class EditPaketProduk extends GetView<EditPaketProdukController> {
  const EditPaketProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Edit Paket', NeedBottom: false),
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

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Obx(() {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: controller.pikedImagePath.value != ''
                                ? ClipOval(
                                    child: Image.file(
                                      File(controller.pickedImageFile!.path),
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : controller.pickedIconPath.value != ''
                                    ? ClipOval(
                                        child: SvgPicture.asset(
                                          controller.pickedIconPath.value,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : controller.data.gambar_utama != '-' &&
                                            controller.data.gambar_utama != null
                                        ? controller.isBase64Svg(
                                                controller.data.gambar_utama)
                                            ? ClipOval(
                                                child: SvgPicture.memory(
                                                  base64Decode(controller
                                                      .data.gambar_utama),
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : ClipOval(
                                                child: Image.memory(
                                                  base64Decode(controller
                                                      .data.gambar_utama),
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                        : Icon(
                                            FontAwesomeIcons.image,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                DeviceInfoPlugin deviceInfo =
                                    DeviceInfoPlugin();
                                AndroidDeviceInfo androidInfo =
                                    await deviceInfo.androidInfo;
                                if (androidInfo.version.sdkInt >= 33) {
                                  var status = await Permission.camera.status;
                                  if (!status.isGranted) {
                                    await Permission.camera.request();
                                  }
                                } else {
                                  var status = await Permission.camera.status;
                                  if (!status.isGranted) {
                                    await Permission.camera.request();
                                  }
                                }
                                controller.pilihsourcefoto();
                                // Popscreen().pilihSourceFoto(
                                //     camera: controller.pickImageCamera(),
                                //     galery: controller.pickImageGallery(),
                                //     ikon: controller.pilihIcon(context));
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.secondary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  controller.pikedImagePath.value == ''
                                      ? Icons.add
                                      : FontAwesomeIcons.pencil,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          if (controller.pikedImagePath.value != '' ||
                              controller.data.gambar_utama != '-' ||
                              controller.data.gambar_utama != null)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // Call a method in the controller to delete the image
                                  controller.deleteImage();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors
                                        .red, // Red color for delete button
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
                    }),
                  ),
                ),

                Padding(
                  padding: AppPading.customBottomPadding(),
                  child: button_border_custom(
                      onPressed: () {
                        //controller.popaddproduk();
                        controller.pop();
                        print('qweqweqweqw');
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
                    child: controller.detailpaket.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.detailpaket.length,
                            itemBuilder: (context, index) {
                              final customer = controller.detailpaket;
                              final produk = controller.produk;

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          leading: ClipOval(
                                            child: customer[index]
                                                            .gambarproduk !=
                                                        '' &&
                                                    customer[index]
                                                            .gambarproduk !=
                                                        null
                                                ? controller.isBase64Svg(
                                                        customer[index]
                                                            .gambarproduk!)
                                                    ? SvgPicture.memory(
                                                        base64Decode(
                                                            customer[index]
                                                                .gambarproduk!),
                                                        width: 30,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.memory(
                                                        base64Decode(
                                                            customer[index]
                                                                .gambarproduk!),
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
                                            customer[index].namaproduk!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // trailing: DropdownButton2(
                                          //   hint: Text('Pilih tampilan'),
                                          //   customButton: const FaIcon(
                                          //     FontAwesomeIcons.list,
                                          //     // color: Colors.white,
                                          //     size: 25,
                                          //   ),
                                          //   items: [
                                          //     const DropdownMenuItem<Divider>(
                                          //         enabled: false,
                                          //         child: Divider()),
                                          //     ...MenuItems.secondItems.map(
                                          //       (item) =>
                                          //           DropdownMenuItem<MenuItem>(
                                          //         value: item,
                                          //         child:
                                          //             MenuItems.buildItem(item),
                                          //       ),
                                          //     ),
                                          //   ],
                                          //   onChanged: (value) {
                                          //     MenuItems.onChanged(
                                          //         context,
                                          //         value! as MenuItem,
                                          //         controller,
                                          //         customer[index]);
                                          //   },
                                          //   dropdownStyleData:
                                          //       DropdownStyleData(
                                          //     width: 160,
                                          //     padding:
                                          //         const EdgeInsets.symmetric(
                                          //             vertical: 5),
                                          //     decoration: BoxDecoration(
                                          //       borderRadius:
                                          //           BorderRadius.circular(4),
                                          //     ),
                                          //     offset: const Offset(0, 8),
                                          //   ),
                                          //   menuItemStyleData:
                                          //       MenuItemStyleData(
                                          //     customHeights: [
                                          //       8,
                                          //       ...List<double>.filled(
                                          //           MenuItems
                                          //               .secondItems.length,
                                          //           48),
                                          //     ],
                                          //     padding: const EdgeInsets.only(
                                          //         left: 16, right: 16),
                                          //   ),
                                          // ),
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
                                                produk[index]
                                                    .harga_jual_eceran!;
                                            final hppPerItem =
                                                produk[index].hpp!;

                                            // Subtract from totals
                                            controller.harga_modal.value -=
                                                hargaBeliPerItem;
                                            controller.harga_hpp.value -=
                                                hppPerItem;

                                            // Update text fields by subtracting per-item values from existing input
                                            if (controller.hargaModal.value.text
                                                .isNotEmpty) {
                                              final currentValue = double.parse(
                                                  controller
                                                      .hargaModal.value.text);
                                              controller.hargaModal.value.text =
                                                  (currentValue -
                                                          hargaBeliPerItem)
                                                      .toString();
                                            } else {
                                              controller.hargaModal.value.text =
                                                  controller.harga_modal.value
                                                      .toString();
                                            }

                                            if (controller
                                                .hpp.value.text.isNotEmpty) {
                                              final currentValue = double.parse(
                                                  controller.hpp.value.text);
                                              controller.hpp.value.text =
                                                  (currentValue - hppPerItem)
                                                      .toString();
                                            } else {
                                              controller.hpp.value.text =
                                                  controller.harga_hpp.value
                                                      .toString();
                                            }

                                            if (customer[index].qty <= 0) {
                                              var x = customer.removeAt(index);
                                              controller.deletedDetailIds
                                                  .add(x.uuid!);
                                              controller.detailpaket.refresh();
                                            }

                                            controller.detailpaket.refresh();
                                          },
                                          icon: Icon(Icons.remove)),
                                      IconButton(
                                          onPressed: () {
                                            customer[index].qty++;
                                            final hargajualitem = produk[index]
                                                .harga_jual_eceran!;
                                            final hppPerItem =
                                                produk[index].hpp!;

                                            controller.harga_modal.value +=
                                                hargajualitem;

                                            controller.harga_hpp.value +=
                                                hppPerItem;

                                            if (controller.hargaModal.value.text
                                                .isNotEmpty) {
                                              final currentValue = double.parse(
                                                  controller
                                                      .hargaModal.value.text);
                                              controller.hargaModal.value.text =
                                                  (currentValue + hargajualitem)
                                                      .toString();
                                            } else {
                                              controller.hargaModal.value.text =
                                                  controller.harga_modal.value
                                                      .toString();
                                            }

                                            if (controller
                                                .hpp.value.text.isNotEmpty) {
                                              final currentValue = double.parse(
                                                  controller.hpp.value.text);
                                              controller.hpp.value.text =
                                                  (currentValue + hppPerItem)
                                                      .toString();
                                            } else {
                                              controller.hpp.value.text =
                                                  controller.harga_hpp.value
                                                      .toString();
                                            }

                                            controller.detailpaket.refresh();
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
                        controller.editPaketProduk();
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
      EditPaketProdukController controller, DataDetailPaketProduk data) {
    switch (item) {
      case MenuItems.Hapus:
        // Popscreen().deleteKategoriProduk(controller, data);
        break;
    }
  }
}
