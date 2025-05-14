import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/add/controller_addproduk.dart';

import '../../Kategori/add/controller_tambahkategori.dart';

class TambahProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahProdukController());
    // Get.lazyPut(() => TambahProdukController(), fenix: true);
    // Get.lazyPut(() => TambahSubKategoriController(), fenix: true);
    // // Verify instance identity in console:
    // print(Get.find<TambahProdukController>().hashCode);
    // print(Get.find<TambahSubKategoriController>().hashCode);
  }
}
