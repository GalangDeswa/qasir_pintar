import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Base%20Menu/component_drawer_distributor.dart';

import '../../Config/config.dart';
import '../../Modules - P.O.S/Base menu/component_drawer.dart';
import '../../Widget/widget.dart';
import 'controller_basemenu_distributor.dart';

class BaseMenuDistributor extends GetView<BaseMenuDistributorController> {
  const BaseMenuDistributor({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          appBar: AppbarCustomMain(
              title: controller.title.elementAt(controller.index.value)),
          drawerEnableOpenDragGesture: false,
          drawer: DrawerBaseDistributor(),

          // floatingActionButton: Container(
          //     padding: EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //         color: AppColor.primary,
          //         borderRadius: BorderRadius.circular(20)),
          //     child: Icon(
          //       Icons.attach_money,
          //       color: Colors.white,
          //     )),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
              icons: controller.icons,
              activeColor: Colors.white,
              splashColor: AppColor.accent,
              backgroundColor: AppColor.primary,
              activeIndex: controller.index.value,
              gapLocation: GapLocation.none,
              notchSmoothness: NotchSmoothness.verySmoothEdge,
              // leftCornerRadius: 30,
              // rightCornerRadius: 30,
              onTap: (index) {
                controller.index.value = index;
              }),
          body: Obx(() {
            return controller.views.elementAt(controller.index.value);
          }),
          //other params
        );
      }),
    );
  }
}
