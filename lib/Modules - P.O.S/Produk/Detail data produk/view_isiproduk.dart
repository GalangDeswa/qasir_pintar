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
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
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

                controller.gambarlist.isNotEmpty
                    ? Padding(
                        padding: AppPading.customBottomPadding(),
                        child: CarouselSlider(
                            options: CarouselOptions(
                              onPageChanged: (index, reason) {
                                controller.current(index);
                              },
                              viewportFraction: 0.60,
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
                                            fit: BoxFit.contain,
                                          )
                                        : Image.memory(
                                            base64Decode(x.gambar!),
                                            fit: BoxFit.contain,
                                          )
                                    : Image.asset(
                                        AppString.defaultImg,
                                        fit: BoxFit.contain,
                                      ),
                              );
                            }).toList()),
                      )
                    : Text(
                        'Gambar kosong',
                        style: AppFont.regular(),
                      ),

                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    _buildDetailTile(
                        title: 'Nama Produk',
                        value: controller.data.nama_produk!),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Kode Produk',
                        value: controller.data.kode_produk!),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Kategori',
                        value: controller.data.namaKategori ?? '-'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Sub Kategori',
                        value: controller.data.namasubKategori ?? '-'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Jenis Poduk',
                        value: controller.data.jenisProduk ?? '-'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Harga Beli',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_beli)}'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'HPP',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.hpp)}'),
                  ],
                ),

                // Pricing Section
                Column(
                  children: [
                    _buildDetailTile(
                        title: 'Harga Jual Grosir',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_grosir)}'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Harga Jual Eceran',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_eceran)}'),
                    _buildDetailTile(
                        title: 'Harga Jual Pelanggan',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_eceran)}'),
                    _buildDetailTile(
                        title: 'Diskon',
                        value: controller.data.diskon != null
                            ? 'Rp ${NumberFormat('#,###').format(controller.data.diskon)}'
                            : '-'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: controller.data.namaPajak ?? 'Pajak',
                        value: controller.data.namaPajak != null
                            ? ' ${NumberFormat('#,###').format(controller.data.nominalpajak)} %'
                            : '-'),
                    // 'Rp ${NumberFormat('#,###').format(controller.data.pajak)}'),
                  ],
                ),

                // Taxes Section

                // Additional Details
                Column(
                  children: [
                    _buildDetailTile(
                        title: 'Ukuran',
                        value: controller.data.namaukuran ?? '-'),
                    // 'Rp ${NumberFormat('#,###').format(controller.data.ukuran)}'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Harga Jual Eceran',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_eceran)}'),
                    _buildDetailTile(
                        title: 'Berat',
                        value: controller.data.berat?.toString() ?? '-'),
                    Divider(height: 0, thickness: 0.5),
                    _buildDetailTile(
                        title: 'Volume',
                        value:
                            '${controller.data.volume_panjang ?? '-'} x ${controller.data.volume_lebar ?? '-'} x ${controller.data.volume_tinggi ?? '-'}'),
                    _buildSwitchTile(
                        title: 'Hitung Stok',
                        value: controller.data.hitung_stok == 1),
                    controller.data.hitung_stok == 0
                        ? Divider()
                        : Column(
                            children: [
                              _buildDetailTile(
                                  title: 'Stock awal',
                                  value:
                                      controller.data.stockawal?.toString() ??
                                          '0'),
                              _buildDetailTile(
                                  title: 'Minimum Stock',
                                  value: controller.data.info_stok_habis
                                          ?.toString() ??
                                      '0'),
                              Divider(height: 0, thickness: 0.5),
                            ],
                          ),

                    _buildSwitchTile(
                        title: 'Aktif',
                        value: controller.data.tampilkan_di_produk == 1),
                  ],
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
        value: value, activeTrackColor: AppColor.primary,
        onChanged: null, // Disabled switch for display
        activeColor: AppColor.primary,
      ),
    );
  }
}
