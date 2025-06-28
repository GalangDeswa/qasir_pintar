import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/pengaturan/controller_pengaturan.dart';

class PengaturanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PengaturanController());
  }
}
