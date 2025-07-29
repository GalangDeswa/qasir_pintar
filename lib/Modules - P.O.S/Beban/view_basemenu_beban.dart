import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/controller_basemenu_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/view_list_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/view_list_kategori_beban.dart';

import '../../Config/config.dart';
import '../../Widget/widget.dart';

class BasemenuBeban extends GetView<BasemenuBebanController> {
  const BasemenuBeban({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                          Get.toNamed('/tambah_beban');
                        },
                      )
                    : customFloat(
                        onPressed: () {
                          Get.toNamed('/tambah_kategori_beban');
                        },
                      );
              },
            ),
            appBar: AppbarCustom(
              title: 'Beban',
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
                          'Beban',
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
                          'Kategori',
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
                ListBeban(),
                ListKategoriBeban(),
              ]),
            ),
          );
        });
      }),
    );
  }
}
