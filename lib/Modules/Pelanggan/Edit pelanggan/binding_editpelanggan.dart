import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Edit%20pelanggan/controller_editpelanggan.dart';

class EditPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditPelangganController());
  }
}
