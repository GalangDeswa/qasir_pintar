import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Laporan/Reversal/controller_reversal_laporan.dart';

class ReversalLaporanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReversalLaporanController());
  }
}
