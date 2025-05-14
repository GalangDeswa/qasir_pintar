import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Produk/Detail%20data%20produk/controller_isiproduk.dart';

class IsiProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IsiProdukController());
  }
}
