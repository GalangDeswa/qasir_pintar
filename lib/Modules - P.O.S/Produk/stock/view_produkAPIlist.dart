import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';

import '../../../Config/config.dart';
import 'controller_basemenustock.dart';

class ProdukAPIList extends GetView<BasemenuStockController> {
  const ProdukAPIList({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPenerimaanController>();
    return Column(
      children: [
        Obx(() {
          return con.isLoading.value == true
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: Padding(
                    padding: AppPading.customListPadding(bottomPadding: 90),
                    child: ListView.builder(
                        itemCount: con.produkAPI.length,
                        itemBuilder: (contex, index) {
                          var produk = con.produkAPI;
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    // Tap area
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // controller
                                          //     .addKeranjang(produk[index]);
                                          controller.popaddqty(produk[index]);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(produk[index].name!,
                                                style: AppFont.regular_bold()),
                                            Text(produk[index].group!),
                                            Text(
                                              'Rp ${NumberFormat('#,###').format(produk[index].fund!)}',
                                              style: AppFont.regular_bold(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Right section (stock)
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }),
                  ),
                );
        })
      ],
    );
  }
}
