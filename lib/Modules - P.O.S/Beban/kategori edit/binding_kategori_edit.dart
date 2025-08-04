import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/kategori%20edit/controller_kategori_edit.dart';

class EditKategoriBebanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditKategoriBebanController());
  }
}
