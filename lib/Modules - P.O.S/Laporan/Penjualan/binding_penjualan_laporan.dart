import 'package:get/get.dart';

import 'package:qasir_pintar/Modules%20-%20P.O.S/Laporan/Penjualan/controller_penjualan_laporan.dart';

class PenjualanLaporanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PenjualanLaporanController());
  }
}
