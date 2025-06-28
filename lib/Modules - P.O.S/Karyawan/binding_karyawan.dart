import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/controller_karyawan.dart';

class KaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KaryawanController());
  }
}
