import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/controller_kategoripelanggan.dart';

class KategoriPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KategoriPelangganController());
  }
}
