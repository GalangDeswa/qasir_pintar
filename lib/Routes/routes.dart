import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:qasir_pintar/Modules/Auth/Register/view_registerlokasi.dart';
import 'package:qasir_pintar/Modules/Base%20menu/binding_basemenu.dart';
import 'package:qasir_pintar/Modules/Base%20menu/view_basemenu.dart';
import 'package:qasir_pintar/Modules/History/binding_riwayatpenjualan.dart';
import 'package:qasir_pintar/Modules/History/detail/view_detailriwayatpenjualan.dart';
import 'package:qasir_pintar/Modules/History/view_riwayatpenjualan.dart';
import 'package:qasir_pintar/Modules/Home/binding_home.dart';
import 'package:qasir_pintar/Modules/Home/view_home.dart';
import 'package:qasir_pintar/Modules/Karyawan/add/binding_tambahkaryawan.dart';
import 'package:qasir_pintar/Modules/Karyawan/add/view_tambahkaryawan.dart';
import 'package:qasir_pintar/Modules/Karyawan/binding_karyawan.dart';
import 'package:qasir_pintar/Modules/Karyawan/edit/binding_editkaryawan.dart';
import 'package:qasir_pintar/Modules/Karyawan/edit/view_editkaryawan.dart';
import 'package:qasir_pintar/Modules/Karyawan/view_karyawan.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Pembayaran/binding_pembayaran.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Pembayaran/view_pembayaran.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Rincian%20Pembayaran/binding_rincianpembayaran.dart';
import 'package:qasir_pintar/Modules/Kasir%20-%20Rincian%20Pembayaran/view_rincianpembayaran.dart';
import 'package:qasir_pintar/Modules/Laporan/Kas%20kasir/binding_kaskasir.dart';
import 'package:qasir_pintar/Modules/Laporan/Kas%20kasir/view_kaskasir.dart';
import 'package:qasir_pintar/Modules/Laporan/Laporan%20Kasir/view_laporankasir.dart';
import 'package:qasir_pintar/Modules/Laporan/Ringkasan%20penjualan/view_ringkasanpenjualan.dart';

import 'package:qasir_pintar/Modules/OTP/binding_otp.dart';
import 'package:qasir_pintar/Modules/OTP/view_otp.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Detail%20Pelanggan/binding_detailpelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Detail%20Pelanggan/view_detailpelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Edit%20kategori%20pelanggan/binding_editkategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Edit%20kategori%20pelanggan/view_editkategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Edit%20pelanggan/binding_editpelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Edit%20pelanggan/view_editpelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20Pelanggan/binding_pelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/binding_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/view_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Tambah%20Pelanggan/binding_tambahpelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Tambah%20kategori%20pelanggan/binding_tambahkategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/Tambah%20kategori%20pelanggan/view_tambahkategoripelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/basemenu_pelanggan.dart';
import 'package:qasir_pintar/Modules/Pelanggan/binding_basemenuPelanggan.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/add/binding_addproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/edit/binding_editisiproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/edit/view_editisiproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Detail%20data%20produk/binding_isiporduk.dart';
import 'package:qasir_pintar/Modules/Produk/Detail%20data%20produk/view_isiproduk.dart';

import 'package:qasir_pintar/Modules/Produk/Kategori/add/binding_tambahkategori.dart';
import 'package:qasir_pintar/Modules/Produk/Kategori/add/view_tambahkategori.dart';
import 'package:qasir_pintar/Modules/Produk/Kategori/edit/binding_editsubkategoriproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Kategori/edit/view_editsubkategoriproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Paket%20produk/binding_detailisipaket.dart';
import 'package:qasir_pintar/Modules/Produk/Paket%20produk/edit/binding_editpaketproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Paket%20produk/edit/view_editpaketproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Produk/add/binding_tambahproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Produk/add/view_tambahproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Produk/add/view_tambahprodukv2.dart';
import 'package:qasir_pintar/Modules/Produk/Produk/edit/biding_editkategoriproduk.dart';
import 'package:qasir_pintar/Modules/Produk/Produk/edit/view_editkategoriproduk.dart';
import 'package:qasir_pintar/Modules/Produk/stock/binding_basemenustocck.dart';
import 'package:qasir_pintar/Modules/Produk/stock/detail%20penerimaan%20produk/view_detailpenerimaanproduk.dart';
import 'package:qasir_pintar/Modules/Produk/stock/detail%20stock/binding_detailstock.dart';
import 'package:qasir_pintar/Modules/Produk/stock/detail%20stock/view_detailstock.dart';
import 'package:qasir_pintar/Modules/Produk/stock/penerimaan%20produk/binding_penerimaan_produk.dart';
import 'package:qasir_pintar/Modules/Produk/view_basemenuproduk.dart';
import 'package:qasir_pintar/Modules/Promo/add/binding_tambahpromo.dart';
import 'package:qasir_pintar/Modules/Promo/add/view_tambahpromo.dart';
import 'package:qasir_pintar/Modules/Promo/binding_detailpromo.dart';
import 'package:qasir_pintar/Modules/Promo/binding_promo.dart';
import 'package:qasir_pintar/Modules/Promo/edit/binding_editpormo.dart';
import 'package:qasir_pintar/Modules/Promo/edit/view_editpromo.dart';
import 'package:qasir_pintar/Modules/Promo/view_detailpromo.dart';
import 'package:qasir_pintar/Modules/Splash/view_splash.dart';
import 'package:qasir_pintar/Modules/Supplier/Edit%20supplier/binding_editsupplier.dart';
import 'package:qasir_pintar/Modules/Supplier/Edit%20supplier/view_editsupllier.dart';
import 'package:qasir_pintar/Modules/Supplier/Tambah%20supplier/binding_tambahsupplier.dart';
import 'package:qasir_pintar/Modules/Supplier/Tambah%20supplier/view_tambahsupplier.dart';
import 'package:qasir_pintar/Modules/Supplier/binding_supllier.dart';
import 'package:qasir_pintar/Modules/Supplier/view_supplier.dart';
import 'package:qasir_pintar/Modules/Toko/Setup/binding_setuptoko.dart';
import 'package:qasir_pintar/Modules/Toko/Setup/view_setupbarang.dart';
import 'package:qasir_pintar/Modules/Toko/Setup/view_setuptoko.dart';
import 'package:qasir_pintar/Modules/Users/binding_updateUser.dart';
import 'package:qasir_pintar/Modules/Users/binding_user.dart';
import 'package:qasir_pintar/Modules/Users/view_updateuser.dart';
import 'package:qasir_pintar/Modules/pengaturan/binding_pengaturan.dart';
import 'package:qasir_pintar/Modules/pengaturan/view_pengaturan.dart';

import '../Modules/Auth/Login form/binding_loginform.dart';
import '../Modules/Auth/Login form/view_loginform.dart';
import '../Modules/Auth/Login main/binding_login.dart';
import '../Modules/Auth/Login main/view_login.dart';
import '../Modules/Auth/Register/binding_register.dart';
import '../Modules/Auth/Register/view_register.dart';
import '../Modules/Auth/login karyawan pin/binding_loginpin.dart';
import '../Modules/Auth/login karyawan pin/view_loginpin.dart';
import '../Modules/History/detail/binding_detailriwayatpenjualan.dart';
import '../Modules/Laporan/Laporan Kasir/binding_laporankasir.dart';
import '../Modules/Laporan/Laporan menu/binding_laporanmenu.dart';
import '../Modules/Laporan/Laporan menu/view_laporanmenu.dart';
import '../Modules/Laporan/Ringkasan penjualan/binding_ringkasanpenjualan.dart';

import '../Modules/Pelanggan/List Pelanggan/view_pelanggan.dart';
import '../Modules/Pelanggan/Tambah Pelanggan/view_tambahpelanggan.dart';
import '../Modules/Produk/Data produk/add/view_adddetailproduk.dart';
import '../Modules/Produk/Data produk/add/view_addproduk.dart';
import '../Modules/Produk/Data produk/edit/binding_editdetailproduk.dart';
import '../Modules/Produk/Data produk/edit/view_editdetailproduk.dart';
import '../Modules/Produk/Paket produk/add/binding_paketproduk.dart';
import '../Modules/Produk/Paket produk/add/view_addpaketproduk.dart';
import '../Modules/Produk/Paket produk/view_detailpaket produk.dart';
import '../Modules/Produk/binding_basemenuproduk.dart';
import '../Modules/Produk/stock/detail penerimaan produk/binding_detailpenerimaanproduk.dart';
import '../Modules/Produk/stock/penerimaan produk/view_penerimaan_produk.dart';
import '../Modules/Produk/stock/view_basemenustock.dart';
import '../Modules/Promo/view_promo.dart';
import '../Modules/Splash/binding_splash.dart';
import '../Modules/Splash/view_splashintro.dart';
import '../Modules/Users/view_user.dart';

final List<GetPage<dynamic>> route = [
  // ======================== CORE & AUTHENTICATION ========================
  GetPage(name: "/splash", page: () => Splash(), binding: SplashBinding()),
  GetPage(name: "/intro", page: () => intro(), binding: SplashBinding()),

  // Authentication
  GetPage(name: "/login", page: () => Login(), binding: LoginBinding()),
  GetPage(
      name: "/loginform", page: () => LoginForm(), binding: LoginFormBinding()),
  GetPage(
      name: "/loginpin", page: () => LoginPin(), binding: LoginPinBinding()),
  GetPage(
      name: "/register", page: () => Register(), binding: RegisterBinding()),
  GetPage(
      name: "/registerlokasi",
      page: () => RegisterLokasi(),
      binding: RegisterBinding()),
  GetPage(name: "/otp", page: () => OTP(), binding: OTPBinding()),

  // ======================== MAIN NAVIGATION ========================

  GetPage(name: "/promo", page: () => Promo(), binding: PromoBinding()),
  GetPage(
      name: "/edit_promo",
      page: () => EditPromo(),
      binding: EditPromoBinding()),

  GetPage(
      name: "/detail_promo",
      page: () => DetailPromo(),
      binding: DetailPromoBinding()),
  GetPage(
      name: "/tambah_promo",
      page: () => TambahPromo(),
      binding: TambahPromoBinding()),
  GetPage(
      name: "/history",
      page: () => HistoryPenjualan(),
      binding: HistoryPenjualanBinding()),
  GetPage(
      name: "/detail_history",
      page: () => DetailHistoryPenjualan(),
      binding: DetailHistoryPenjualanBinding()),
  GetPage(
      name: "/basemenu", page: () => Basemenu(), binding: BasemenuBinding()),
  GetPage(
      name: "/basemenuproduk",
      page: () => BasemenuProduk(),
      binding: BasemenuProdukBinding()),
  GetPage(
      name: "/basemenupelanggan",
      page: () => BasemenuPelanggan(),
      binding: BasemenuPelangganBinding()),
  GetPage(
      name: "/basemenu_stock",
      page: () => BasemenuStock(),
      binding: BasemenuStockBinding()),

  // ======================== STORE MANAGEMENT ========================
  GetPage(
      name: "/setuptoko", page: () => SetupToko(), binding: SetupTokoBinding()),
  GetPage(
      name: "/setupbarang",
      page: () => SetupBarang(),
      binding: SetupTokoBinding()),
  GetPage(
      name: "/pengaturan",
      page: () => Pengaturan(),
      binding: PengaturanBinding()),

  // ======================== PRODUCT MANAGEMENT ========================
  // Product Categories
  GetPage(
      name: "/tambahkategoriproduk",
      page: () => TambahProdukv2(),
      binding: ProdukBinding()),
  GetPage(
      name: "/tambahsubkategori",
      page: () => TambahSubKategori(),
      binding: TambahSubKategoriBinding()),
  GetPage(
      name: "/editkategoriproduk",
      page: () => EditKategoriProduk(),
      binding: EditKategoriProdukBinding()),
  GetPage(
      name: "/editsubkategoriproduk",
      page: () => EditSubKategoriProduk(),
      binding: EditSubKategoriProdukBinding()),

  // Product Data
  GetPage(
      name: "/tambahprodukv3",
      page: () => TambahProdukv3(),
      binding: TambahProdukBinding()),
  GetPage(
      name: "/tambahpajak",
      page: () => TambahPajakProduk(),
      binding: TambahProdukBinding()),

  GetPage(
      name: "/tambahukuran",
      page: () => TambahUkuranProduk(),
      binding: TambahProdukBinding()),

  GetPage(
      name: "/tambahprodukv3next",
      page: () => TambahProdukv3next(),
      binding: TambahProdukBinding()),
  GetPage(
      name: "/isiproduk",
      page: () => ViewIsiproduk(),
      binding: IsiProdukBinding()),
  GetPage(
      name: "/editisiproduk",
      page: () => EditIsiProduk(),
      binding: EditIsiProdukBinding()),

  GetPage(
      name: "/editpajak",
      page: () => EditPajakProduk(),
      binding: EditDetailProdukBinding()),
  GetPage(
      name: "/editukuran",
      page: () => EditUkuranProduk(),
      binding: EditDetailProdukBinding()),

  // Product Packages
  GetPage(
      name: "/detailpaketproduk",
      page: () => DetailPaketProduk(),
      binding: DetailPaketProdukBinding()),
  GetPage(
      name: "/editpaketproduk",
      page: () => EditPaketProduk(),
      binding: EditPaketProdukBinding()),
  GetPage(
      name: "/tambahpaketproduk",
      page: () => TambahPaketProduk(),
      binding: TambahPaketProdukBinding()),

  // Stock Management
  GetPage(
      name: "/penerimaan_produk",
      page: () => PenerimaanProduk(),
      binding: PenerimaanProdukBinding()),
  GetPage(
      name: "/detail_penerimaan_produk",
      page: () => DetailPenerimaanProduk(),
      binding: DetailPenerimaanProdukBinding()),

  GetPage(
      name: "/detail_stock",
      page: () => DetailStock(),
      binding: DetailStockBinding()),

  // ======================== SALES & PAYMENTS ========================
  GetPage(
      name: "/pembayaran",
      page: () => Pembayaran(),
      binding: PembayaranBinding()),
  GetPage(
      name: "/rincianpembayaran",
      page: () => RincianPembayaran(),
      binding: PembayaranBinding()),

  // ======================== CUSTOMER MANAGEMENT ========================
  GetPage(
      name: "/pelanggan", page: () => Pelanggan(), binding: PelangganBinding()),
  GetPage(
      name: "/tambahpelanggan",
      page: () => TambahPelanggan(),
      binding: TambahPelangganBinding()),
  GetPage(
      name: "/detailpelanggan",
      page: () => DetailPelanggan(),
      binding: DetailPelangganBinding()),
  GetPage(
      name: "/editpelanggan",
      page: () => EditPelanggan(),
      binding: EditPelangganBinding()),

  // Customer Categories
  GetPage(
      name: "/kategoripelanggan",
      page: () => KategoriPelanggan(),
      binding: KategoriPelangganBinding()),
  GetPage(
      name: "/tambahkategoripelanggan",
      page: () => TambahKategoriPelanggan(),
      binding: TambahKategoriPelangganBinding()),
  GetPage(
      name: "/editkategoripelanggan",
      page: () => EditKategoriPelanggan(),
      binding: EditKategoriPelangganBinding()),

  // ======================== SUPPLIER MANAGEMENT ========================
  GetPage(
      name: "/supplier", page: () => Supplier(), binding: SupplierBinding()),
  GetPage(
      name: "/tambahsupplier",
      page: () => TambahSupplier(),
      binding: TambahSupplierBinding()),
  GetPage(
      name: "/editsupplier",
      page: () => EditSupplier(),
      binding: EditSupplierBinding()),

  // ======================== EMPLOYEE MANAGEMENT ========================
  GetPage(
      name: "/karyawan", page: () => Karyawan(), binding: KaryawanBinding()),
  GetPage(
      name: "/tambahkaryawan",
      page: () => TambahKaryawan(),
      binding: TambahKaryawanBinding()),
  GetPage(
      name: "/editkaryawan",
      page: () => EditKaryawan(),
      binding: EditKaryawanBinding()),

  // ======================== REPORTS ========================
  GetPage(
      name: "/laporanmenu",
      page: () => LaporanMenu(),
      binding: LaporanMenuBinding()),
  GetPage(
      name: "/laporankasir",
      page: () => LaporanKasir(),
      binding: LaporanKasirBinding()),
  GetPage(
      name: "/ringkasanpenjualan",
      page: () => RingkasanPenjualan(),
      binding: RingkasanPenjualanBinding()),
  GetPage(
      name: "/kaskasir", page: () => KasKasir(), binding: KasKasirBinding()),

  // ======================== USER MANAGEMENT ========================
  GetPage(name: "/user", page: () => User(), binding: UserBinding()),
  GetPage(
      name: "/updateuser",
      page: () => UpdateUser(),
      binding: UpdateUserBinding()),
  GetPage(name: "/home", page: () => HomeScreen(), binding: HomeBinding()),
];
