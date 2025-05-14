import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Produk/Kategori/add/controller_tambahkategori.dart';

class TambahSubKategoriBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahSubKategoriController());
  }
}
