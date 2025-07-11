import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Pembayaran/controller_pembayaran.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Rincian%20Pembayaran/component_Uppermenu_rincian.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Rincian%20Pembayaran/component_bottommenu_rincian.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Rincian%20Pembayaran/component_metodebayar.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir/controller_kasir.dart';

import 'package:qasir_pintar/Widget/widget.dart';

class RincianPembayaran extends GetView<KasirController> {
  const RincianPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Rincian Pembayaran',
        NeedBottom: false,
      ),
      body: Column(
        children: [
          UppermenuRincian(),
          Expanded(child: MetodeBayar()),
          BottommenuRincian(),
        ],
      ),
    );
  }
}
