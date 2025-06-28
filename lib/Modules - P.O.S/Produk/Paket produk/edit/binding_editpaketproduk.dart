import 'package:get/get.dart';

import 'controller_editpaketproduk.dart';

class EditPaketProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditPaketProdukController());
  }
}
