import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/edit/controller_editkaryawan.dart';

class EditKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditKaryawanController());
  }
}
