import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Kasir/component_bottommenu_kasir.dart';
import 'package:qasir_pintar/Modules/Kasir/component_meja_kasir.dart';
import 'package:qasir_pintar/Modules/Kasir/component_produklist.dart';
import 'package:qasir_pintar/Modules/Kasir/component_produkthumb_kasir.dart';
import 'package:qasir_pintar/Modules/Kasir/component_uppermenu_kasir.dart';
import 'package:qasir_pintar/Modules/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Widget/popscreen.dart';

import '../../Config/config.dart';
import '../Base menu/controller_basemenu.dart';

class Kasir extends GetView<KasirController> {
  const Kasir({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          controller.tampilan.value == 'meja'
              ? UpperMenuMeja()
              : UpperMenuKasir(),
          controller.tampilan.value == 'list'
              ? Expanded(child: ProdukListKasir())
              : controller.tampilan.value == 'meja'
                  ? Expanded(child: Meja())
                  : Expanded(child: ProdukThumb()),
          controller.tampilan == 'meja' ? BottomMenuMeja() : BottomMenuKasir(),
        ],
      );
    });
  }
}
