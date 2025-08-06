import 'package:get/get.dart';

import 'Controllers/CentralController.dart';
import 'Controllers/printerController.dart';
import 'Middleware/Navigation.dart';
import 'Modules - P.O.S/Base menu/controller_basemenu.dart';
import 'Modules - P.O.S/Kasir/controller_kasir.dart';
import 'Modules - P.O.S/Users/controller_user.dart';
import 'Modules - P.O.S/pengaturan/controller_pengaturan.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    print(' <-- Initial binding -->');

    //Get.put(PrintController(), permanent: true);
    Get.lazyPut<PrintController>(() => PrintController(), fenix: true);
    // Get.put(CentralProdukController());
    Get.lazyPut<CentralProdukController>(() => CentralProdukController(),
        fenix: true);
    //Get.put(CentralPaketController());
    Get.lazyPut<CentralPaketController>(() => CentralPaketController(),
        fenix: true);
    //Get.put(CentralSupplierController());
    Get.lazyPut<CentralSupplierController>(() => CentralSupplierController(),
        fenix: true);
    //Get.put(CentralPelangganController());
    Get.lazyPut<CentralPelangganController>(() => CentralPelangganController(),
        fenix: true);
    //Get.put(CentralKaryawanController());
    Get.lazyPut<CentralKaryawanController>(() => CentralKaryawanController(),
        fenix: true);
    //Get.put(CentralBebanController());
    Get.lazyPut<CentralBebanController>(() => CentralBebanController(),
        fenix: true);
    //Get.put(KasirController());
    Get.lazyPut<KasirController>(() => KasirController(), fenix: true);
    // Get.put(BasemenuController());

    Get.lazyPut<PengaturanController>(() => PengaturanController());
    Get.lazyPut<UserController>(() => UserController());
    //Get.put(NavigationService(), permanent: true);
  }
}
