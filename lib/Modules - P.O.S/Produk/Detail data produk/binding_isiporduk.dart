import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Detail%20data%20produk/controller_isiproduk.dart';

class IsiProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IsiProdukController());
  }
}
