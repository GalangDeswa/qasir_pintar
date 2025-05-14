import 'package:get/get.dart';

import 'controller_editdetailproduk.dart';

class EditDetailProdukBinding extends Bindings {
  @override
  void dependencies() {
  Get.put(EditDetailProdukController());
  }
}