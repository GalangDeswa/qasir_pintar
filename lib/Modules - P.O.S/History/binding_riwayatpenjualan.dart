import 'package:get/get.dart';

import 'controller_riwayatpenjualan.dart';

class HistoryPenjualanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HistoryPenjualanController());
  }
}
