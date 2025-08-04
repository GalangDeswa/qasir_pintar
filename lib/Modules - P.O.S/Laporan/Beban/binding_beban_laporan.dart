import 'package:get/get.dart';

import 'controller_beban_laporan.dart';

class BebanLaporanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BebanLaporanController());
  }
}
