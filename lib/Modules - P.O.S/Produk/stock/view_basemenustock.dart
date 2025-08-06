import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/controller_basemenustock.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/view_listpenerimaan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/view_stocklist.dart';

import '../../../Config/config.dart';
import '../../../Middleware/customPageRole.dart';
import '../../../Widget/widget.dart';
import '../Paket produk/view_paketproduk.dart';

class BasemenuStock extends GetView<BasemenuStockController> {
  const BasemenuStock({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRole(
      allowedRoles: ['ADMIN', 'MANAGER'],
      child: DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Builder(builder: (context) {
            return Scaffold(
              floatingActionButton: ListenableBuilder(
                listenable: tabController,
                builder: (context, _) {
                  return tabController.index == 0
                      ? customFloat(
                          onPressed: () {
                            Get.toNamed('/penerimaan_produk');
                          },
                        )
                      : SizedBox.shrink();
                },
              ),
              appBar: AppbarCustom(
                title: 'Inventori',
                NeedBottom: true,
                BottomWidget: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, AppColor.primary],
                      begin: Alignment.topCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  labelColor: AppColor.secondary,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Container(
                        width: context.res_width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Penerimaan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: context.res_width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Stock',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: AppPading.defaultBodyPadding(),
                child: TabBarView(children: [
                  Listpenerimaan(),
                  StockList(),
                ]),
              ),
            );
          });
        }),
      ),
    );
  }
}
