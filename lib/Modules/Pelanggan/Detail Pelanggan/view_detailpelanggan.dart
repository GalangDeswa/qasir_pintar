import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Detail%20Pelanggan/controller_detailpelanggan.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class DetailPelanggan extends GetView<DetailPelangganController> {
  const DetailPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Detail user', NeedBottom: false),
      body: SingleChildScrollView(
        padding: AppPading.defaultBodyPadding(),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: controller.data.foto != null
                      ? MemoryImage(
                          base64Decode(controller.data.foto!),
                        )
                      : AssetImage(AppString.defaultImg),
                  backgroundColor: Colors.white,
                  radius: 80,
                ),
              ),
            ),

            // User Details Section
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    _buildDetailTile(
                      title: 'Nama Pelanggan',
                      value: controller.data.namaPelanggan!,
                    ),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                      title: 'Email',
                      value: controller.data.email!,
                    ),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                      title: 'Nomor HP',
                      value: controller.data.noHp!,
                    ),
                    Divider(height: 20, thickness: 1),
                    _buildDetailTile(
                      title: 'Kategori pelanggan',
                      value: controller.data.kategoriNama!,
                    ),
                  ],
                ),
              ),
            ),

            // Edit Button Section
            // Padding(
            //   padding: AppPading.customTopPadding(),
            //   child: button_solid_custom(
            //       onPressed: () {
            //         // Get.toNamed('/updateuser',
            //         //     arguments: controller.userList.first);
            //       },
            //       child: Text(
            //         'Edit Pelanggan',
            //         style: AppFont.regular_white_bold(),
            //       ),
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
}
