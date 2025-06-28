import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/edit/controller_editkategoriproduk.dart';

class EditKategoriProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditKategoriProdukController());
  }
}
