import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/add/controller_tambahkaryawan.dart';

class TambahKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahKaryawanController());
  }
}
