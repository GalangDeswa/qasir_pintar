import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Karyawan/controller_karyawan.dart';

class KaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KaryawanController());
  }
}
