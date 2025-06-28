import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Paket%20produk/add/controller_addpaketproduk.dart';

class TambahPaketProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahPaketProdukController());
  }
}
