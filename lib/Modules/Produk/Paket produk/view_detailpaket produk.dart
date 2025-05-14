import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Modules/Produk/Paket%20produk/controller_detailpaketproduk.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';
import '../controller_basemenuproduk.dart';

class DetailPaketProduk extends GetView<DetailPaketProdukController> {
  const DetailPaketProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Detail Produk', NeedBottom: false),
      body: SingleChildScrollView(
        child: Column(
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
            // controller.gambarlist.isNotEmpty
            //     ? CarouselSlider(
            //     options: CarouselOptions(
            //       onPageChanged: (index, reason) {
            //         controller.current(index);
            //       },
            //       viewportFraction: 0.45,
            //       enlargeCenterPage: true,
            //       enableInfiniteScroll: true,
            //       autoPlay: true,
            //       autoPlayInterval: Duration(seconds: 5),
            //     ),
            //     items: controller.gambarlist.map((x) {
            //       return Card(
            //         color: Colors.white,
            //         elevation: 4,
            //         child: x.gambar != '-' || x.gambar != null
            //             ? controller.isBase64Svg(x.gambar!)
            //             ? SvgPicture.memory(
            //           base64Decode(x.gambar!),
            //           fit: BoxFit.cover,
            //         )
            //             : Image.memory(
            //           base64Decode(x.gambar!),
            //           fit: BoxFit.cover,
            //         )
            //             : Image.asset(
            //           AppString.defaultImg,
            //           fit: BoxFit.cover,
            //         ),
            //       );
            //     }).toList())
            //     : Text(
            //   'Gambar kosong',
            //   style: AppFont.regular(),
            // ),

            ClipOval(
              child: controller.data.gambar_utama != '-' &&
                      controller.data.gambar_utama != null
                  ? controller.isBase64Svg(controller.data.gambar_utama!)
                      ? SvgPicture.memory(
                          base64Decode(controller.data.gambar_utama!),
                          width: 60,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          base64Decode(controller.data.gambar_utama!),
                          width: 60,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                  : Image.asset(
                      AppString.defaultImg,
                      width: 60,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
            ),

            Obx(() {
              return Container(
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
                                leading: ClipOval(
                                  child: customer[index].gambarproduk != '' &&
                                          customer[index].gambarproduk != null
                                      ? controller.isBase64Svg(
                                              customer[index].gambarproduk!)
                                          ? SvgPicture.memory(
                                              base64Decode(customer[index]
                                                  .gambarproduk!),
                                              width: 30,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              base64Decode(customer[index]
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
                                subtitle: Text(
                                  customer[index].hargabeliproduk.toString()!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Text(
                                  'QTY X' +
                                      ' ' +
                                      customer[index].qty.toString(),
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
                                //       (item) => DropdownMenuItem<MenuItem>(
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
                                //       borderRadius: BorderRadius.circular(4),
                                //     ),
                                //     offset: const Offset(0, 8),
                                //   ),
                                //   menuItemStyleData: MenuItemStyleData(
                                //     customHeights: [
                                //       8,
                                //       ...List<double>.filled(
                                //           MenuItems.secondItems.length, 48),
                                //     ],
                                //     padding: const EdgeInsets.only(
                                //         left: 16, right: 16),
                                //   ),
                                // ),
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
                        title: 'Nama Paket',
                        value: controller.data.nama_paket!),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                        title: 'Harga modal',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_modal)}'),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                        title: 'HPP',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.hpp)}'),
                    _buildDetailTile(
                        title: 'Harga jual paket',
                        value:
                            'Rp ${NumberFormat('#,###').format(controller.data.harga_jual_paket)}'),
                  ],
                ),
              ),
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
