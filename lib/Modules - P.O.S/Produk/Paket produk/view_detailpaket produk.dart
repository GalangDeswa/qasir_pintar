import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Paket%20produk/controller_detailpaketproduk.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import '../controller_basemenuproduk.dart';

class DetailPaketProduk extends GetView<DetailPaketProdukController> {
  const DetailPaketProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Detail Produk', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: AppPading.customBottomPadding(),
                width: Get.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: controller.data.gambar_utama != '-' &&
                        controller.data.gambar_utama != null
                    ? controller.isBase64Svg(controller.data.gambar_utama!)
                        ? SvgPicture.memory(
                            base64Decode(controller.data.gambar_utama!),
                            width: 85,
                            height: 85,
                            fit: BoxFit.contain,
                          )
                        : Image.memory(
                            base64Decode(controller.data.gambar_utama!),
                            width: 85,
                            height: 85,
                            fit: BoxFit.contain,
                          )
                    : Image.asset(
                        AppString.defaultImg,
                        width: 85,
                        height: 85,
                        fit: BoxFit.contain,
                      ),
              ),
              Padding(
                padding: AppPading.customBottomPadding(),
                child: Text(
                  'Isi Paket',
                  style: AppFont.regular(),
                ),
              ),
              Obx(() {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  height: 200,
                  margin: AppPading.customBottomPadding(),
                  child: controller.detailpaket.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.detailpaket.length,
                          itemBuilder: (context, index) {
                            final customer = controller.detailpaket;

                            return Column(
                              children: [
                                ListTile(
                                  leading: customer[index].gambarproduk != '' &&
                                          customer[index].gambarproduk != null
                                      ? controller.isBase64Svg(
                                              customer[index].gambarproduk!)
                                          ? SvgPicture.memory(
                                              base64Decode(customer[index]
                                                  .gambarproduk!),
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.contain,
                                            )
                                          : Image.memory(
                                              base64Decode(customer[index]
                                                  .gambarproduk!),
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.contain,
                                            )
                                      : Image.asset(
                                          AppString.defaultImg,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        ),
                                  title: Text(customer[index].namaproduk!,
                                      style: AppFont.regular()),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Modal :' +
                                            AppFormat().numFormat(
                                                customer[index].harga_modal),
                                        style: AppFont.small(),
                                      ),
                                      Text(
                                        'HPP :' +
                                            AppFormat()
                                                .numFormat(customer[index].hpp),
                                        style: AppFont.small(),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    'Qty :' +
                                        ' ' +
                                        customer[index].qty.toString(),
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
                      : Center(child: Text('Paket kosong')),
                );
              }),

              // Product Details Section
              Column(
                children: [
                  _buildDetailTile(
                      title: 'Nama Paket', value: controller.data.nama_paket!),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Harga modal',
                      value:
                          'Rp ${NumberFormat('#,###').format(controller.data.harga_modal)}'),
                  _buildDetailTile(
                      title: 'HPP',
                      value:
                          'Rp ${NumberFormat('#,###').format(controller.data.hpp)}'),
                  _buildDetailTile(
                      title: 'Harga jual paket',
                      value:
                          'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_paket)}'),
                  Divider(height: 0, thickness: 0.5),
                  _buildDetailTile(
                      title: 'Diskon',
                      value:
                          'Rp ${NumberFormat('#,###').format(controller.data.diskon)}'),
                  _buildDetailTile(
                      title: controller.data.namapajak ?? 'Pajak',
                      value: controller.data.namapajak != null
                          ? ' ${NumberFormat('#,###').format(controller.data.nominalpajak)} %'
                          : '-'),
                ],
              ),

              // Pricing Section

              // Taxes Section

              // Additional Details

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
        value: value, activeTrackColor: AppColor.primary,
        onChanged: null, // Disabled switch for display
        activeColor: AppColor.primary,
      ),
    );
  }
}
