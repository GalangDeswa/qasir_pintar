import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/add/controller_tambahproduk.dart';

class ProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProdukController());
  }
}
