import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Produk/Produk/add/controller_tambahproduk.dart';

class ProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProdukController());
  }
}
