import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Detail%20Pelanggan/controller_detailpelanggan.dart';

class DetailPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailPelangganController());
  }
}
