import 'package:get/get.dart';

import 'controller_tambah_beban.dart';

class TambahBebanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahBebanController());
  }
}
