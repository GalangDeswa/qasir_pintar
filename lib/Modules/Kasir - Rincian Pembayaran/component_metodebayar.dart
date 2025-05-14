import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Rincian%20Pembayaran/component_metodetunai.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Rincian%20Pembayaran/controller_rincianpembayaran.dart';

import '../Kasir - Pembayaran/controller_pembayaran.dart';

class MetodeBayar extends GetView<PembayaranController> {
  const MetodeBayar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Column(
          children: [
            TabBar(
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primary, AppColor.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Tunai',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // Tab(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Non tunai',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // ),
                // Tab(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Hutang',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                MetodeTunai(),
                Column(
                  children: [
                    Container(
                      //color: Colors.red,
                      height: 100,
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  side: WidgetStateProperty.all(BorderSide(
                                    color: Colors.blueAccent, // Border color
                                    width: 2.0, // Border width
                                  )),
                                  elevation: WidgetStateProperty.all(
                                      5), // Shadow effect
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  )),
                                ),
                                onPressed: () {
                                  // Your onPressed code here
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Text(
                                    "Transfer",
                                    style: AppFont.regular(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  side: WidgetStateProperty.all(BorderSide(
                                    color: Colors.blueAccent, // Border color
                                    width: 2.0, // Border width
                                  )),
                                  elevation: WidgetStateProperty.all(
                                      5), // Shadow effect
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  )),
                                ),
                                onPressed: () {
                                  // Your onPressed code here
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Text(
                                    "Qris",
                                    style: AppFont.regular(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  side: WidgetStateProperty.all(BorderSide(
                                    color: Colors.blueAccent, // Border color
                                    width: 2.0, // Border width
                                  )),
                                  elevation: WidgetStateProperty.all(
                                      5), // Shadow effect
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  )),
                                ),
                                onPressed: () {
                                  // Your onPressed code here
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Text(
                                    "Dana",
                                    style: AppFont.regular(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  side: WidgetStateProperty.all(BorderSide(
                                    color: Colors.blueAccent, // Border color
                                    width: 2.0, // Border width
                                  )),
                                  elevation: WidgetStateProperty.all(
                                      5), // Shadow effect
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  )),
                                ),
                                onPressed: () {
                                  // Your onPressed code here
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Text(
                                    "Lainnya",
                                    style: AppFont.regular(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //TextButton(onPressed: () {}, child: Text('Tambah catatan')),
                  ],
                ),
                MetodeTunai(),
              ]),
            )
          ],
        ));
  }
}
