import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Laporan/Kas%20kasir/controller_kaskasir.dart';

class KasKasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KasKasirController());
  }
}
