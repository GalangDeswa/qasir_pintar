import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qasir_pintar/Modules/Produk/stock/view_basemenustock.dart';
import 'package:qasir_pintar/Widget/popscreen.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Config/config.dart';
import 'binding_basemenu.dart';
import 'controller_basemenu.dart';

class DrawerBase extends GetView<BasemenuController> {
  const DrawerBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            padding: AppPading.defaultBodyPadding(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: AppColor.primary,
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment(1.0, -0.5),
                colorFilter: ColorFilter.mode(
                    AppColor.primary.withOpacity(1), BlendMode.dstATop),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return CircleAvatar(
                    backgroundImage: controller.datauser.first.logo != '-'
                        ? MemoryImage(
                            base64Decode(controller.datauser.first.logo!))
                        : AssetImage(AppString.defaultImg),
                    backgroundColor: Colors.white,
                    radius: 40,
                  );
                }),
                SizedBox(width: 16),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.datauser.first.businessName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller.datauser.first.businessTypeName!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: FontAwesomeIcons.userCheck,
                  title: 'Manager',
                  onTap: () {
                    // Popscreen().toursplash();
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.cashRegister,
                  title: 'Kasir',
                  onTap: () {
                    // Get.toNamed('/edit_tokov2');
                    //controller.stringGenerator(10);
                  },
                ),
                Divider(
                  color: Colors.black.withOpacity(0.1),
                  thickness: 1,
                  height: 20,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.receipt,
                  title: 'Penjualan',
                  onTap: () {
                    Get.toNamed('/history');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.tags,
                  title: 'Promo / Kupon',
                  onTap: () {
                    Get.toNamed('/promo');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.book,
                  title: 'Laporan',
                  onTap: () {
                    Get.toNamed('/laporanmenu');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.personBooth,
                  title: 'Karyawan',
                  onTap: () {
                    Get.toNamed('/karyawan');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.person,
                  title: 'Pelanggan',
                  onTap: () {
                    Get.toNamed('/basemenupelanggan');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.boxesPacking,
                  title: 'Supplier',
                  onTap: () {
                    Get.toNamed('/supplier');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.boxOpen,
                  title: 'Produk/kategori',
                  onTap: () {
                    Get.toNamed('/basemenuproduk');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.boxesStacked,
                  title: 'Inventori',
                  onTap: () {
                    Get.toNamed('/basemenu_stock');
                  },
                ),
                Divider(
                  color: Colors.black.withOpacity(0.1),
                  thickness: 1,
                  height: 20,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.gear,
                  title: 'Pengaturan',
                  onTap: () {
                    Get.toNamed('/pengaturan');
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.sync,
                  title: 'Sync',
                  onTap: () {
                    // Get.toNamed('/edit_tokov2');
                    //controller.stringGenerator(10);
                  },
                ),
                Divider(
                  color: Colors.black.withOpacity(0.1),
                  thickness: 1,
                  height: 20,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.signOut,
                  title: 'Keluar',
                  onTap: () {
                    // Get.toNamed('/edit_tokov2');
                    //controller.stringGenerator(10);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: ListTile(
        leading: Icon(icon, color: AppColor.primary),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        onTap: onTap,
        hoverColor: AppColor.secondary.withOpacity(0.1),
        splashColor: Colors.orangeAccent.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
