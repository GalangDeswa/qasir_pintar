import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Laporan/Laporan%20Kasir/controller_laporankasir.dart';

class LaporanKasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LaporanKasirController());
  }
}
