import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Laporan/Laporan%20menu/controller_laporanmenu.dart';

class LaporanMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LaporanMenuController());
  }
}
