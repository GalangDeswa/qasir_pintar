import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Laporan/Ringkasan%20penjualan/controller_ringkasanpenjualan.dart';

class RingkasanPenjualanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RingkasanPenjualanController());
  }
}
