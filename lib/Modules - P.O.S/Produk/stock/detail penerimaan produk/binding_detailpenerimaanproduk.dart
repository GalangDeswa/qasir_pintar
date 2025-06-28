import 'package:get/get.dart';

import 'controller_detailpenerimaanproduk.dart';

class DetailPenerimaanProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailPenerimaanProdukController());
  }
}
