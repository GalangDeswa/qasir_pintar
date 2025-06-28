import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Edit%20kategori%20pelanggan/controller_editkategoripelanggan.dart';

class EditKategoriPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditKategoriPelangganController());
  }
}
