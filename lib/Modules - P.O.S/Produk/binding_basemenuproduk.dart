import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/add/controller_addproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/controller_basemenuproduk.dart';

import 'Data produk/edit/controller_editisiproduk.dart';
import 'Kategori/add/controller_tambahkategori.dart';

class BasemenuProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseMenuProdukController());
    Get.lazyPut<TambahProdukController>(() => TambahProdukController(),
        fenix: true);
    Get.lazyPut<EditIsiProdukController>(() => EditIsiProdukController(),
        fenix: true);

    // Get.lazyPut<KasirController>(() => KasirController());
    // Get.lazyPut<PengaturanController>(() => PengaturanController());
    // Get.lazyPut<UserController>(() => UserController());
  }
}
