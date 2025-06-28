import 'dart:convert';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Base%20Menu/controller_basemenu_distributor.dart';

import '../../Config/config.dart';
import '../../Controllers/printerController.dart';

class DrawerBaseDistributor extends GetView<BaseMenuDistributorController> {
  const DrawerBaseDistributor({super.key});

  @override
  Widget build(BuildContext context) {
    final PrintController _ctrl = Get.put(PrintController());
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
                // alignment: Alignment(1.0, -0.5),
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
                        'Distributor',
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
                ExpansionTile(
                  title: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.starOfLife,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Aplikasi',
                      style: AppFont.regular(),
                    ),
                  ),
                  children: [
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.truckPickup,
                      title: 'Distributor',
                      onTap: () {
                        Get.offAllNamed('/base_menu_distributor');
                      },
                    ),
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.cashRegister,
                      title: 'P.O.v2',
                      onTap: () {
                        Get.offAllNamed('/basemenu');
                      },
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black.withOpacity(0.1),
                  thickness: 1,
                  height: 20,
                  indent: 16,
                  endIndent: 16,
                ),
                // ExpansionTile(
                //   title: ListTile(
                //     leading: Icon(
                //       FontAwesomeIcons.book,
                //       color: AppColor.primary,
                //     ),
                //     title: Text(
                //       'Penjualan',
                //       style: AppFont.regular(),
                //     ),
                //   ),
                //   children: [
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.receipt,
                //       title: 'Riwayat Penjualan',
                //       onTap: () {
                //         Get.toNamed('/history');
                //       },
                //     ),
                //     // _buildDrawerItem(
                //     //   icon: FontAwesomeIcons.book,
                //     //   title: 'Laporan',
                //     //   onTap: () {
                //     //     Get.toNamed('/laporanmenu');
                //     //   },
                //     // ),
                //   ],
                // ),
                // ExpansionTile(
                //   title: ListTile(
                //     leading: Icon(
                //       FontAwesomeIcons.box,
                //       color: AppColor.primary,
                //     ),
                //     title: Text(
                //       'Produk',
                //       style: AppFont.regular(),
                //     ),
                //   ),
                //   children: [
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.boxOpen,
                //       title: 'Produk / kategori',
                //       onTap: () {
                //         Get.toNamed('/basemenuproduk');
                //       },
                //     ),
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.tags,
                //       title: 'Promo / Kupon',
                //       onTap: () {
                //         Get.toNamed('/promo');
                //       },
                //     ),
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.boxesStacked,
                //       title: 'Inventori',
                //       onTap: () {
                //         Get.toNamed('/basemenu_stock');
                //       },
                //     ),
                //   ],
                // ),
                // ExpansionTile(
                //   title: ListTile(
                //     leading: Icon(
                //       FontAwesomeIcons.phone,
                //       color: AppColor.primary,
                //     ),
                //     title: Text(
                //       'Data Kontak',
                //       style: AppFont.regular(),
                //     ),
                //   ),
                //   children: [
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.personBooth,
                //       title: 'Karyawan',
                //       onTap: () {
                //         Get.toNamed('/karyawan');
                //       },
                //     ),
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.person,
                //       title: 'Pelanggan',
                //       onTap: () {
                //         Get.toNamed('/basemenupelanggan');
                //       },
                //     ),
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.boxesPacking,
                //       title: 'Supplier',
                //       onTap: () {
                //         Get.toNamed('/supplier');
                //       },
                //     ),
                //   ],
                // ),
                // Divider(
                //   color: Colors.black.withOpacity(0.1),
                //   thickness: 1,
                //   height: 20,
                //   indent: 16,
                //   endIndent: 16,
                // ),
                // ExpansionTile(
                //   title: ListTile(
                //     leading: Icon(
                //       FontAwesomeIcons.gears,
                //       color: AppColor.primary,
                //     ),
                //     title: Text(
                //       'Pengaturan',
                //       style: AppFont.regular(),
                //     ),
                //   ),
                //   children: [
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.gear,
                //       title: 'Pengaturan',
                //       onTap: () {
                //         Get.toNamed('/pengaturan');
                //       },
                //     ),
                //     Obx(() {
                //       return Container(
                //         padding: EdgeInsets.all(20),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             // 1) Scan Button + Spinner
                //             Row(
                //               children: [
                //                 ElevatedButton.icon(
                //                   icon: const Icon(Icons.search),
                //                   label: const Text('Scan Printers'),
                //                   onPressed: () => _ctrl.startScan(),
                //                 ),
                //                 const SizedBox(width: 12),
                //                 if (_ctrl.devices.isEmpty)
                //                   const SizedBox(
                //                     width: 20,
                //                     height: 20,
                //                     child: CircularProgressIndicator(
                //                         strokeWidth: 2),
                //                   ),
                //               ],
                //             ),
                //             const SizedBox(height: 20),
                //
                //             // 2) Dropdown of discovered devices
                //             const Text(
                //               'Select Printer:',
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             ),
                //             const SizedBox(height: 8),
                //             DropdownButton<BluetoothDevice>(
                //               isExpanded: true,
                //               hint: const Text('Choose a device'),
                //               value: _ctrl.selectedDevice.value,
                //               items: _ctrl.devices.map((device) {
                //                 final name = device.name ?? 'Unknown';
                //                 final addr = device.address ?? '—';
                //                 return DropdownMenuItem<BluetoothDevice>(
                //                   value: device,
                //                   child: Text('$name ($addr)'),
                //                 );
                //               }).toList(),
                //               onChanged: (device) => _ctrl.selectDevice(device),
                //             ),
                //             const SizedBox(height: 20),
                //
                //             // 3) Connect / Disconnect Button
                //             if (!_ctrl.isConnected.value)
                //               ElevatedButton.icon(
                //                 icon: const Icon(Icons.bluetooth_connected),
                //                 label: const Text('Connect'),
                //                 onPressed: (_ctrl.selectedDevice.value != null)
                //                     ? () => _ctrl.connect()
                //                     : null,
                //               )
                //             else
                //               ElevatedButton.icon(
                //                 icon: const Icon(Icons.bluetooth_disabled),
                //                 label: const Text('Disconnect'),
                //                 //style: ElevatedButton.styleFrom(primary: Colors.red),
                //                 onPressed: () => _ctrl.disconnect(),
                //               ),
                //
                //             const SizedBox(height: 30),
                //
                //             // 4) Print Sample Text (only enabled when connected)
                //             ElevatedButton.icon(
                //               icon: const Icon(Icons.print),
                //               label: const Text('Print Sample Text'),
                //               onPressed: (_ctrl.isConnected.value)
                //                   ? () => _ctrl.printSampleText()
                //                   : null,
                //               style: ElevatedButton.styleFrom(
                //                   minimumSize: const Size.fromHeight(45)),
                //             ),
                //
                //             const SizedBox(height: 30),
                //
                //             // 5) Status indicator
                //             Row(
                //               children: [
                //                 const Text('Status: ',
                //                     style:
                //                         TextStyle(fontWeight: FontWeight.bold)),
                //                 Text(
                //                   _ctrl.isConnected.value
                //                       ? 'Connected'
                //                       : 'Not Connected',
                //                   style: TextStyle(
                //                     color: _ctrl.isConnected.value
                //                         ? Colors.green
                //                         : Colors.red,
                //                     fontSize: 16,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       );
                //     }),
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.sync,
                //       title: 'Sync',
                //       onTap: () {
                //         // Get.toNamed('/edit_tokov2');
                //         //controller.stringGenerator(10);
                //       },
                //     ),
                //   ],
                // ),
                // Divider(
                //   color: Colors.black.withOpacity(0.1),
                //   thickness: 1,
                //   height: 20,
                //   indent: 16,
                //   endIndent: 16,
                // ),
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
      padding: EdgeInsets.only(left: 35),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColor.primary,
          size: 20,
        ),
        title: Text(
          title,
          style: AppFont.regular(),
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
