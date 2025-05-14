import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20Pelanggan/controller_pelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/controller_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Tambah%20Pelanggan/controller_tambahpelanggan.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/add/controller_addproduk.dart';

class BasemenuPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PelangganController(), fenix: true);
    Get.lazyPut(() => TambahPelangganController(), fenix: true);
    Get.lazyPut(() => KategoriPelangganController(), fenix: true);
  }
}
