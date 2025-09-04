import 'package:get/get.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20Pelanggan/controller_pelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/controller_user.dart';
import 'package:qasir_pintar/Services/Handler.dart';

import '../../Controllers/printerController.dart';
import '../Kasir - Pembayaran/controller_pembayaran.dart';
import '../Produk/Paket produk/add/controller_addpaketproduk.dart';
import '../pengaturan/controller_pengaturan.dart';

class BasemenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BasemenuController());
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
    Get.lazyPut<CentralKategoriProdukController>(
        () => CentralKategoriProdukController(),
        fenix: true);
    Get.lazyPut<CentralPajakController>(() => CentralPajakController(),
        fenix: true);
    Get.lazyPut<CentralUkuranProdukController>(
        () => CentralUkuranProdukController(),
        fenix: true);
    Get.lazyPut<CentralPromoController>(() => CentralPromoController(),
        fenix: true);
    Get.lazyPut<CentralPelangganController>(() => CentralPelangganController(),
        fenix: true);
    Get.lazyPut<CentralHistoryController>(() => CentralHistoryController(),
        fenix: true);
    Get.lazyPut<CentralPenerimaanController>(
        () => CentralPenerimaanController(),
        fenix: true);

    Get.lazyPut<TambahPaketProdukController>(
        () => TambahPaketProdukController(),
        fenix: true);

    Get.lazyPut<PengaturanController>(() => PengaturanController());
    Get.lazyPut<UserController>(() => UserController());
    Get.put(API(), permanent: true);

    // Get.lazyPut<CentralProdukController>(() => CentralProdukController(),
    //     fenix: true);
    //
    // Get.put(CentralPaketController());
    // Get.put(CentralSupplierController());
    // Get.put(CentralPelangganController());
    // Get.lazyPut<KasirController>(() => KasirController(), fenix: true);
    // Get.put(BasemenuController());
    //
    // Get.lazyPut<PengaturanController>(() => PengaturanController());
    // Get.lazyPut<UserController>(() => UserController());
  }
}
