import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Laporan/Laporan%20menu/controller_laporanmenu.dart';

class LaporanMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LaporanMenuController());
  }
}
