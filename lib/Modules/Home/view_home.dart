import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Base%20menu/controller_basemenu.dart';

import '../test.dart';

class HomeScreen extends GetView<BasemenuController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: context.res_height * 0.14,
                decoration: BoxDecoration(
                    gradient: AppGradient.customGradientv2(),
                    color: AppColor.primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              ),
              Positioned(
                top: 20, // Background height + margin
                left: 20,
                right: 20,
                child: Container(
                  height: context.res_height * 0.2,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/bgcard.png'),
                        fit: BoxFit.cover,
                        opacity: 0.35,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.multiply)),
                    gradient: AppGradient.customGradient(),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Penjualan Hari ini',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Obx(() {
                                  return Text(
                                    '\Rp. ${controller.totaluang.toString()}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Container(
                            width: 1.2,
                            color: Colors.white,
                            height: 100,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Beban Hari ini',
                                  style: AppFont.regular_white(),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  '\Rp. 10,000',
                                  style: AppFont.regular_white_bold(),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'transaksi Hari ini',
                                  style: AppFont.regular_white(),
                                ),
                                SizedBox(height: 1),
                                Obx(() {
                                  return Text(
                                    controller.totalpenjualan.toString(),
                                    style: AppFont.regular_white_bold(),
                                  );
                                }),
                                SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // LinearProgressIndicator(
                      //   value: 0.7,
                      //   backgroundColor: Colors.white.withOpacity(0.3),
                      //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      // ),
                      // SizedBox(height: 8),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       '70% of target',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //     Text(
                      //       '\$1,750 target',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //summary

          SizedBox(height: context.res_height * 0.13),
          // Shortcut Icons
          Padding(
            padding: AppPading.defaultBodyPadding(),
            child: Wrap(
              spacing: 30, // Horizontal space between icons
              runSpacing: 20, // Vertical space between icons
              children: [
                _buildShortcutIcon(
                  'assets/icons/customer.svg',
                  'Pelanggan',
                  () {
                    Get.toNamed('/basemenupelanggan');
                  },
                ),
                _buildShortcutIcon(
                  'assets/icons/employe.svg',
                  'Karyawan',
                  () {
                    Get.toNamed('/karyawan');
                  },
                ),
                _buildShortcutIcon(
                  'assets/icons/box.svg',
                  'Produk',
                  () {
                    Get.toNamed('/basemenuproduk');
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => PhysicsAndSnapGridExample()));
                  },
                ),
                _buildShortcutIcon(
                  'assets/icons/gear.svg',
                  'Pengaturan',
                  () {
                    Get.toNamed('/pengaturan');
                  },
                ),
                // Add more icons as needed
              ],
            ),
          ),
          SizedBox(height: 25),
          // Recent Transactions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Transaksi hari ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Obx(() {
            return Padding(
              padding: AppPading.defaultBodyPadding(),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.penjualan.length,
                itemBuilder: (context, index) {
                  var penjualan = controller.penjualan[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/detail_history', arguments: penjualan);
                    },
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.receipt, color: Colors.blue),
                        ),
                        title: Text(
                          'Transaksi #${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(penjualan.noFaktur!),
                        trailing: Text(
                          penjualan.tanggal!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // Helper method to build a shortcut icon
  Widget _buildShortcutIcon(String iconPath, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 30,
              height: 30,
            ),
          ),
        ),
        SizedBox(height: 15),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
