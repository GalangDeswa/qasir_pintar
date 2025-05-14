import 'package:get/get.dart';

import 'controller_penerimaan_produk.dart';

class PenerimaanProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PenerimaanProdukController());
  }
}
