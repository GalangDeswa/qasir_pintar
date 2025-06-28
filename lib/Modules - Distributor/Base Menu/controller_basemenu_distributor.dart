import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Home%20-%20distributor/view_home_distributor.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Produk/view_produk_list_distributor.dart';

import '../../Database/DB_helper.dart';
import '../../Modules - P.O.S/Home/view_home.dart';
import '../../Modules - P.O.S/Kasir/model_penjualan.dart';
import '../../Modules - P.O.S/Kasir/view_kasir.dart';
import '../../Modules - P.O.S/Produk/Data produk/model_produk.dart';
import '../../Modules - P.O.S/Produk/Kategori/model_subkategoriproduk.dart';
import '../../Modules - P.O.S/Produk/Produk/model_kategoriproduk.dart';
import '../../Modules - P.O.S/Users/model_user.dart';
import '../../Widget/popscreen.dart';

class BaseMenuDistributorController extends GetxController {
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('BASE MENU CON INIt--------------------------------->');
    uuid.value = await GetStorage().read('uuid');
    await checktour();
    await fetchUserLocal(uuid);
    await fetchKategoriProdukLocal(id_toko: id_toko);
    await fetchSubKategoriProdukLocal(id_toko: id_toko);
    await fetchProdukLocal(id_toko: id_toko);
    await fetchRiwayatPenjualan(id_toko: id_toko);
    totalpenjualan.value = penjualan.length;
    totaluang.value =
        penjualan.fold(0.0, (sum, item) => sum + (item.totalBayar!));
  }

  RxString username = ''.obs;
  RxString email = ''.obs;
  var token = ''.obs;
  var logo = ''.obs;
  var toko = ''.obs;
  var namatoko = GetStorage().read('user_business_name');

  List<String> produklist = ['kopi', 'milo', 'indomie', 'supermie', 'arabica'];

  String? jenisvalue;
  var jenislistlocal = [
    'Promo',
    'Kupon',
    "Point",
  ].obs;

  var totalpenjualan = 0.obs;
  var totaluang = 0.0.obs;
  var groupedPenjualan = <DataPenjualanByDate>[].obs;
  fetchRiwayatPenjualan({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT penjualan.*,pelanggan.nama_pelanggan as nama_pelanggan FROM penjualan LEFT JOIN pelanggan ON penjualan.id_pelanggan = pelanggan.uuid WHERE penjualan.id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPenjualan> data =
          query.map((e) => DataPenjualan.fromJsondb(e)).toList();
      penjualan.value = data;
      // 3) Convert each DataPenjualan → PenjualanItem
      final List<PenjualanItem> items =
          data.map((dp) => PenjualanItem.fromDataPenjualan(dp)).toList();
      // 4) Group by tanggal (String key)
      final Map<String, List<PenjualanItem>> tempMap = {};
      for (final item in items) {
        tempMap.putIfAbsent(item.tanggal, () => []).add(item);
        // 5) Build a List<PenjualanByDate> from that map
        final List<DataPenjualanByDate> groups = [];
        tempMap.forEach((date, listForThisDate) {
          // Sort the transactions however you like. Since there is no “waktu,”
          // we can just leave them in insertion order, or sort by noFaktur:
          listForThisDate.sort((a, b) => a.noFaktur.compareTo(b.noFaktur));

          // Compute daily total:
          final double dailyTotal = listForThisDate.fold<double>(
            0.0,
            (sum, item) => sum + item.totalBayar,
          );

          groups.add(DataPenjualanByDate(
            date: date,
            totalForDate: dailyTotal.toInt(),
            items: listForThisDate,
          ));
        });

        // 6) Sort the date‐groups descending, so the newest date appears first
        groups.sort((a, b) => b.date.compareTo(a.date));

        groupedPenjualan.value = groups;
      }
    } else {
      print('empty');
      return null;
    }
  }

  var tampilan = ''.obs;

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
  var penjualan = <DataPenjualan>[].obs;
  List<String> meja = [
    'meja 1',
    'meja 2',
    'meja 3',
    'meja 4',
    'meja 5',
  ].obs;

  checktour() async {
    var x = await GetStorage().read('tour');
    print(x);
    if (x == null) {
      await GetStorage().write('tour', true);
      Popscreen().toursplash();
    }
  }

  var uuid = ''.obs;
  //var uuid;

  var datauser = <DataUser>[].obs;

  fetchUserLocal(id) async {
    print('-------------------fetch user local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        users.*, 
        provinces.name AS province_name, 
        regencies.name AS regency_name, 
        districts.name AS district_name, 
        jenis_usaha.nama as business_name
    FROM 
        users 
    LEFT JOIN 
        provinces ON users.pilih_provinsi = provinces.id 
    LEFT JOIN 
        regencies ON users.pilih_kabupaten = regencies.id 
    LEFT JOIN 
        districts ON users.pilih_kecamatan = districts.id
    LEFT JOIN 
        jenis_usaha ON users.id_jenis_usaha = jenis_usaha.uuid 
    WHERE 
        users.uuid = "$id"
  ''');
    if (query.isNotEmpty) {
      List<DataUser> data = query.map((e) => DataUser.fromJsondb(e)).toList();
      datauser.value = data;
      print(datauser.value);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  List<Widget> views = [
    HomeDistributor(),
    ProdukListDistributor(),
  ];

  List<String> title = const [
    'Home',
    'Produk',
  ];

  var index = 0.obs;

  List<IconData> icons = [
// The underscore declares a variable as private in dart.
    FontAwesomeIcons.home,

    FontAwesomeIcons.boxArchive,
  ];

  searchProdukLocal({id_toko, search}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        produk.*, 
        kelompok_produk.Nama_Kelompok AS nama_kategori,
        Sub_kelompok_produk.Nama_Sub_Kelompok AS nama_subkategori,
        pajak_produk.nama_pajak AS nama_pajak,
        ukuran_produk.ukuran as nama_ukuran
    FROM 
        produk 
    LEFT JOIN 
       Kelompok_produk ON produk.id_kelompok_produk = Kelompok_produk.uuid
    LEFT JOIN 
       Sub_kelompok_produk ON produk.id_sub_kelompok_produk = Sub_kelompok_produk.uuid
    LEFT JOIN 
       pajak_produk ON produk.pajak = pajak_produk.uuid
    LEFT JOIN 
       ukuran_produk ON produk.ukuran = ukuran_produk.uuid
    WHERE 
        produk.id_toko = "$id_toko" AND produk.nama_produk LIKE "%${searchproduk.value.text}%"
  ''');
    if (query.isNotEmpty) {
      List<DataProduk> data =
          query.map((e) => DataProduk.fromJsondb(e)).toList();
      produk.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var isAscending = true.obs;
  fetchProdukLocal({id_toko, bool ascending = true}) async {
    print('-------------------fetch produk local---------------------');

    String orderBy = ascending ? 'ASC' : 'DESC'; // Determine order
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      produk.*, 
      kelompok_produk.Nama_Kelompok AS nama_kategori,
      Sub_kelompok_produk.Nama_Sub_Kelompok AS nama_subkategori,
      pajak_produk.nama_pajak AS nama_pajak,
      pajak_produk.nominal_pajak AS nominal_pajak,
      stock_produk.stok AS qty,
      ukuran_produk.ukuran as nama_ukuran
  FROM 
      produk 
  LEFT JOIN 
     Kelompok_produk ON produk.id_kelompok_produk = Kelompok_produk.uuid
  LEFT JOIN 
     Sub_kelompok_produk ON produk.id_sub_kelompok_produk = Sub_kelompok_produk.uuid
  LEFT JOIN 
     pajak_produk ON produk.pajak = pajak_produk.uuid
  LEFT JOIN 
     ukuran_produk ON produk.ukuran = ukuran_produk.uuid
  LEFT JOIN 
     stock_produk ON produk.uuid = stock_produk.id_produk
  WHERE 
      produk.id_toko = "$id_toko"
  ORDER BY produk.nama_produk $orderBy
  ''');
    if (query.isNotEmpty) {
      List<DataProduk> data =
          query.map((e) => DataProduk.fromJsondb(e)).toList();
      produk.value = data;
      print('qty---------->');
      print(data[0].qty);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchPaketLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      paket_produk.*, 
      pajak_produk.nama_pajak AS nama_pajak,
      pajak_produk.nominal_pajak AS nominal_pajak
  FROM 
      paket_produk 
  LEFT JOIN 
     pajak_produk ON paket_produk.pajak = pajak_produk.uuid
  WHERE 
      paket_produk.id_toko = "$id_toko"
  
  ''');
    if (query.isNotEmpty) {
      List<DataPaketProduk> data =
          query.map((e) => DataPaketProduk.fromJsondb(e)).toList();
      paketproduk.value = data;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var pajakValue;
  var pajakList = <DataPajakProduk>[].obs;

  var ukuranValue;
  var ukuranList = <DataUkuranProduk>[].obs;
  fetchPajakLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM pajak_produk WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPajakProduk> data =
          query.map((e) => DataPajakProduk.fromJsondb(e)).toList();
      pajakList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchUkuranLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM ukuran_produk WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataUkuranProduk> data =
          query.map((e) => DataUkuranProduk.fromJsondb(e)).toList();
      ukuranList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchKategoriProdukLocal({id_toko}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Kelompok_produk WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKategoriProduk> data =
          query.map((e) => DataKategoriProduk.fromJsondb(e)).toList();
      kategoriProduk.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchSubKategoriProdukLocal({id_toko}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        Sub_Kelompok_produk.*, 
        kelompok_produk.Nama_Kelompok AS kategori_nama
    FROM 
        Sub_Kelompok_produk 
    LEFT JOIN 
       Kelompok_produk ON Sub_Kelompok_produk.ID_Kelompok_Produk = Kelompok_produk.uuid 
    WHERE 
         Sub_Kelompok_produk.id_toko = "$id_toko"
  ''');
    if (query.isNotEmpty) {
      List<DataSubKategoriProduk> data =
          query.map((e) => DataSubKategoriProduk.fromJsondb(e)).toList();
      subKategoriProduk.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  bool isBase64Svg(String base64) {
    try {
      // Decode the base64 string to UTF-8
      final String decoded = utf8.decode(base64Decode(base64));
      // Check if the decoded string contains '<svg'
      return decoded.contains('<svg');
    } catch (e) {
      // If decoding fails, it's not an SVG
      return false;
    }
  }

  var id_toko = GetStorage().read('uuid');
  var kategoriProduk = <DataKategoriProduk>[].obs;
  var produk = <DataProduk>[].obs;
  var subKategoriProduk = <DataSubKategoriProduk>[].obs;
  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var subsearch = TextEditingController().obs;
  serachKategoriProdukLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Kelompok_produk WHERE id_toko = "$id_toko" AND Nama_Kelompok LIKE "%${search.value.text}%" ');
    List<DataKategoriProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataKategoriProduk.fromJsondb(e)).toList()
        : [];
    kategoriProduk.value = jenis;

    return jenis;
  }

  serachSubKategoriProdukLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
   SELECT 
    Sub_Kelompok_produk.*, 
    Kelompok_produk.Nama_Kelompok AS kategori_nama
FROM 
    Sub_Kelompok_produk 
LEFT JOIN 
    Kelompok_produk ON Sub_Kelompok_produk.ID_Kelompok_Produk = Kelompok_produk.uuid 
WHERE 
    Sub_Kelompok_produk.id_toko = "$id_toko" 
    AND Sub_Kelompok_produk.Nama_Sub_Kelompok LIKE "%${subsearch.value.text}%"
  ''');
    List<DataSubKategoriProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataSubKategoriProduk.fromJsondb(e)).toList()
        : [];
    subKategoriProduk.value = jenis;

    return jenis;
  }
}
