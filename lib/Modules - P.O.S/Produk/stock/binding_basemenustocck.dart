import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/controller_basemenustock.dart';

class BasemenuStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BasemenuStockController());
  }
}
