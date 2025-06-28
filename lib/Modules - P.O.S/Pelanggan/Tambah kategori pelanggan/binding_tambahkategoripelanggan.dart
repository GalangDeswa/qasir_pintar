import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Tambah%20kategori%20pelanggan/controller_tambahkategoripelanggan.dart';

class TambahKategoriPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahKategoriPelangganController());
  }
}
