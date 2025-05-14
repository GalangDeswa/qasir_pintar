import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Rincian%20Pembayaran/controller_rincianpembayaran.dart';

class RincianPembayaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RincianPembayaranController());
  }
}
