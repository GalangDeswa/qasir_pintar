import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/detail%20penerimaan%20produk/controller_detailpenerimaanproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/model_penerimaan.dart';

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
                  _buildDetailTile(
                      title: 'Nomor faktur',
                      value: controller.data.nomorFaktur!),
                  Divider(height: 0, thickness: 0.5),
                  Obx(() {
                    return _buildDetailTile(
                        title: 'Supplier',
                        value: controller.namaSupplier.value);
                  }),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Metode bayar',
                      value: controller.data.jenisPenerimaan!),
                  Divider(height: 0, thickness: 0.5),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: Text(
                      'Detail penerimaan',
                      style: AppFont.regular(),
                    ),
                    children: [
                      _buildDetailTile(
                          title: 'Jumlah produk',
                          value: controller.data.jumlahQty.toString()),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Total harga',
                          value: 'Rp. ' +
                              AppFormat()
                                  .numFormat(controller.data.totalBayar)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Ongkos kirim',
                          value: 'Rp. ' +
                              AppFormat()
                                  .numFormat(controller.data.ongkosKirim)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Total bayar',
                          value: 'Rp. ' +
                              AppFormat()
                                  .numFormat(controller.data.totalBayar)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Jumlah bayar',
                          value: 'Rp. ' +
                              AppFormat()
                                  .numFormat(controller.data.jumlahBayar)),
                      Divider(height: 0, thickness: 0.5),
                      _buildDetailTile(
                          title: 'Sisa bayar',
                          value: 'Rp. ' +
                              AppFormat().numFormat(controller.data.sisaBayar)),
                      Divider(height: 0, thickness: 0.5),
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
                                    final customer =
                                        controller.detailpenerimaan;

                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            customer[index].nama_produk!,
                                            style: AppFont.regular_bold(),
                                          ),
                                          subtitle: Text(
                                            'Qty : ' +
                                                customer[index].qty.toString(),
                                            style: AppFont.small(),
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: Colors.black,
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Center(child: Text('produk kosong')),
                        );
                      }),
                    ],
                  ),

                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Expanded(
                  //           child: DropdownButtonFormField2(
                  //             decoration: InputDecoration(
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //             ),
                  //             validator: (value) {
                  //               if (value == null) {
                  //                 return 'Supplier harus dipilih';
                  //               }
                  //               return null;
                  //             },
                  //             isExpanded: true,
                  //             dropdownStyleData: DropdownStyleData(
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     color: Colors.white)),
                  //             hint: Text('Supplier', style: AppFont.regular()),
                  //             value: controller.suppliervalue,
                  //             items: controller.supplierList.map((x) {
                  //               return DropdownMenuItem(
                  //                 child: Text(x.nama_supplier!),
                  //                 value: x.uuid,
                  //               );
                  //             }).toList(),
                  //             onChanged: (val) {
                  //               controller.suppliervalue = val;
                  //               print(controller.suppliervalue);
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Expanded(
                  //           child: DropdownButtonFormField2(
                  //             decoration: InputDecoration(
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //             ),
                  //             validator: (value) {
                  //               if (value == null) {
                  //                 return 'Jenis penerimaan harus dipilih';
                  //               }
                  //               return null;
                  //             },
                  //             isExpanded: true,
                  //             dropdownStyleData: DropdownStyleData(
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     color: Colors.white)),
                  //             hint: Text('Jenis Penerimaan',
                  //                 style: AppFont.regular()),
                  //             value: controller.jenispenerimaanvalue.value,
                  //             items: controller.jenispenerimaan.map((x) {
                  //               return DropdownMenuItem(
                  //                 child: Text(x),
                  //                 value: x,
                  //               );
                  //             }).toList(),
                  //             onChanged: (val) {
                  //               controller.jenispenerimaanvalue.value =
                  //                   val.toString();
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: TextFormField(
                  //       controller: controller.nomorfaktur.value,
                  //       decoration: InputDecoration(
                  //         labelText: 'Nomor faktur',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       keyboardType: TextInputType.name,
                  //       // validator: (value) {
                  //       //   if (value!.isEmpty) {
                  //       //     return 'Nama harus diisi';
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
                  //       controller: controller.jumlahqty.value,
                  //       decoration: InputDecoration(
                  //         labelText: 'Jumlah produk',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       keyboardType: TextInputType.number,
                  //       validator: (value) {
                  //         if (value!.isEmpty) {
                  //           return 'Jumlah produk harus diisi';
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: TextFormField(
                  //       controller: controller.totalharga.value,
                  //       decoration: InputDecoration(
                  //         labelText: 'Total harga',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       keyboardType: TextInputType.number,
                  //       validator: (value) {
                  //         if (value!.isEmpty) {
                  //           return 'Jumlah harga harus diisi';
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: TextFormField(
                  //       controller: controller.ongkir.value,
                  //       onChanged: (x) {
                  //         controller.cariTotalBayar();
                  //       },
                  //       decoration: InputDecoration(
                  //         labelText: 'Ongkos kirim',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       keyboardType: TextInputType.number,
                  //       validator: (value) {
                  //         if (value!.isEmpty) {
                  //           return 'Ongkos kirim harus diisi';
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: TextFormField(
                  //       controller: controller.totalbayar.value,
                  //       decoration: InputDecoration(
                  //         labelText: 'Total bayar',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       keyboardType: TextInputType.number,
                  //       validator: (value) {
                  //         if (value!.isEmpty) {
                  //           return 'Jumlah total bayar harus diisi';
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: TextFormField(
                  //       controller: controller.jumlahbayar.value,
                  //       decoration: InputDecoration(
                  //         labelText: 'Jumlah bayar',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       keyboardType: TextInputType.number,
                  //       validator: (value) {
                  //         if (value!.isEmpty) {
                  //           return 'Jumlah bayar harus diisi';
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return Padding(
                  //     padding: AppPading.customBottomPadding(),
                  //     child: TextFormField(
                  //       controller: controller.sisabayar.value,
                  //       decoration: InputDecoration(
                  //         labelText: 'Sisa bayar',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       keyboardType: TextInputType.number,
                  //       // validator: (value) {
                  //       //   if (value!.isEmpty) {
                  //       //     return 'sisa bayar harus diisi';
                  //       //   }
                  //       //   return null;
                  //       // },
                  //     ),
                  //   );
                  // }),
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

  Widget _buildDetailTile({required String title, required String value}) {
    return ListTile(
      title: Text(
        title,
        style: AppFont.regular(),
      ),
      subtitle: Text(
        value,
        style: AppFont.regular_bold(),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value}) {
    return ListTile(
      title: Text(
        title,
        style: AppFont.regular(),
      ),
      trailing: Switch(
        padding: EdgeInsets.zero,
        value: value,
        activeTrackColor: AppColor.primary,
        onChanged: null,
        // Disabled switch for display
        activeColor: AppColor.primary,
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
