import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/kategori%20add/controller_tambah_kategori_beban.dart';

class TambahKategoriBebanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahKategoriBebanController());
  }
}
