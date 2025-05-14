import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Produk/stock/detail%20penerimaan%20produk/controller_detailpenerimaanproduk.dart';
import 'package:qasir_pintar/Modules/Produk/stock/model_penerimaan.dart';

import '../../../../Config/config.dart';
import '../../../../Widget/widget.dart';

class DetailPenerimaanProduk extends GetView<DetailPenerimaanProdukController> {
  const DetailPenerimaanProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Penerimaan Produk',
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
                  // Padding(
                  //   padding: AppPading.customBottomPadding(),
                  //   child: button_border_custom(
                  //       onPressed: () {
                  //         controller.popaddprodukv2();
                  //       },
                  //       child: Text('Tambah produk yang akan dipesan'),
                  //       width: context.res_width),
                  // ),
                  Center(
                    child: Text(
                      'Daftar produk',
                      style: AppFont.regular(),
                    ),
                  ),
                  Obx(() {
                    return Container(
                      height: 200,
                      margin: AppPading.customBottomPadding(),
                      child: controller.detailpenerimaan.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.detailpenerimaan.length,
                              itemBuilder: (context, index) {
                                final customer = controller.detailpenerimaan;

                                return Column(
                                  children: [
                                    ListTile(
                                      // leading: ClipOval(
                                      //   child: customer[index]
                                      //       .gambar_produk_utama !=
                                      //       '' &&
                                      //       customer[index]
                                      //           .gambar_produk_utama !=
                                      //           null
                                      //       ? controller.isBase64Svg(
                                      //       customer[index]
                                      //           .gambar_produk_utama!)
                                      //       ? SvgPicture.memory(
                                      //     base64Decode(customer[index]
                                      //         .gambar_produk_utama!),
                                      //     width: 30,
                                      //     height: 40,
                                      //     fit: BoxFit.cover,
                                      //   )
                                      //       : Image.memory(
                                      //     base64Decode(customer[index]
                                      //         .gambar_produk_utama!),
                                      //     width: 30,
                                      //     height: 40,
                                      //     fit: BoxFit.cover,
                                      //   )
                                      //       : Image.asset(
                                      //     AppString.defaultImg,
                                      //     width: 30,
                                      //     height: 40,
                                      //     fit: BoxFit.cover,
                                      //   ),
                                      // ),
                                      title: Text(
                                        customer[index].nama_produk!,
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
                                      //         enabled: false, child: Divider()),
                                      //     ...MenuItems.secondItems.map(
                                      //       (item) =>
                                      //           DropdownMenuItem<MenuItem>(
                                      //         value: item,
                                      //         child: MenuItems.buildItem(item),
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
                                      //   dropdownStyleData: DropdownStyleData(
                                      //     width: 160,
                                      //     padding: const EdgeInsets.symmetric(
                                      //         vertical: 5),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(4),
                                      //     ),
                                      //     offset: const Offset(0, 8),
                                      //   ),
                                      //   menuItemStyleData: MenuItemStyleData(
                                      //     customHeights: [
                                      //       8,
                                      //       ...List<double>.filled(
                                      //           MenuItems.secondItems.length,
                                      //           48),
                                      //     ],
                                      //     padding: const EdgeInsets.only(
                                      //         left: 16, right: 16),
                                      //   ),
                                      // ),
                                      subtitle: Text('QTY :' +
                                          customer[index].qty.toString()),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Supplier harus dipilih';
                                }
                                return null;
                              },
                              isExpanded: true,
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white)),
                              hint: Text('Supplier', style: AppFont.regular()),
                              value: controller.suppliervalue,
                              items: controller.supplierList.map((x) {
                                return DropdownMenuItem(
                                  child: Text(x.nama_supplier!),
                                  value: x.uuid,
                                );
                              }).toList(),
                              onChanged: (val) {
                                controller.suppliervalue = val;
                                print(controller.suppliervalue);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Jenis penerimaan harus dipilih';
                                }
                                return null;
                              },
                              isExpanded: true,
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white)),
                              hint: Text('Jenis Penerimaan',
                                  style: AppFont.regular()),
                              value: controller.jenispenerimaanvalue.value,
                              items: controller.jenispenerimaan.map((x) {
                                return DropdownMenuItem(
                                  child: Text(x),
                                  value: x,
                                );
                              }).toList(),
                              onChanged: (val) {
                                controller.jenispenerimaanvalue.value =
                                    val.toString();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nomorfaktur.value,
                        decoration: InputDecoration(
                          labelText: 'Nomor faktur',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Nama harus diisi';
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
                        controller: controller.jumlahqty.value,
                        decoration: InputDecoration(
                          labelText: 'Jumlah produk',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jumlah produk harus diisi';
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
                        controller: controller.totalharga.value,
                        decoration: InputDecoration(
                          labelText: 'Total harga',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jumlah harga harus diisi';
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
                        controller: controller.ongkir.value,
                        onChanged: (x) {
                          controller.cariTotalBayar();
                        },
                        decoration: InputDecoration(
                          labelText: 'Ongkos kirim',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ongkos kirim harus diisi';
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
                        controller: controller.totalbayar.value,
                        decoration: InputDecoration(
                          labelText: 'Total bayar',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jumlah total bayar harus diisi';
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
                        controller: controller.jumlahbayar.value,
                        decoration: InputDecoration(
                          labelText: 'Jumlah bayar',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jumlah bayar harus diisi';
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
                        controller: controller.sisabayar.value,
                        decoration: InputDecoration(
                          labelText: 'Sisa bayar',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'sisa bayar harus diisi';
                        //   }
                        //   return null;
                        // },
                      ),
                    );
                  }),
                  // button_solid_custom(
                  //     onPressed: () {
                  //       if (controller.registerKey.value.currentState!
                  //           .validate()) {
                  //         controller.tambahPenerimaanProduk();
                  //       }
                  //     },
                  //     child: Text(
                  //       'Tambah',
                  //       style: AppFont.regular_white_bold(),
                  //     ),
                  //     width: context.res_width)
                ],
              ),
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

  static void onChanged(
      BuildContext context,
      MenuItem item,
      DetailPenerimaanProdukController controller,
      DataDetailPenerimaanProduk data) {
    switch (item) {
      case MenuItems.Hapus:
        // Popscreen().deleteKategoriProduk(controller, data);
        break;
    }
  }
}
