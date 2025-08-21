import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import 'component_drawer.dart';

class Basemenu extends GetView<BasemenuController> {
  const Basemenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          appBar: AppbarCustomMain(
              title: controller.title.elementAt(controller.index.value)),
          drawerEnableOpenDragGesture: false,
          drawer: DrawerBase(),

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
                // if (index == 1) {
                //   Get.find<KasirController>().getKaryawan();
                // }
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
