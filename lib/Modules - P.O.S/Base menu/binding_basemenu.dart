import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20Pelanggan/controller_pelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/controller_user.dart';

import '../pengaturan/controller_pengaturan.dart';

class BasemenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CentralProdukController());
    Get.put(CentralPaketController());
    Get.put(CentralSupplierController());
    Get.put(CentralPelangganController());
    //Get.put(CentralPelangganController());
    //Get.lazyPut<CentralPelangganController>(() => CentralPelangganController());
    // Get.lazyPut<BasemenuController>(() => BasemenuController(), fenix: true);
    // Get.lazyPut<KasirController>(() => KasirController(), fenix: true);
    Get.put(BasemenuController());
    Get.put(KasirController());
    Get.lazyPut<PengaturanController>(() => PengaturanController());
    Get.lazyPut<UserController>(() => UserController());
  }
}
