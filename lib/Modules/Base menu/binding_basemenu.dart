import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20Pelanggan/controller_pelanggan.dart';
import 'package:qasir_pintar/Modules/Users/controller_user.dart';

import '../pengaturan/controller_pengaturan.dart';

class BasemenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CentralProdukController());
    Get.lazyPut<BasemenuController>(() => BasemenuController(), fenix: true);
    Get.lazyPut<KasirController>(() => KasirController(), fenix: true);
    Get.lazyPut<PengaturanController>(() => PengaturanController());
    Get.lazyPut<UserController>(() => UserController());
  }
}
