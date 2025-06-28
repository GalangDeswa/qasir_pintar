import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/edit/controller_editsubkategoriproduk.dart';

class EditSubKategoriProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditSubKategoriProdukController());
  }
}
