import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Users/controller_user.dart';
import 'package:qasir_pintar/Widget/widget.dart';

class User extends GetView<UserController> {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'User', NeedBottom: false),
      body: SingleChildScrollView(
        padding: AppPading.defaultBodyPadding(),
        child: Obx(() {
          return Column(
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
                    backgroundImage: controller.userList.first.logo != '-'
                        ? MemoryImage(
                            base64Decode(controller.userList.first.logo!),
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
                        title: 'Nama Usaha',
                        value: controller.userList.first.businessName!,
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Jenis Usaha',
                        value: controller.userList.first.businessTypeName!,
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Nama Pengguna',
                        value: controller.userList.first.name!,
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Email',
                        value: controller.userList.first.email!,
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Nomor HP',
                        value: controller.userList.first.phone!,
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Alamat',
                        value: controller.userList.first.address ??
                            "Alamat belum ditentukan",
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Provinsi',
                        value: controller.userList.first.provinceName ??
                            "Provinsi belum ditentukan",
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Kabupaten',
                        value: controller.userList.first.regencyName ??
                            "Kabupaten belum ditentukan",
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildDetailTile(
                        title: 'Kecamatan',
                        value: controller.userList.first.districtName ??
                            "Kecamatan belum ditentukan",
                      ),
                    ],
                  ),
                ),
              ),

              // Edit Button Section
              Padding(
                padding: AppPading.customTopPadding(),
                child: button_solid_custom(
                    onPressed: () {
                      Get.toNamed('/updateuser',
                          arguments: controller.userList.first);
                    },
                    child: Text('Edit user'),
                    width: context.res_width),
              )
            ],
          );
        }),
      ),
    );
  }

  // Helper method to build a detail tile
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
