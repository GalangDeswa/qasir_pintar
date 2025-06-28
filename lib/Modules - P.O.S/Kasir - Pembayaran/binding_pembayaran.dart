import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Pembayaran/controller_pembayaran.dart';

class PembayaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PembayaranController());
  }
}
