import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Kasir/controller_kasir.dart';

class KasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KasirController());
  }
}
