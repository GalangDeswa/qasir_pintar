import 'dart:convert';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../Config/config.dart';
import '../../Controllers/printerController.dart';
import 'binding_basemenu.dart';
import 'controller_basemenu.dart';

class DrawerBase extends GetView<BasemenuController> {
  const DrawerBase({super.key});

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
                        controller.datauser.first.businessName!,
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
                // ExpansionTile(
                //   title: ListTile(
                //     leading: Icon(
                //       FontAwesomeIcons.starOfLife,
                //       color: AppColor.primary,
                //     ),
                //     title: Text(
                //       'Aplikasi',
                //       style: AppFont.regular(),
                //     ),
                //   ),
                //   children: [
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.truckPickup,
                //       title: 'Distributor',
                //       onTap: () {
                //         Get.offAllNamed('/base_menu_distributor');
                //       },
                //     ),
                //     _buildDrawerItem(
                //       icon: FontAwesomeIcons.cashRegister,
                //       title: 'P.O.S',
                //       onTap: () {
                //         Get.offAllNamed('/basemenu');
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
                ExpansionTile(
                  title: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.book,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Penjualan',
                      style: AppFont.regular(),
                    ),
                  ),
                  children: [
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.receipt,
                      title: 'Riwayat Penjualan',
                      onTap: () {
                        Get.toNamed('/history');
                      },
                    ),
                    // _buildDrawerItem(
                    //   icon: FontAwesomeIcons.chartSimple,
                    //   title: 'Laporan',
                    //   onTap: () {
                    //     Get.toNamed('/laporanmenu');
                    //   },
                    // ),
                    // _buildDrawerItem(
                    //   icon: FontAwesomeIcons.book,
                    //   title: 'Laporan',
                    //   onTap: () {
                    //     Get.toNamed('/laporanmenu');
                    //   },
                    // ),
                  ],
                ),
                ExpansionTile(
                  title: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.chartSimple,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Laporan',
                      style: AppFont.regular(),
                    ),
                  ),
                  children: [
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.book,
                      title: 'Umum',
                      onTap: () {
                        Get.toNamed('/ringkasanpenjualan');
                      },
                    ),
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.cartShopping,
                      title: 'Penjualan',
                      onTap: () {
                        Get.toNamed('/penjualan_laporan');
                      },
                    ),
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.moneyBill,
                      title: 'Beban',
                      onTap: () {
                        Get.toNamed('/beban_laporan');
                      },
                    ),
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.cancel,
                      title: 'Reversal',
                      onTap: () {
                        Get.toNamed('/reversal_laporan');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.moneyBillWave,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Beban',
                      style: AppFont.regular(),
                    ),
                    onTap: () {
                      Get.toNamed('/basemenu_beban');
                    },
                  ),
                ),
                ExpansionTile(
                  title: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.box,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Produk',
                      style: AppFont.regular(),
                    ),
                  ),
                  children: [
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.boxOpen,
                      title: 'Produk / kategori',
                      onTap: () {
                        Get.toNamed('/basemenuproduk');
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
                      icon: FontAwesomeIcons.boxesStacked,
                      title: 'Inventori',
                      onTap: () {
                        Get.toNamed('/basemenu_stock');
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.phone,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Data Kontak',
                      style: AppFont.regular(),
                    ),
                  ),
                  children: [
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
                  ],
                ),
                Divider(
                  color: Colors.black.withOpacity(0.1),
                  thickness: 1,
                  height: 20,
                  indent: 16,
                  endIndent: 16,
                ),
                ExpansionTile(
                  title: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.print,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Printer',
                      style: AppFont.regular(),
                    ),
                  ),
                  children: [
                    Obx(() {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1) Scan Button + Spinner
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.search),
                                  label: const Text('Scan Printers'),
                                  onPressed: () => _ctrl.startScan(),
                                ),
                                const SizedBox(width: 12),
                                if (_ctrl.isScanning.value == true)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                else
                                  Container(),
                              ],
                            ),
                            const SizedBox(height: 20),

                            _ctrl.devices.isEmpty
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        // 2) Dropdown of discovered devices
                                        const Text(
                                          'Select Printer:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        DropdownButton<String>(
                                          isExpanded: true,
                                          hint: const Text('Choose a device'),
                                          value: _ctrl.selectedAddress.value,
                                          items: _ctrl.devices.map((device) {
                                            final name =
                                                device.name ?? 'Unknown';
                                            final addr = device.address ?? '—';
                                            return DropdownMenuItem<String>(
                                              value: addr,
                                              child: Text('$name ($addr)'),
                                            );
                                          }).toList(),
                                          onChanged: (addr) {
                                            final device = _ctrl.devices
                                                .firstWhere(
                                                    (d) => d.address == addr);
                                            _ctrl.selectDevice(device);
                                          },
                                        ),
                                        const SizedBox(height: 20),

                                        // 3) Connect / Disconnect Button
                                        if (!_ctrl.isConnected.value)
                                          _ctrl.connecting.value == true
                                              ? Row(children: [
                                                  ElevatedButton.icon(
                                                    icon: const Icon(Icons
                                                        .bluetooth_connected),
                                                    label:
                                                        const Text('Connect'),
                                                    onPressed: (_ctrl
                                                                .selectedDevice
                                                                .value !=
                                                            null)
                                                        ? () => _ctrl.connect()
                                                        : null,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  )
                                                ])
                                              : ElevatedButton.icon(
                                                  icon: const Icon(Icons
                                                      .bluetooth_connected),
                                                  label: const Text('Connect'),
                                                  onPressed: (_ctrl
                                                              .selectedDevice
                                                              .value !=
                                                          null)
                                                      ? () => _ctrl.connect()
                                                      : null,
                                                )
                                        else
                                          ElevatedButton.icon(
                                            icon: const Icon(
                                                Icons.bluetooth_disabled),
                                            label: const Text('Disconnect'),
                                            //style: ElevatedButton.styleFrom(primary: Colors.red),
                                            onPressed: () => _ctrl.disconnect(),
                                          ),

                                        const SizedBox(height: 30),

                                        // 4) Print Sample Text (only enabled when connected)
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.print),
                                          label:
                                              const Text('Print Sample Text'),
                                          onPressed: (_ctrl.isConnected.value)
                                              ? () => _ctrl.printSampleText()
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                              minimumSize:
                                                  const Size.fromHeight(45)),
                                        ),
                                      ]),

                            const SizedBox(height: 30),

                            // 5) Status indicator
                            Row(
                              children: [
                                const Text('Status printer : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  _ctrl.isConnected.value
                                      ? 'Connected'
                                      : 'Not Connected',
                                  style: TextStyle(
                                    color: _ctrl.isConnected.value
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                ExpansionTile(
                  title: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.gears,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      'Pengaturan',
                      style: AppFont.regular(),
                    ),
                  ),
                  children: [
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
                  ],
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
