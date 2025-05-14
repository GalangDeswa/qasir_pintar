import 'package:get/get.dart';

import 'controller_detailpaketproduk.dart';

class DetailPaketProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailPaketProdukController());
  }
}
