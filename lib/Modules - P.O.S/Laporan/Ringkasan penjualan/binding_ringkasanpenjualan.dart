import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Laporan/Ringkasan%20penjualan/controller_ringkasanpenjualan.dart';

class RingkasanPenjualanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RingkasanPenjualanController());
  }
}
