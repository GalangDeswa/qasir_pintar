import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Detail%20Pelanggan/controller_detailpelanggan.dart';

import '../../../Config/config.dart';
import '../../../Widget/widget.dart';

class DetailPelanggan extends GetView<DetailPelangganController> {
  const DetailPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Detail user', NeedBottom: false),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
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
                    radius: 50,
                    child: controller.data.foto != '-' &&
                            controller.data.foto != null &&
                            controller.data.foto != ''
                        ? controller.isBase64Svg(controller.data.foto!)
                            ? SvgPicture.memory(
                                base64Decode(controller.data.foto!),
                                fit: BoxFit.contain,
                              )
                            : Image.memory(
                                base64Decode(controller.data.foto!),
                                fit: BoxFit.contain,
                              )
                        : Image.asset(
                            AppString.defaultImg,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),

              // User Details Section
              Column(
                children: [
                  _buildDetailTile(
                    title: 'Nama Pelanggan',
                    value: controller.data.namaPelanggan!,
                  ),
                  Divider(height: 20, thickness: 1),
                  _buildDetailTile(
                    title: 'Email',
                    value: controller.data.email! == '' ||
                            controller.data.email! == null
                        ? '-'
                        : controller.data.email!,
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
