import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Produk/controller_produk_list_distributor.dart';

class ProdukListDistributorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProdukListDistributorController());
  }
}
