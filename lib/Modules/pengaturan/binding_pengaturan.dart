import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/pengaturan/controller_pengaturan.dart';

class PengaturanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PengaturanController());
  }
}
