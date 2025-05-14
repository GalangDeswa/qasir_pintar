import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import 'controller_isiproduk.dart';

class ViewIsiproduk extends GetView<IsiProdukController> {
  const ViewIsiproduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Detail Produk', NeedBottom: false),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Text(
                  'Foto / Ikon',
                  style: AppFont.regular_bold(),
                ),
              ),
              // Product Images Section
              // Padding(
              //   padding: EdgeInsets.only(bottom: 50, top: 15),
              //   child: Container(
              //     // decoration: BoxDecoration(
              //     //   borderRadius: BorderRadius.all(Radius.circular(10)),
              //     //   border: Border.all(
              //     //     color: Colors.black, // Border color
              //     //     width: 1.0, // Border width
              //     //   ),
              //     // ),
              //
              //     height: 100,
              //
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: controller.gambarlist.length,
              //       itemBuilder: (context, index) {
              //         var gambar = controller.gambarlist.value;
              //         return Container(
              //           margin: EdgeInsets.only(right: 10),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.black.withOpacity(0.2),
              //                 blurRadius: 10,
              //                 offset: Offset(0, 5),
              //               ),
              //             ],
              //           ),
              //           child: ClipOval(
              //             child: gambar[index].gambar != '-' ||
              //                     gambar[index].gambar != null
              //                 ? controller.isBase64Svg(gambar[index].gambar!)
              //                     ? SvgPicture.memory(
              //                         base64Decode(gambar[index].gambar!),
              //                         width: 100,
              //                         fit: BoxFit.cover,
              //                       )
              //                     : Image.memory(
              //                         base64Decode(gambar[index].gambar!),
              //                         width: 100,
              //                         fit: BoxFit.cover,
              //                       )
              //                 : Image.asset(
              //                     AppString.defaultImg,
              //                     width: 100,
              //                     fit: BoxFit.cover,
              //                   ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              controller.gambarlist.isNotEmpty
                  ? CarouselSlider(
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          controller.current(index);
                        },
                        viewportFraction: 0.45,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                      ),
                      items: controller.gambarlist.map((x) {
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          child: x.gambar != '-' || x.gambar != null
                              ? controller.isBase64Svg(x.gambar!)
                                  ? SvgPicture.memory(
                                      base64Decode(x.gambar!),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
                                      base64Decode(x.gambar!),
                                      fit: BoxFit.cover,
                                    )
                              : Image.asset(
                                  AppString.defaultImg,
                                  fit: BoxFit.cover,
                                ),
                        );
                      }).toList())
                  : Text(
                      'Gambar kosong',
                      style: AppFont.regular(),
                    ),

              // Product Details Section
              Card(
                color: Colors.white,
                margin: AppPading.defaultBodyPadding(),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _buildDetailTile(
                          title: 'Nama Produk',
                          value: controller.data.nama_produk!),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Kode Produk',
                          value: controller.data.kode_produk!),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Kategori',
                          value: controller.data.namaKategori ?? '-'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Sub Kategori',
                          value: controller.data.namasubKategori ?? '-'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Jenis Poduk',
                          value: controller.data.jenisProduk ?? '-'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Harga Beli',
                          value:
                              'Rp ${NumberFormat('#,###').format(controller.data.harga_beli)}'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'HPP',
                          value:
                              'Rp ${NumberFormat('#,###').format(controller.data.hpp)}'),
                    ],
                  ),
                ),
              ),

              // Pricing Section
              Card(
                color: Colors.white,
                margin: AppPading.defaultBodyPadding(),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _buildDetailTile(
                          title: 'Harga Jual Grosir',
                          value:
                              'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_grosir)}'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Harga Jual Eceran',
                          value:
                              'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_eceran)}'),
                      _buildDetailTile(
                          title: 'Harga Jual Pelanggan',
                          value:
                              'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_eceran)}'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: controller.data.namaPajak ?? 'Pajak',
                          value: controller.data.namaPajak != null
                              ? 'Rp ${NumberFormat('#,###').format(controller.data.nominalpajak)}'
                              : '-'),
                      // 'Rp ${NumberFormat('#,###').format(controller.data.pajak)}'),
                    ],
                  ),
                ),
              ),

              // Taxes Section

              // Additional Details
              Card(
                color: Colors.white,
                margin: AppPading.defaultBodyPadding(),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _buildDetailTile(
                          title: 'Ukuran',
                          value: controller.data.namaukuran ?? '-'),
                      // 'Rp ${NumberFormat('#,###').format(controller.data.ukuran)}'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Harga Jual Eceran',
                          value:
                              'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_eceran)}'),
                      _buildDetailTile(
                          title: 'Berat',
                          value: controller.data.berat?.toString() ?? '-'),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Volume',
                          value:
                              '${controller.data.volume_panjang ?? '-'} x ${controller.data.volume_lebar ?? '-'} x ${controller.data.volume_tinggi ?? '-'}'),
                      _buildSwitchTile(
                          title: 'Hitung Stok',
                          value: controller.data.hitung_stok == 1),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                          title: 'Stock awal',
                          value: controller.data.stockawal?.toString() ?? '0'),
                      Divider(height: 20, thickness: 1),
                      _buildSwitchTile(
                          title: 'Tampilkan di Produk',
                          value: controller.data.tampilkan_di_produk == 1),
                    ],
                  ),
                ),
              ),

              // Edit Button
              // Padding(
              //   padding: AppPading.customTopPadding(),
              //   child: button_solid_custom(
              //       onPressed: () {
              //         Get.toNamed('/editisiproduk', arguments: controller.data);
              //       },
              //       child: Text('Edit Produk'),
              //       width: context.res_width),
              // )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailTile({required String title, required String value}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: null, // Disabled switch for display
        activeColor: AppColor.primary,
      ),
    );
  }
}
