import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Services/BoxStorage.dart';
import 'package:qasir_pintar/Services/Handler.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../../Controllers/CentralController.dart';
import '../../Controllers/printerController.dart';
import '../../Middleware/Navigation.dart';
import '../test.dart';

class HomeScreen extends GetView<BasemenuController> {
  @override
  Widget build(BuildContext context) {
    final PrintController _ctrl = Get.put(PrintController());
    final StorageService box = Get.find<StorageService>();
    //final nav = Get.find<NavigationService>();

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
                  // image: DecorationImage(
                  //     colorFilter: ColorFilter.mode(
                  //         AppColor.primary.withValues(alpha: 0.15),
                  //         BlendMode.dstATop),
                  //     fit: BoxFit.cover,
                  //     image: AssetImage('assets/images/bg.png')),
                  gradient: AppGradient.customGradientv2(),
                  color: AppColor.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
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
                        Colors.greenAccent.withOpacity(0.2),
                        BlendMode.multiply,
                      ),
                    ),
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
                      Padding(
                        padding: AppPading.customBottomPadding(),
                        child: Text(
                          DateFormat(
                            'EEEE, dd MMMM yyyy',
                          ).format(DateTime.now()),
                          style: AppFont.regular_white_bold(),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pendapatan Hari ini',
                                    style: AppFont.regular_white(),
                                  ),
                                  SizedBox(height: 5),
                                  Obx(() {
                                    return Text(
                                      'Rp. ' +
                                          AppFormat().numFormat(
                                            controller.netProfit.value,
                                          ),
                                      style: TextStyle(
                                        fontSize: 20,
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
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Penjualan Hari ini',
                                    style: AppFont.regular_white(),
                                  ),
                                  SizedBox(height: 1),
                                  Obx(() {
                                    return Text(
                                      AppFormat().moneyFormat(
                                        controller
                                            .summary.first.totalKeuntungan,
                                      ),
                                      style: AppFont.regular_white_bold(),
                                    );
                                  }),
                                  SizedBox(height: 10),
                                  Text(
                                    'beban Hari ini',
                                    style: AppFont.regular_white(),
                                  ),
                                  SizedBox(height: 1),
                                  Obx(() {
                                    return Text(
                                      AppFormat().moneyFormat(
                                        controller
                                            .summary.first.totalJumlahBeban,
                                      ),
                                      style: AppFont.regular_white_bold(),
                                    );
                                  }),
                                  SizedBox(height: 2),
                                ],
                              ),
                            ),
                          ],
                        ),
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
          SizedBox(height: context.res_height * 0.10),

          // Shortcut Icons

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   padding: EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //     color: AppColor.primary,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Text(
                //     'Welcome',
                //     style: AppFont.regular_white_bold(fontSize: 20),
                //   ),
                // ),
                // Expanded(
                //   child: Container(
                //     margin: EdgeInsets.only(left: 10),
                //     width: Get.width,
                //     height: 3,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(12),
                //       color: AppColor.primary,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: AppPading.defaultBodyPadding(),
            child: Card(
              color: Colors.white,
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  //color: Colors.cyan.withValues(alpha: 0.1),
                ),
                padding: EdgeInsets.all(25),
                width: Get.width,
                //height: Get.height * 0.15,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 30, // Horizontal space between icons
                  runSpacing: 20, // Vertical space between icons
                  children: [
                    _buildShortcutIcon(
                      'assets/icons/inventory.svg',
                      'Inventori',
                      () {
                        Get.toNamed('/basemenu_stock');
                      },
                    ),
                    _buildShortcutIcon(
                      'assets/icons/customer.svg',
                      'Pelanggan',
                      () {
                        Get.toNamed('/basemenupelanggan');
                      },
                    ),
                    // _buildShortcutIcon(
                    //   'assets/icons/box.svg',
                    //   'Produk',
                    //   () {
                    //     //nav.toProduk();
                    //     Get.toNamed('/basemenuproduk');
                    //     // Navigator.of(context).push(MaterialPageRoute(
                    //     //     builder: (context) => PhysicsAndSnapGridExample()));
                    //   },
                    // ),
                    _buildShortcutIcon('assets/icons/receipt.svg', 'Riwayat',
                        () {
                      Get.toNamed('/history');
                    }),
                    // Add more icons as needed
                  ],
                ),
              ),
            ),
          ),

          button_solid_custom(
            onPressed: () async {
              final api = Get.find<API>();
              api.fetchProduk();
            },
            child: Text('api prduk'),
            width: Get.width,
          ),

          SizedBox(height: 25),
          // Recent Transactions
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: Text(
          //     'Transaksi hari ini',
          //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          //   ),
          // ),

          // IconButton(
          //     onPressed: () {
          //       box.remove('karyawan_login');
          //       box.remove('karyawan_nama');
          //       box.remove('karyawan_id');
          //       box.remove('karyawan_role');
          //     },
          //     icon: Icon(FontAwesomeIcons.remove))

          // Obx(() {
          //   return Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // 1) Scan Button + Spinner
          //       Row(
          //         children: [
          //           ElevatedButton.icon(
          //             icon: const Icon(Icons.search),
          //             label: const Text('Scan Printers'),
          //             onPressed: () => _ctrl.startScan(),
          //           ),
          //           const SizedBox(width: 12),
          //           if (_ctrl.devices.isEmpty)
          //             const SizedBox(
          //               width: 20,
          //               height: 20,
          //               child: CircularProgressIndicator(strokeWidth: 2),
          //             ),
          //         ],
          //       ),
          //       const SizedBox(height: 20),
          //
          //       // 2) Dropdown of discovered devices
          //       const Text(
          //         'Select Printer:',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       const SizedBox(height: 8),
          //       DropdownButton<BluetoothDevice>(
          //         isExpanded: true,
          //         hint: const Text('Choose a device'),
          //         value: _ctrl.selectedDevice.value,
          //         items: _ctrl.devices.map((device) {
          //           final name = device.name ?? 'Unknown';
          //           final addr = device.address ?? '—';
          //           return DropdownMenuItem<BluetoothDevice>(
          //             value: device,
          //             child: Text('$name ($addr)'),
          //           );
          //         }).toList(),
          //         onChanged: (device) => _ctrl.selectDevice(device),
          //       ),
          //       const SizedBox(height: 20),
          //
          //       // 3) Connect / Disconnect Button
          //       if (!_ctrl.isConnected.value)
          //         ElevatedButton.icon(
          //           icon: const Icon(Icons.bluetooth_connected),
          //           label: const Text('Connect'),
          //           onPressed: (_ctrl.selectedDevice.value != null)
          //               ? () => _ctrl.connect()
          //               : null,
          //         )
          //       else
          //         ElevatedButton.icon(
          //           icon: const Icon(Icons.bluetooth_disabled),
          //           label: const Text('Disconnect'),
          //           //style: ElevatedButton.styleFrom(primary: Colors.red),
          //           onPressed: () => _ctrl.disconnect(),
          //         ),
          //
          //       const SizedBox(height: 30),
          //
          //       // 4) Print Sample Text (only enabled when connected)
          //       ElevatedButton.icon(
          //         icon: const Icon(Icons.print),
          //         label: const Text('Print Sample Text'),
          //         onPressed: (_ctrl.isConnected.value)
          //             ? () => _ctrl.printSampleText()
          //             : null,
          //         style: ElevatedButton.styleFrom(
          //             minimumSize: const Size.fromHeight(45)),
          //       ),
          //
          //       const SizedBox(height: 30),
          //
          //       // 5) Status indicator
          //       Row(
          //         children: [
          //           const Text('Status: ',
          //               style: TextStyle(fontWeight: FontWeight.bold)),
          //           Text(
          //             _ctrl.isConnected.value ? 'Connected' : 'Not Connected',
          //             style: TextStyle(
          //               color:
          //                   _ctrl.isConnected.value ? Colors.green : Colors.red,
          //               fontSize: 16,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   );
          // }),

          // Obx(() {
          //   return Padding(
          //     padding: AppPading.defaultBodyPadding(),
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: controller.penjualan.length,
          //       itemBuilder: (context, index) {
          //         var penjualan = controller.penjualan[index];
          //         return GestureDetector(
          //           onTap: () {
          //             Get.toNamed('/detail_history', arguments: penjualan);
          //           },
          //           child: ListTile(
          //             leading: Container(
          //               padding: EdgeInsets.all(8),
          //               decoration: BoxDecoration(
          //                 color: Colors.blue.withOpacity(0.1),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //               child: Icon(Icons.receipt, color: Colors.blue),
          //             ),
          //             title: Text(
          //               penjualan.noFaktur!,
          //               style: AppFont.regular_bold(),
          //             ),
          //             subtitle:
          //                 Text(penjualan.tanggal!, style: AppFont.small()),
          //           ),
          //         );
          //       },
          //     ),
          //   );
          // }),
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
            child: SvgPicture.asset(iconPath, width: 35, height: 35),
          ),
        ),
        SizedBox(height: 15),
        Text(label, style: AppFont.regular_bold()),
      ],
    );
  }
}
