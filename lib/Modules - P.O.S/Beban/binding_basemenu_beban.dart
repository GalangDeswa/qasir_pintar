import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/add/controller_tambah_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/controller_basemenu_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/kategori%20add/controller_tambah_kategori_beban.dart';

class BasemenuBebanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BasemenuBebanController());
    // Get.put(TambahBebanController());
    // Get.put(TambahKategoriBebanController());
    Get.lazyPut<TambahBebanController>(() => TambahBebanController(),
        fenix: true);
    Get.lazyPut<TambahKategoriBebanController>(
        () => TambahKategoriBebanController(),
        fenix: true);
  }
}
