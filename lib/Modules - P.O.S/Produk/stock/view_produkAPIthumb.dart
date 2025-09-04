import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../Config/config.dart';
import '../../../Controllers/CentralController.dart';
import 'controller_basemenustock.dart';

class ProdukAPIThumb extends GetView<BasemenuStockController> {
  const ProdukAPIThumb({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CentralPenerimaanController>();
    var imgLink = 'https://adminmarket.tubinnews.com/uploads/';
    return Padding(
      padding: AppPading.defaultBodyPadding(),
      child: Container(
        // color: Colors.red,
        child: Obx(() {
          return con.isLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: AppPading.customListPadding(bottomPadding: 70),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisExtent: context.res_height / 4.0,
                          maxCrossAxisExtent: context.res_width / 2.0,
                          childAspectRatio: 1 / 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemCount: con.produkAPI.length,
                      itemBuilder: (BuildContext context, index) {
                        var produk = con.produkAPI;

                        return GestureDetector(
                          onTap: () {
                            //controller.addKeranjang(produk[index]);
                            controller.popaddqty(produk[index]);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: produk[index].picture != '' &&
                                            produk[index].picture != null
                                        ? Image.network(
                                            imgLink + produk[index].picture!,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                // ✅
                                                return child;
                                              }
                                              // ⏳
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                                        AppString.defaultImg),
                                          )
                                        : Image.asset(AppString.defaultImg)),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    width: context.res_width,
                                    //height: context.res_height * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          produk[index].name!,
                                          style: AppFont.regular_bold(),
                                        ),
                                        Text(produk[index].group!),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          'Rp ${NumberFormat('#,###').format(
                                            produk[index].fund!,
                                          )}',
                                          style: AppFont.regular_bold(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
        }),
      ),
    );
  }
}
