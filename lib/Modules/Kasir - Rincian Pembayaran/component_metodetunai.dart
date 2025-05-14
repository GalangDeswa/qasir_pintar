import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Pembayaran/controller_pembayaran.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Rincian%20Pembayaran/controller_rincianpembayaran.dart';

class MetodeTunai extends GetView<PembayaranController> {
  const MetodeTunai({super.key});

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
                          controller.total.value.toString();
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
