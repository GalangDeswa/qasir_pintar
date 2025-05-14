import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Tambah%20kategori%20pelanggan/controller_tambahkategoripelanggan.dart';

import 'controller_tambahpelanggan.dart';

class TambahPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahPelangganController());
    Get.put(TambahKategoriPelangganController());
  }
}
