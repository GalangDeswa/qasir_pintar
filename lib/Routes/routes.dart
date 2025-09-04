import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:qasir_pintar/Modules - P.O.S/Auth/Register/view_registerlokasi.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/binding_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/view_basemenu.dart';
import 'package:qasir_pintar/Modules - P.O.S/History/binding_riwayatpenjualan.dart';
import 'package:qasir_pintar/Modules - P.O.S/History/detail/view_detailriwayatpenjualan.dart';
import 'package:qasir_pintar/Modules - P.O.S/History/view_riwayatpenjualan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Home/binding_home.dart';
import 'package:qasir_pintar/Modules - P.O.S/Home/view_home.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/add/binding_tambahkaryawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/add/view_tambahkaryawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/binding_karyawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/edit/binding_editkaryawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/edit/view_editkaryawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/view_karyawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Pembayaran/binding_pembayaran.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Pembayaran/view_pembayaran.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Rincian%20Pembayaran/binding_rincianpembayaran.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir%20-%20Rincian%20Pembayaran/view_rincianpembayaran.dart';

import 'package:qasir_pintar/Modules - P.O.S/Laporan/Ringkasan%20penjualan/view_ringkasanpenjualan.dart';

import 'package:qasir_pintar/Modules - P.O.S/OTP/binding_otp.dart';
import 'package:qasir_pintar/Modules - P.O.S/OTP/view_otp.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Detail%20Pelanggan/binding_detailpelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Detail%20Pelanggan/view_detailpelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Edit%20kategori%20pelanggan/binding_editkategoripelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Edit%20kategori%20pelanggan/view_editkategoripelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Edit%20pelanggan/binding_editpelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Edit%20pelanggan/view_editpelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20Pelanggan/binding_pelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20kategori%20pelanggan/binding_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20kategori%20pelanggan/view_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Tambah%20Pelanggan/binding_tambahpelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Tambah%20kategori%20pelanggan/binding_tambahkategoripelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/Tambah%20kategori%20pelanggan/view_tambahkategoripelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/basemenu_pelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/binding_basemenuPelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/add/binding_addproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/edit/binding_editisiproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/edit/view_editisiproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Detail%20data%20produk/binding_isiporduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Detail%20data%20produk/view_isiproduk.dart';

import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/add/binding_tambahkategori.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/add/view_tambahkategori.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/edit/binding_editsubkategoriproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/edit/view_editsubkategoriproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Paket%20produk/binding_detailisipaket.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Paket%20produk/edit/binding_editpaketproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Paket%20produk/edit/view_editpaketproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/add/binding_tambahproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/add/view_tambahproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/add/view_tambahprodukv2.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/edit/biding_editkategoriproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/edit/view_editkategoriproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/binding_basemenustocck.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/detail%20penerimaan%20produk/view_detailpenerimaanproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/detail%20stock/binding_detailstock.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/detail%20stock/view_detailstock.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/penerimaan%20produk/binding_penerimaan_produk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/view_basemenuproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/add/binding_tambahpromo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/add/view_tambahpromo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/binding_detailpromo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/binding_promo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/edit/binding_editpormo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/edit/view_editpromo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/view_detailpromo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Splash/view_splash.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/Edit%20supplier/binding_editsupplier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/Edit%20supplier/view_editsupllier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/Tambah%20supplier/binding_tambahsupplier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/Tambah%20supplier/view_tambahsupplier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/binding_supllier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/view_supplier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Toko/Setup/binding_setuptoko.dart';
import 'package:qasir_pintar/Modules - P.O.S/Toko/Setup/view_setupbarang.dart';
import 'package:qasir_pintar/Modules - P.O.S/Toko/Setup/view_setuptoko.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/binding_updateUser.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/binding_user.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/view_updateuser.dart';
import 'package:qasir_pintar/Modules - P.O.S/pengaturan/binding_pengaturan.dart';
import 'package:qasir_pintar/Modules - P.O.S/pengaturan/view_pengaturan.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Base%20Menu/view_basemenu_distributor.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Produk/view_produk_list_distributor.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/Detail%20beban/binding_detail_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/Detail%20beban/view_detail_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/binding_basemenu_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/edit/binding_edit_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/edit/view_edit_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/kategori%20add/view_tambah_kategori_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/view_basemenu_beban.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir/binding_kasir.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Laporan/Penjualan/binding_penjualan_laporan.dart';

import '../Middleware/RoleMiddleware.dart';
import '../Modules - Distributor/Base Menu/binding_basemenu_distributor.dart';
import '../Modules - Distributor/Produk/binding_produk_list_distributor.dart';
import '../Modules - P.O.S/Auth/Login form/binding_loginform.dart';
import '../Modules - P.O.S/Auth/Login form/view_loginform.dart';
import '../Modules - P.O.S/Auth/Login main/binding_login.dart';
import '../Modules - P.O.S/Auth/Login main/view_login.dart';
import '../Modules - P.O.S/Auth/Register/binding_register.dart';
import '../Modules - P.O.S/Auth/Register/view_register.dart';
import '../Modules - P.O.S/Auth/login karyawan pin/binding_loginpin.dart';
import '../Modules - P.O.S/Auth/login karyawan pin/view_loginpin.dart';
import '../Modules - P.O.S/Beban/add/binding_tambah_beban.dart';
import '../Modules - P.O.S/Beban/add/view_tambah_beban.dart';
import '../Modules - P.O.S/Beban/kategori add/binding_tambah_kategori_beban.dart';
import '../Modules - P.O.S/Beban/kategori edit/binding_kategori_edit.dart';
import '../Modules - P.O.S/Beban/kategori edit/view_kategori_edit.dart';
import '../Modules - P.O.S/History/detail/binding_detailriwayatpenjualan.dart';
import '../Modules - P.O.S/Laporan/Beban/binding_beban_laporan.dart';
import '../Modules - P.O.S/Laporan/Beban/view_beban_laporan.dart';

import '../Modules - P.O.S/Laporan/Penjualan/view_penjualan_laporan.dart';
import '../Modules - P.O.S/Laporan/Reversal/binding_reversal_laporan.dart';
import '../Modules - P.O.S/Laporan/Reversal/view_reversal_laporan.dart';
import '../Modules - P.O.S/Laporan/Ringkasan penjualan/binding_ringkasanpenjualan.dart';

import '../Modules - P.O.S/Pelanggan/List Pelanggan/view_pelanggan.dart';
import '../Modules - P.O.S/Pelanggan/Tambah Pelanggan/view_tambahpelanggan.dart';
import '../Modules - P.O.S/Produk/Data produk/add/view_adddetailproduk.dart';
import '../Modules - P.O.S/Produk/Data produk/add/view_addproduk.dart';
import '../Modules - P.O.S/Produk/Data produk/edit/binding_editdetailproduk.dart';
import '../Modules - P.O.S/Produk/Data produk/edit/view_editdetailproduk.dart';
import '../Modules - P.O.S/Produk/Paket produk/add/binding_paketproduk.dart';
import '../Modules - P.O.S/Produk/Paket produk/add/view_addpaketproduk.dart';
import '../Modules - P.O.S/Produk/Paket produk/view_detailpaket produk.dart';
import '../Modules - P.O.S/Produk/binding_basemenuproduk.dart';
import '../Modules - P.O.S/Produk/stock/detail penerimaan produk/binding_detailpenerimaanproduk.dart';
import '../Modules - P.O.S/Produk/stock/penerimaan produk/view_penerimaan_produk.dart';
import '../Modules - P.O.S/Produk/stock/view_basemenustock.dart';
import '../Modules - P.O.S/Produk/stock/view_rincian_pembayaran_pemesanan.dart';
import '../Modules - P.O.S/Promo/view_promo.dart';
import '../Modules - P.O.S/Splash/binding_splash.dart';
import '../Modules - P.O.S/Splash/view_splashintro.dart';
import '../Modules - P.O.S/Users/view_user.dart';

final List<GetPage<dynamic>> route = [
  // ======================== CORE & AUTHENTICATION ========================
  GetPage(name: "/splash", page: () => Splash(), binding: SplashBinding()),
  GetPage(name: "/intro", page: () => intro(), binding: SplashBinding()),
  GetPage(
      name: "/base_menu_distributor",
      page: () => BaseMenuDistributor(),
      binding: BindingBasemenuDistributorBinding()),
  GetPage(
      name: "/produk_list_distributor",
      page: () => ProdukListDistributor(),
      binding: ProdukListDistributorBinding()),

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
    binding: BasemenuProdukBinding(),
    // middlewares: [
    //   AuthMiddleware(allowedRoles: ['ADMIN', 'MANAGER']),
    // ],
  ),
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
      name: "/tambahprodukv3final",
      page: () => TambahProdukv3Final(),
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
      binding: KasirBinding()),

  GetPage(
      name: "/rincianpembayaranpemesanan",
      page: () => RincianPembayaranPemesanan(),
      binding: BasemenuStockBinding()),

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
      name: "/reversal_laporan",
      page: () => ReversalLaporan(),
      binding: ReversalLaporanBinding()),
  GetPage(
      name: "/penjualan_laporan",
      page: () => PenjualanLaporan(),
      binding: PenjualanLaporanBinding()),
  GetPage(
      name: "/ringkasanpenjualan",
      page: () => RingkasanPenjualan(),
      binding: RingkasanPenjualanBinding()),
  GetPage(
      name: "/beban_laporan",
      page: () => BebanLaporan(),
      binding: BebanLaporanBinding()),

  // ======================== USER MANAGEMENT ========================
  GetPage(name: "/user", page: () => User(), binding: UserBinding()),
  GetPage(
      name: "/updateuser",
      page: () => UpdateUser(),
      binding: UpdateUserBinding()),
  GetPage(name: "/home", page: () => HomeScreen(), binding: HomeBinding()),

  GetPage(
      name: "/basemenu_beban",
      page: () => BasemenuBeban(),
      binding: BasemenuBebanBinding()),
  GetPage(
      name: "/detail_beban",
      page: () => DetailBeban(),
      binding: DetailBebanBinding()),

  GetPage(
      name: "/tambah_beban",
      page: () => TambahBeban(),
      binding: TambahBebanBinding()),

  GetPage(
      name: "/edit_beban",
      page: () => EditBeban(),
      binding: EditBebanBinding()),

  GetPage(
      name: "/edit_kategori_beban",
      page: () => EditKategoriBeban(),
      binding: EditKategoriBebanBinding()),

  GetPage(
      name: "/tambah_kategori_beban",
      page: () => TambahKategoriBeban(),
      binding: TambahKategoriBebanBinding()),
];
