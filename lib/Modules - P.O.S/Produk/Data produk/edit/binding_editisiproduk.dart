import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/edit/controller_editisiproduk.dart';

class EditIsiProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditIsiProdukController());
  }
}
