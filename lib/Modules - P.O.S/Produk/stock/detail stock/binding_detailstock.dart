import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/detail%20stock/controller_detailstock.dart';

class DetailStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailStockController());
  }
}
