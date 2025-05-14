import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/History/detail/controller_detailriwayatpenjualan.dart';

class DetailHistoryPenjualanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailHistoryPenjualanController());
  }
}
