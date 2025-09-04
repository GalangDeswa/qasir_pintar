import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Produk/stock/controller_basemenustock.dart';

import '../../../Widget/popscreen.dart';
import '../../../Widget/widget.dart';

class RincianPembayaranPemesanan extends GetView<BasemenuStockController> {
  const RincianPembayaranPemesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Rincian Pembayaran Pemesanan',
        NeedBottom: false,
      ),
      body: Column(
        children: [
          UppermenuRincianPemesanan(),
          Expanded(child: MetodeBayarPemesanan()),
          BottommenuRincianPemesanan(),
        ],
      ),
    );
  }
}

class UppermenuRincianPemesanan extends GetView<BasemenuStockController> {
  const UppermenuRincianPemesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: context.res_width,
        color: AppColor.primary,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Total tagihan',
                      style: AppFont.regular_white_bold(fontSize: 15),
                    ),
                  ),
                  Text(
                    'Rp. ' + AppFormat().numFormat(controller.total.value),
                    style: AppFont.big_white(),
                  )
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 20),
            //   width: 2,
            //   color: Colors.white,
            // ),
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         'Pembayaran',
            //         style: AppFont.regular_white(),
            //       ),
            //       Text(
            //         'Rp. ' + controller.totalHarga.toString(),
            //         style: AppFont.big_white(),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ));
  }
}

class MetodeBayarPemesanan extends GetView<BasemenuStockController> {
  const MetodeBayarPemesanan({super.key});

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
                MetodeTunaiPemesanan(),
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
                MetodeTunaiPemesanan(),
              ]),
            )
          ],
        ));
  }
}

class BottommenuRincianPemesanan extends GetView<BasemenuStockController> {
  const BottommenuRincianPemesanan({super.key});

  @override
  Widget build(BuildContext context) {
    //final PrintController _ctrl = Get.put(PrintController());
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.all(10),
          color: AppColor.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pembayaran',
                style: AppFont.regular_white(),
              ),
              Obx(() {
                return Center(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: controller.bayar.value,
                    style: AppFont.big_white(),
                    keyboardType: TextInputType.number,
                  ),
                );
              })
            ],
          ),
        ),
        Container(
            height: 60,
            width: context.res_width,
            color: AppColor.primary,
            child: button_border_custom(
                onPressed: () {
                  if (controller.bayarvalue < controller.total.value) {
                    Get.showSnackbar(toast().bottom_snackbar_error(
                        "Error", 'uang tidak mencukupi'));
                    return;
                  }
                  //Popscreen().konfirmasibayar(controller.keranjang, controller);
                  //controller.printString();
                  //controller.startScan();
                  // controller.printReceipt(controller.printers[0]);
                },
                child: Text('Bayar'),
                width: Get.width)),
      ],
    );
  }
}

class MetodeTunaiPemesanan extends GetView<BasemenuStockController> {
  const MetodeTunaiPemesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(BorderSide(
                        color: Colors.blueAccent, // Border color
                        width: 2.0, // Border width
                      )),
                      elevation: WidgetStateProperty.all(5), // Shadow effect
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      )),
                    ),
                    onPressed: () {
                      // controller.addbayar(controller.total.value);
                      controller.bayarvalue.value = controller.total.value;
                      controller.bayar.value.text =
                          AppFormat().numFormat(controller.total.value);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        "Uang Pas",
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
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(BorderSide(
                        color: Colors.blueAccent, // Border color
                        width: 2.0, // Border width
                      )),
                      elevation: WidgetStateProperty.all(5), // Shadow effect
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      )),
                    ),
                    onPressed: () {
                      controller.addbayar(5000);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        "Rp.5.000",
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
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(BorderSide(
                        color: Colors.blueAccent, // Border color
                        width: 2.0, // Border width
                      )),
                      elevation: WidgetStateProperty.all(5), // Shadow effect
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      )),
                    ),
                    onPressed: () {
                      controller.addbayar(10000);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        "Rp.10.000",
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
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(BorderSide(
                        color: Colors.blueAccent, // Border color
                        width: 2.0, // Border width
                      )),
                      elevation: WidgetStateProperty.all(5), // Shadow effect
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      )),
                    ),
                    onPressed: () {
                      controller.addbayar(20000);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        "Rp.20.000",
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
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(BorderSide(
                        color: Colors.blueAccent, // Border color
                        width: 2.0, // Border width
                      )),
                      elevation: WidgetStateProperty.all(5), // Shadow effect
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      )),
                    ),
                    onPressed: () {
                      controller.addbayar(50000);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        "Rp.50.000",
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
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(BorderSide(
                        color: Colors.blueAccent, // Border color
                        width: 2.0, // Border width
                      )),
                      elevation: WidgetStateProperty.all(5), // Shadow effect
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      )),
                    ),
                    onPressed: () {
                      // controller.bayarvalue.value = 100000;
                      // controller.bayar.value.text = "100.000";
                      controller.addbayar(100000);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        "Rp.100.000",
                        style: AppFont.regular(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // TextButton(onPressed: () {}, child: Text('Tambah catatan')),
      ],
    );
  }
}
