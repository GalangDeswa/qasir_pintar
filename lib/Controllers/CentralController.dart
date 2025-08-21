import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:uuid/uuid.dart';

import '../Database/DB_helper.dart';
import '../Modules - P.O.S/Base menu/controller_basemenu.dart';
import '../Modules - P.O.S/Beban/model_beban.dart';
import '../Modules - P.O.S/Karyawan/model_karyawan.dart';
import '../Modules - P.O.S/Kasir/model_penjualan.dart';
import '../Modules - P.O.S/Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../Modules - P.O.S/Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';
import '../Modules - P.O.S/Produk/Data produk/model_produk.dart';
import '../Modules - P.O.S/Produk/Kategori/model_subkategoriproduk.dart';
import '../Modules - P.O.S/Produk/Produk/model_kategoriproduk.dart';
import '../Modules - P.O.S/Produk/stock/model_penerimaan.dart';
import '../Modules - P.O.S/Produk/stock/penerimaan produk/controller_penerimaan_produk.dart';
import '../Modules - P.O.S/Promo/model_promo.dart';
import '../Modules - P.O.S/Supplier/model_supplier.dart';
import '../Services/BoxStorage.dart';
import '../Widget/widget.dart';

final StorageService box = Get.find<StorageService>();

class CentralProdukController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('PRODUCT CENTRAL CONTROLLER INIT -->');
    await fetchProdukLocal(id_toko: id_toko);
  }

  RxBool isAsc = false.obs;

  void sortProduk() {
    // 1) Copy penjualan list
    final List<DataProduk> data = [...produk];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.nama_produk!.compareTo(b.nama_produk!);
      } else {
        return b.nama_produk!.compareTo(a.nama_produk!);
      }
    });

    // 3) Update penjualan list
    produk.value = data;
  }

// Helper: toggle sort order
  void toggleSortProduk() {
    isAsc.value = !isAsc.value;
    sortProduk();
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
  filterStock({id_toko, required int stock, required String filter}) async {
    print('-------------------fetch produk local---------------------');

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
      produk.id_toko = "$id_toko" AND stock_produk.stok $filter $stock
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
      return [];
    }
  }

  deletepajak({uuid}) async {
    print('delete pajak local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'pajak_produk', id: uuid);
    if (delete == 1) {
      final index = pajakList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        pajakList.removeAt(index);
      }
      await fetchPajakLocal(id_toko: id_toko);
      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }
  }

  deleteukuran({uuid}) async {
    print('delete pajak local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'ukuran_produk', id: uuid);
    if (delete == 1) {
      final index = ukuranList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        ukuranList.removeAt(index);
      }
      await fetchUkuranLocal(id_toko: id_toko);
      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }
  }

  deleteKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Kelompok_produk', id: uuid);
    if (delete == 1) {
      final index = kategoriProduk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        kategoriProduk.removeAt(index);
      }
      await fetchKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }
  }

  deleteProduk({uuid}) async {
    print('delete produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'produk', id: uuid);

    if (delete == 1) {
      final index = produk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        produk.removeAt(index);
      }

      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      print('delete error-------------------');
      print(delete);
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('Error', 'Gagal'));
    }
  }

  deleteSubKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete =
        await DBHelper().DELETE(table: 'Sub_Kelompok_produk', id: uuid);
    if (delete == 1) {
      final index = subKategoriProduk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        subKategoriProduk.removeAt(index);
      }
      await fetchSubKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
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

  var id_toko = box.read('uuid', fallback: 'null');
  var kategoriProduk = <DataKategoriProduk>[].obs;
  var produk = <DataProduk>[].obs;
  var subKategoriProduk = <DataSubKategoriProduk>[].obs;
  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var subsearch = TextEditingController().obs;
  var penerimaan = <DataPenerimaanProduk>[].obs;
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

  searchProdukLocal({id_toko, search}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        produk.*, 
        kelompok_produk.Nama_Kelompok AS nama_kategori,
        Sub_kelompok_produk.Nama_Sub_Kelompok AS nama_subkategori,
        pajak_produk.nama_pajak AS nama_pajak,
        ukuran_produk.ukuran as nama_ukuran,
        stock_produk.stok AS qty
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
  fetchProdukLocal(
      {id_toko,
      bool ascending = true,
      bool? isAktif,
      bool? hitungStock}) async {
    print('-------------------fetch produk local---------------------');
    String orderBy = ascending ? 'ASC' : 'DESC';

    // Base query
    String sql = '''
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
  ''';

    // Add condition only if isAktif is provided
    if (isAktif != null) {
      print('product filter isAKtif  == TRUE');
      sql += ' AND produk.tampilkan_di_produk = ${isAktif ? 1 : 0}';
    }

    if (hitungStock != null) {
      sql += ' AND produk.hitung_stok = ${hitungStock ? 1 : 0}';
    }

    // Append ORDER BY at the very end
    sql += ' ORDER BY produk.nama_produk $orderBy';

    List<Map<String, Object?>> query = await DBHelper().FETCH(sql);

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

  fetchPenerimaanLocal({id_toko, bool ascending = true}) async {
    print('-------------------fetch penerimaan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      penerimaan_produk.*, 
      supplier.nama_supplier AS nama_supplier
  FROM 
      penerimaan_produk 
  LEFT JOIN 
     supplier ON penerimaan_produk.id_supplier = supplier.uuid
  WHERE 
      penerimaan_produk.id_toko = "$id_toko"
  
  ''');
    if (query.isNotEmpty) {
      List<DataPenerimaanProduk> data =
          query.map((e) => DataPenerimaanProduk.fromJsondb(e)).toList();
      penerimaan.value = data;
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
}

class CentralPaketController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchPaketLocal(id_toko: id_toko);
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
  RxBool isAsc = false.obs;

  void sortPaket() {
    // 1) Copy penjualan list
    final List<DataPaketProduk> data = [...paketproduk];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.nama_paket!.compareTo(b.nama_paket!);
      } else {
        return b.nama_paket!.compareTo(a.nama_paket!);
      }
    });

    // 3) Update penjualan list
    paketproduk.value = data;
  }

// Helper: toggle sort order
  void toggleSortPaket() {
    isAsc.value = !isAsc.value;
    sortPaket();
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
  var searchpaket = TextEditingController().obs;
  var subsearch = TextEditingController().obs;
  var penerimaan = <DataPenerimaanProduk>[].obs;

  searchPaketLocal({id_toko, search}) async {
    print('-------------------fetch paket local---------------------');

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
      paket_produk.id_toko = "$id_toko" AND paket_produk.nama_paket LIKE "%${search}%"
  ''');
    if (query.isNotEmpty) {
      List<DataPaketProduk> data =
          query.map((e) => DataPaketProduk.fromJsondb(e)).toList();
      paketproduk.value = data;
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

  fetchPenerimaanLocal({id_toko, bool ascending = true}) async {
    print('-------------------fetch penerimaan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      penerimaan_produk.*, 
      supplier.nama_supplier AS nama_supplier
  FROM 
      penerimaan_produk 
  LEFT JOIN 
     supplier ON penerimaan_produk.id_supplier = supplier.uuid
  WHERE 
      penerimaan_produk.id_toko = "$id_toko"
  
  ''');
    if (query.isNotEmpty) {
      List<DataPenerimaanProduk> data =
          query.map((e) => DataPenerimaanProduk.fromJsondb(e)).toList();
      penerimaan.value = data;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchPaketLocal({id_toko, bool? isAktif}) async {
    print('-------------------fetch produk local---------------------');
    String sql = '''
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
  
  ''';
    if (isAktif != null) {
      print('paket filter isAKtif  == TRUE');
      sql += ' AND paket_produk.tampilkan_di_paket = ${isAktif ? 1 : 0}';
    }

    List<Map<String, Object?>> query = await DBHelper().FETCH(sql);
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
}

class CentralSupplierController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('init central supplier -->');
    await fetchSupplierLocal(id_toko: id_toko);
  }

  RxBool isAsc = false.obs;

  void sortSupplier() {
    // 1) Copy penjualan list
    final List<DataSupplier> data = [...supplierList];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.nama_supplier!.compareTo(b.nama_supplier!);
      } else {
        return b.nama_supplier!.compareTo(a.nama_supplier!);
      }
    });

    // 3) Update penjualan list
    supplierList.value = data;
  }

// Helper: toggle sort order
  void toggleSortSupplier() {
    isAsc.value = !isAsc.value;
    sortSupplier();
  }

  deleteSupplier({uuid}) async {
    print('delete supplier local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Supplier', id: uuid);
    if (delete == 1) {
      final index = supplierList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        supplierList.removeAt(index);
      }
      await fetchSupplierLocal(id_toko: id_toko);

      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'Supplier berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
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
  var pelangganList = <DataPelanggan>[].obs;
  var supplierList = <DataSupplier>[].obs;
  var suppliervalue;
  var search = TextEditingController().obs;

  serachSupplierLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Supplier WHERE id_toko = "$id_toko" AND Nama_Supplier LIKE "%${search}%" ');
    List<DataSupplier> jenis = query.isNotEmpty
        ? query.map((e) => DataSupplier.fromJsondb(e)).toList()
        : [];
    supplierList.value = jenis;

    return jenis;
  }

//TODO : fix supplier is aktif tetap muncul
  fetchSupplierLocal({id_toko, bool? isAktif}) async {
    // supplierList.clear();
    print(
        '-------------------fetch supplier local pakai aktif---------------------');

    String sql = 'SELECT * FROM Supplier WHERE id_toko = "$id_toko"';

    if (isAktif != null) {
      final aktifValue = isAktif ? 1 : 0;
      sql += ' AND Aktif = $aktifValue';
    }
    print(sql);

    List<Map<String, Object?>> query = await DBHelper().FETCH(sql);
    if (query.isNotEmpty) {
      List<DataSupplier> data =
          query.map((e) => DataSupplier.fromJsondb(e)).toList();
      //supplierList.value.clear();
      supplierList.value = data;
      print(data);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  Future<void> selectContact() async {
    try {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        // Update your controllers
        nama.value.text = contact.displayName;

        if (contact.emails.isNotEmpty) {
          email.value.text = contact.emails.first.address;
        }

        if (contact.phones.isNotEmpty) {
          telepon.value.text = contact.phones.first.number;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih kontak: $e');
    }
  }

  checkContactPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      var status = await Permission.contacts.status;
      print(status);
      if (!status.isGranted) {
        await Permission.contacts.request();
      }
    } else {
      var status = await Permission.contacts.status;
      print(status);
      if (!status.isGranted) {
        await Permission.contacts.request();
      }
    }
    return true;
  }

  Future<void> showPermissionDeniedDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('Izin Kontak Diperlukan'),
        content: Text(
          'Aplikasi memerlukan akses ke kontak Anda untuk memilih pelanggan. '
          'Silakan aktifkan izin kontak di pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
            },
            child: Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  var nama = TextEditingController().obs;
  var email = TextEditingController().obs;

  var telepon = TextEditingController().obs;
  var kodeRef = TextEditingController().obs;
  var konpass = TextEditingController().obs;
  var alamat = TextEditingController().obs;
  final registerKey = GlobalKey<FormState>().obs;
  final registerLokasiKey = GlobalKey<FormState>().obs;
  var id;
  var showpass = true.obs;
  var showkon = true.obs;
  List<DateTime?> datedata = [
    //DateTime.now(),
  ];
  String? jenisvalue;
  var jenislistlocal = ['Toko', 'CAFE', "JASA"].obs;

  pilihsourcefoto() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        content: Builder(
          builder: (context) {
            return Container(
              width: context.res_height / 2.6,
              height: context.res_height / 2.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pilih Sumber Foto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_solid_custom(
                        onPressed: () {
                          pickImageGallery();
                        },
                        child: Text(
                          'Galeri',
                          style: AppFont.regular_white_bold(),
                        ),
                        width: context.res_width),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_solid_custom(
                        onPressed: () {
                          pickImageCamera();
                        },
                        child:
                            Text('Kamera', style: AppFont.regular_white_bold()),
                        width: context.res_width),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_border_custom(
                        onPressed: () {
                          pilihIcon(context);
                        },
                        child: Text('Ikon', style: AppFont.regular_bold()),
                        width: context.res_width),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  var image64;
  File? pickedImageFile;
  var pikedImagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  List<XFile> images = [];
  List<String> listimagepath = [];
  var selectedfilecount = 0.obs;
  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
          maxHeight: 300,
          maxWidth: 300);
      if (image == null) return;
      pickedImageFile = File(image.path);
      final bytes = File(image!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      image64 = base64Image;
      pikedImagePath.value = pickedImageFile!.path;
      pickedIconPath.value = '';
      print(pikedImagePath);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 100,
          maxHeight: 300,
          maxWidth: 300);
      if (image == null) return;
      pickedImageFile = File(image.path);
      final bytes = File(image!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      image64 = base64Image;
      //  final temppath = File(image!.path);
      pikedImagePath.value = pickedImageFile!.path;
      pickedIconPath.value = '';
      print(image64);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  pilihIcon(BuildContext context) {
    final List<String> icons = [
      'assets/icons/user1.svg',
      'assets/icons/user2.svg',
      'assets/icons/user3.svg',
      'assets/icons/user4.svg',
      'assets/icons/user5.svg',
      'assets/icons/user6.svg',
      'assets/icons/user7.svg',
      'assets/icons/user8.svg',
      'assets/icons/user9.svg',
    ];

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Container(
          width: context.res_height / 2,
          height: context.res_height / 2,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 icons per row
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle icon selection
                  _onIconSelected(icons[index]);
                  Get.back(); // Close the dialog
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      icons[index],
                      width: 30, // Adjust size as needed
                      height: 30,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onIconSelected(String iconPath) async {
    // Handle the selected icon
    pikedImagePath.value = '';
    pickedIconPath.value = iconPath;
    final String base64Svg = await svgToBase64(iconPath);
    image64 = base64Svg;
    print('Base64 SVG: $base64Svg');
    Get.back();

    // You can store the icon path in a variable or database
  }

  var pickedIconPath = ''.obs;

  Future<String> svgToBase64(String assetPath) async {
    final String svgString = await rootBundle.loadString(assetPath);
    return base64Encode(utf8.encode(svgString));
  }

  var tanggal = TextEditingController().obs;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  stringdate() {
    var ff = dateFormat.format(datedata.first!);
    tanggal.value.text = ff;
  }

  tambahSupplierLocal() async {
    print('-------------------tambah supplier local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'Supplier',
        DataSupplier(
                id_toko: id_toko,
                nohp: telepon.value.text,
                alamat: alamat.value.text,
                uuid: uuid,
                nama_supplier: nama.value.text,
                aktif: 1)
            .DB());

    if (db != null) {
      await fetchSupplierLocal(id_toko: id_toko);
      var x = await Get.find<PenerimaanProdukController>();
      x.suppliervalue.value = uuid;
      suppliervalue = uuid;
      Get.back();
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}

class CentralKaryawanController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchKaryawanLocal(id_toko: id_toko);

    //role.value = '';
  }

  RxBool isAsc = false.obs;

  void sortKaryawan() {
    // 1) Copy penjualan list
    final List<DataKaryawan> data = [...karyawanList];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.nama_karyawan!.compareTo(b.nama_karyawan!);
      } else {
        return b.nama_karyawan!.compareTo(a.nama_karyawan!);
      }
    });

    // 3) Update penjualan list
    karyawanList.value = data;
  }

// Helper: toggle sort order
  void toggleSortKaryawan() {
    isAsc.value = !isAsc.value;
    sortKaryawan();
  }

  deleteKaryawan({uuid}) async {
    print('delete karyawan local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Karyawan', id: uuid);
    if (delete == 1) {
      // Manually remove from the list first
      final index = karyawanList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        karyawanList.removeAt(index);
      }

      // Then refresh from database
      await fetchKaryawanLocal(id_toko: id_toko);

      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'Karyawan berhasil dihapus'));
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
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

  var karyawanList = <DataKaryawan>[].obs;
  var karyawanvalue;
  var role = Rxn<String>();
  var namaKaryawan = ''.obs;
  var search = TextEditingController().obs;
  var verifikasi_kode = TextEditingController().obs;
  var rolevalue;
  var popResult = false.obs;

  Future<bool> popLoginKaryawan(List<String> allowedRoles) async {
    final completer = Completer<bool>(); // To return the login result

    print('popLoginKaryawan started');
    print('<------------------- POP LOGIN KARYAWN -------------------------->');

    verifikasi_kode.value = TextEditingController();

    Get.dialog<bool>(
        barrierDismissible: false,
        SheetViewport(
            child: Sheet(
          // scrollConfiguration: SheetScrollConfiguration(),
          initialOffset: const SheetOffset(0.6),
          physics: BouncingSheetPhysics(),
          snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.6), SheetOffset(1)]),
          child: Material(
              color: Colors.white,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  padding: AppPading.defaultBodyPadding(),
                  height: Get.height,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: AppPading.customBottomPadding(),
                                  child: Obx(() {
                                    return DropdownButtonFormField2(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Pilih Karyawan';
                                        }
                                        return null;
                                      },
                                      isExpanded: true,
                                      dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white)),
                                      hint: Text('Pilih Karyawan',
                                          style: AppFont.regular()),
                                      value: karyawanvalue,
                                      items: karyawanList.map((x) {
                                        return DropdownMenuItem(
                                          child: Text(x.nama_karyawan!),
                                          value: x.uuid,
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        rolevalue = karyawanList
                                            .where(
                                                (x) => x.uuid == val.toString())
                                            .first
                                            .role;
                                        namaKaryawan.value = karyawanList
                                            .where(
                                                (x) => x.uuid == val.toString())
                                            .first
                                            .nama_karyawan!;
                                        karyawanvalue = val!.toString();
                                        print(karyawanvalue);
                                      },
                                    );
                                  }),
                                ),
                                // button_border_custom(
                                //     onPressed: () {
                                //       Get.toNamed('/tambahkaryawan');
                                //     },
                                //     child: Text('Tambah Karyawan'),
                                //     width: Get.width),
                                // SizedBox(height: 100.0),
                              ],
                            ),
                            //Text('Masukan kode verifikasi'),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: 350,
                              child: Column(
                                children: [
                                  PinCodeTextField(
                                    appContext: Get.context!,
                                    length: 6,
                                    obscureText: true,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.circle,
                                        borderRadius: BorderRadius.circular(5),
                                        fieldHeight: 50,
                                        fieldWidth: 40,
                                        activeFillColor: Colors.white,
                                        inactiveColor: AppColor.primary),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    //backgroundColor: Colors.blue.shade50,
                                    controller: verifikasi_kode.value,
                                    onCompleted: (v) {
                                      print("Completed");
                                    },
                                    onChanged: (value) {
                                      print('verifikasi code -->' + value);
                                      print(verifikasi_kode.value.text);
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");

                                      return true;
                                    },
                                    // appContext: context,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: 350,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: AppColor.secondary),
                                      onPressed: () async {
                                        loginFailed.value =
                                            false; // Reset error state
                                        final success = await loginKaryawan(
                                            karyawanvalue,
                                            verifikasi_kode.value.text,
                                            role.value,
                                            allowedRoles);
                                        if (success) {
                                          print(
                                              'khsegfiueksghfdiuseghfiusegfiusegfiusegfiuesgfiusegfiusegf');

                                          // Close the sheet on success
                                          completer.complete(
                                              true); // Return true to the caller
                                        } else {
                                          loginFailed.value =
                                              true; // Show error, keep sheet open
                                        }
                                      },
                                      child: Text('Masuk'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        )));

    return completer.future;
  }

  var popSheetController = SheetController;
  RxBool roleSheetShown = false.obs;
  popLoginKaryawanv2(List<String> allowedRoles) async {
    isLogin.value = false;
    print('popLoginKaryawan started');
    print('<------------------- POP LOGIN KARYAWN -------------------------->');

    verifikasi_kode.value = TextEditingController();

    Get.dialog(
        barrierDismissible: false,
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            // if the user manually backed out AND login never succeeded
            if (isLogin.value == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed('/basemenu');
              });
            }
          },
          child: SheetViewport(
              child: Sheet(
            // scrollConfiguration: SheetScrollConfiguration(),
            initialOffset: const SheetOffset(0.6),
            physics: BouncingSheetPhysics(),
            snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.6), SheetOffset(1)]),
            child: Material(
                color: Colors.white,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    padding: AppPading.defaultBodyPadding(),
                    height: Get.height,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                    margin: AppPading.customBottomPadding(),
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      'Hak akses : ' + allowedRoles.toString(),
                                      style: AppFont.regular_white_bold(),
                                    ),
                                    decoration: BoxDecoration(
                                        color: AppColor.primary,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              Padding(
                                padding: AppPading.customBottomPadding(),
                                child: Obx(() {
                                  return DropdownButtonFormField2(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Pilih Karyawan';
                                      }
                                      return null;
                                    },
                                    isExpanded: true,
                                    dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white)),
                                    hint: Text('Pilih Karyawan',
                                        style: AppFont.regular()),
                                    value: karyawanvalue,
                                    items: karyawanList.map((x) {
                                      return DropdownMenuItem(
                                        child: Text(x.nama_karyawan!),
                                        value: x.uuid,
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      rolevalue = karyawanList
                                          .where(
                                              (x) => x.uuid == val.toString())
                                          .first
                                          .role;
                                      namaKaryawan.value = karyawanList
                                          .where(
                                              (x) => x.uuid == val.toString())
                                          .first
                                          .nama_karyawan!;
                                      karyawanvalue = val!.toString();
                                      print(karyawanvalue);
                                    },
                                  );
                                }),
                              ),
                              //Text('Masukan kode verifikasi'),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                width: 350,
                                child: Column(
                                  children: [
                                    PinCodeTextField(
                                      appContext: Get.context!,
                                      length: 6,
                                      obscureText: true,
                                      animationType: AnimationType.fade,
                                      pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.circle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          fieldHeight: 50,
                                          fieldWidth: 40,
                                          activeFillColor: Colors.white,
                                          inactiveColor: AppColor.primary),
                                      animationDuration:
                                          Duration(milliseconds: 300),
                                      //backgroundColor: Colors.blue.shade50,
                                      controller: verifikasi_kode.value,
                                      onCompleted: (v) {
                                        print("Completed");
                                      },
                                      onChanged: (value) {
                                        print('verifikasi code -->' + value);
                                        print(verifikasi_kode.value.text);
                                      },
                                      beforeTextPaste: (text) {
                                        print("Allowing to paste $text");

                                        return true;
                                      },
                                      // appContext: context,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 350,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                AppColor.secondary),
                                        onPressed: () async {
                                          loginFailed.value =
                                              false; // Reset error state
                                          final success = await loginKaryawan(
                                              karyawanvalue,
                                              verifikasi_kode.value.text,
                                              role.value,
                                              allowedRoles);
                                          if (success) {
                                            print('loginKaryawan() success');
                                          } else {
                                            loginFailed.value = true;
                                            roleSheetShown.value =
                                                false; // Show error, keep sheet open
                                          }
                                        },
                                        child: Text('Masuk'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))),
          )),
        ));
  }

  var loginFailed = false.obs; // Tracks if login failed
  var isLogin = false.obs;
  Future<bool> loginKaryawan(
      uuid, kode, roleval, List<String> allowedRoles) async {
    //Get.dialog(showloading(), barrierDismissible: false);
    print('-------------------login karyawan---------------------');
    isLogin.value = false;
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Karyawan WHERE id_toko = "$id_toko" AND uuid = "$uuid" AND Pin = "$kode"');
    print('<------------->');
    print(query);
    if (query.isNotEmpty) {
      print('login berhasil');
      var data = query.map((e) => DataKaryawan.fromJsondb(e)).toList();
      karyawanvalue = data.first.uuid;
      role.value = data.first.role!;

      if (!allowedRoles.contains(role.value)) {
        print('tidak ada role ---->');
        Get.showSnackbar(toast().bottom_snackbar_error(
            'Error', 'Hanya bisa diakses oleh : $allowedRoles'));
      } else {
        isLogin.value = true;
        Get.back();
      }

      return true;
    } else {
      print('login gagal');
      //Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'Kode Verifikasi Salah'));
      return false;
    }
  }

  searchKaryawanLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Karyawan WHERE id_toko = "$id_toko" AND Nama_Karyawan LIKE "%${search}%" ');
    List<DataKaryawan> jenis = query.isNotEmpty
        ? query.map((e) => DataKaryawan.fromJsondb(e)).toList()
        : [];
    karyawanList.value = jenis;

    return jenis;
  }

  fetchKaryawanLocal({id_toko}) async {
    print('-------------------fetch karyawan local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Karyawan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKaryawan> data =
          query.map((e) => DataKaryawan.fromJsondb(e)).toList();
      karyawanList.value = data;

      return data;
    } else {
      print('empty');
      return null;
    }
  }
}

class CentralPelangganController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('on init central pelanggan controlelr');
    await fetchPelangganLocal(id_toko: id_toko);
    await fetchKategoriPelangganLocal(id_toko);
  }

  RxBool isAsc = false.obs;
  RxBool isAscKat = false.obs;

  void sortPelanggan() {
    // 1) Copy penjualan list
    final List<DataPelanggan> data = [...pelangganList];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.namaPelanggan!.compareTo(b.namaPelanggan!);
      } else {
        return b.namaPelanggan!.compareTo(a.namaPelanggan!);
      }
    });

    // 3) Update penjualan list
    pelangganList.value = data;
  }

// Helper: toggle sort order
  void toggleSortPelanggan() {
    isAsc.value = !isAsc.value;
    sortPelanggan();
  }

  void sortKategoriPelanggan() {
    // 1) Copy penjualan list
    final List<DataKategoriPelanggan> data = [...kategoripelangganList];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAscKat.value) {
        return a.kategori!.compareTo(b.kategori!);
      } else {
        return b.kategori!.compareTo(a.kategori!);
      }
    });

    // 3) Update penjualan list
    kategoripelangganList.value = data;
  }

// Helper: toggle sort order
  void toggleSortKategoriPelanggan() {
    isAscKat.value = !isAscKat.value;
    sortKategoriPelanggan();
  }

  deletePelanggan({uuid}) async {
    print(
        'delete kategori pelanggan local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'pelanggan', id: uuid);
    if (delete == 1) {
      final index = pelangganList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        pelangganList.removeAt(index);
      }

      await fetchPelangganLocal(id_toko: id_toko);

      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }

    // var select = kategoripelangganList.where((x) => x.uuid == uuid).first;
    // var delete = await DBHelper().UPDATE(
    //   id: select.idLocal,
    //   table: 'beban_local',
    //   data: DataBeban(
    //       aktif: 'N',
    //       sync: 'N',
    //       id: select.id,
    //       idLocal: select.idLocal,
    //       idToko: select.idToko,
    //       jumlah: select.jumlah,
    //       tgl: select.tgl,
    //       keterangan: select.keterangan,
    //       nama: select.nama,
    //       idKtrBeban: select.idKtrBeban,
    //       idUser: select.idUser,
    //       namaKtrBeban: select.namaKtrBeban)
    //       .toMapForDb(),
    // );

    // var query = await DBHelper().DELETE('produk_local', id);
    // if (delete == 1) {
    //   await fetchBebanlocal(id_toko);
    //   await Get.find<dashboardController>().loadbebanhariini();
    //   await Get.find<dashboardController>().loadpendapatanhariini();
    //   await Get.find<dashboardController>().loadpendapatantotal();
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_success('Sukses', 'Beban berhasil dihapus'));
    //   print('deleted ' + id_local.toString());
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(toast()
    //       .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    // }
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
  var pelangganList = <DataPelanggan>[].obs;
  var search = TextEditingController().obs;
  var katsearch = TextEditingController().obs;
  var kategoripelangganList = <DataKategoriPelanggan>[].obs;
  serachPelangganLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        pelanggan.*, 
        kategori_pelanggan.kategori AS kategori_nama
    FROM 
        pelanggan 
    LEFT JOIN 
        kategori_pelanggan ON pelanggan.ID_Kategori = kategori_pelanggan.uuid 
    WHERE 
        pelanggan.id_toko = "$id_toko" AND pelanggan.nama_pelanggan LIKE "%${search}%"
  ''');
    List<DataPelanggan> jenis = query.isNotEmpty
        ? query.map((e) => DataPelanggan.fromJsondb(e)).toList()
        : [];
    pelangganList.value = jenis;

    return jenis;
  }

  serachKategoriPelangganLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT * FROM kategori_pelanggan WHERE id_toko = "$id_toko" AND kategori LIKE "%${search}%"
  ''');
    List<DataKategoriPelanggan> jenis = query.isNotEmpty
        ? query.map((e) => DataKategoriPelanggan.fromJsondb(e)).toList()
        : [];
    kategoripelangganList.value = jenis;

    return jenis;
  }

  fetchPelangganLocal({id_toko, bool? isAktif}) async {
    print(
        '-------------------fetch pelanggan local CENTRAL CONTROLLER---------------------');
    String sql = '''
    SELECT 
        pelanggan.*, 
        kategori_pelanggan.kategori AS kategori_nama
    FROM 
        pelanggan 
    LEFT JOIN 
        kategori_pelanggan ON pelanggan.ID_Kategori = kategori_pelanggan.uuid 
    WHERE 
        pelanggan.id_toko = "$id_toko"
  ''';
    if (isAktif != null) {
      sql += ' AND pelanggan.aktif = ${isAktif ? 1 : 0}';
    }

    print(sql);

    List<Map<String, Object?>> query = await DBHelper().FETCH(sql);
    if (query.isNotEmpty) {
      List<DataPelanggan> data =
          query.map((e) => DataPelanggan.fromJsondb(e)).toList();
      pelangganList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  deleteKategoriPelanggan({uuid}) async {
    print(
        'delete kategori pelanggan local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'kategori_pelanggan', id: uuid);
    if (delete == 1) {
      final index = kategoripelangganList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        kategoripelangganList.removeAt(index);
      }
      await fetchKategoriPelangganLocal(id_toko);

      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }
  }

  //TODO : CHECK fecth if aktif di dropdown

  fetchKategoriPelangganLocal(String id_toko, {bool? isAktif}) async {
    print(
        '-------------------fetch kategori pelanggan local---------------------');

    // Base query
    String sql = 'SELECT * FROM kategori_pelanggan WHERE id_toko = "$id_toko"';

    // Add condition only if isAktif is provided
    if (isAktif != null) {
      sql += ' AND aktif = ${isAktif ? 1 : 0}';
    }

    List<Map<String, Object?>> query = await DBHelper().FETCH(sql);

    if (query.isNotEmpty) {
      List<DataKategoriPelanggan> data =
          query.map((e) => DataKategoriPelanggan.fromJsondb(e)).toList();
      kategoripelangganList.value = data;
      return data;
    } else {
      print('empty');
      return null;
    }
  }
}

class CentralPajakController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchPajakLocal(id_toko: id_toko);
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
  RxBool isAsc = false.obs;
  void sortPajak() {
    // 1) Copy penjualan list
    final List<DataPajakProduk> data = [...pajakList];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.nama_pajak!.compareTo(b.nama_pajak!);
      } else {
        return b.nama_pajak!.compareTo(a.nama_pajak!);
      }
    });

    // 3) Update penjualan list
    pajakList.value = data;
  }

// Helper: toggle sort order
  void toggleSortPajak() {
    isAsc.value = !isAsc.value;
    sortPajak();
  }

  deletepajak({uuid}) async {
    print('delete pajak local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'pajak_produk', id: uuid);
    if (delete == 1) {
      final index = pajakList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        pajakList.removeAt(index);
      }
      await fetchPajakLocal(id_toko: id_toko);
      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }

    // var select = kategoripelangganList.where((x) => x.uuid == uuid).first;
    // var delete = await DBHelper().UPDATE(
    //   id: select.idLocal,
    //   table: 'beban_local',
    //   data: DataBeban(
    //       aktif: 'N',
    //       sync: 'N',
    //       id: select.id,
    //       idLocal: select.idLocal,
    //       idToko: select.idToko,
    //       jumlah: select.jumlah,
    //       tgl: select.tgl,
    //       keterangan: select.keterangan,
    //       nama: select.nama,
    //       idKtrBeban: select.idKtrBeban,
    //       idUser: select.idUser,
    //       namaKtrBeban: select.namaKtrBeban)
    //       .toMapForDb(),
    // );

    // var query = await DBHelper().DELETE('produk_local', id);
    // if (delete == 1) {
    //   await fetchBebanlocal(id_toko);
    //   await Get.find<dashboardController>().loadbebanhariini();
    //   await Get.find<dashboardController>().loadpendapatanhariini();
    //   await Get.find<dashboardController>().loadpendapatantotal();
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_success('Sukses', 'Beban berhasil dihapus'));
    //   print('deleted ' + id_local.toString());
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(toast()
    //       .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    // }
  }

  deletepaket({uuid}) async {
    print('delete paket local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'paket_produk', id: uuid);
    if (delete == 1) {
      final index = paketproduk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        paketproduk.removeAt(index);
      }
      await fetchPaketLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }

    // var select = kategoripelangganList.where((x) => x.uuid == uuid).first;
    // var delete = await DBHelper().UPDATE(
    //   id: select.idLocal,
    //   table: 'beban_local',
    //   data: DataBeban(
    //       aktif: 'N',
    //       sync: 'N',
    //       id: select.id,
    //       idLocal: select.idLocal,
    //       idToko: select.idToko,
    //       jumlah: select.jumlah,
    //       tgl: select.tgl,
    //       keterangan: select.keterangan,
    //       nama: select.nama,
    //       idKtrBeban: select.idKtrBeban,
    //       idUser: select.idUser,
    //       namaKtrBeban: select.namaKtrBeban)
    //       .toMapForDb(),
    // );

    // var query = await DBHelper().DELETE('produk_local', id);
    // if (delete == 1) {
    //   await fetchBebanlocal(id_toko);
    //   await Get.find<dashboardController>().loadbebanhariini();
    //   await Get.find<dashboardController>().loadpendapatanhariini();
    //   await Get.find<dashboardController>().loadpendapatantotal();
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_success('Sukses', 'Beban berhasil dihapus'));
    //   print('deleted ' + id_local.toString());
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(toast()
    //       .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    // }
  }

  deleteukuran({uuid}) async {
    print('delete pajak local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'ukuran_produk', id: uuid);
    if (delete == 1) {
      final index = ukuranList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        ukuranList.removeAt(index);
      }
      await fetchUkuranLocal(id_toko: id_toko);
      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }

    // var select = kategoripelangganList.where((x) => x.uuid == uuid).first;
    // var delete = await DBHelper().UPDATE(
    //   id: select.idLocal,
    //   table: 'beban_local',
    //   data: DataBeban(
    //       aktif: 'N',
    //       sync: 'N',
    //       id: select.id,
    //       idLocal: select.idLocal,
    //       idToko: select.idToko,
    //       jumlah: select.jumlah,
    //       tgl: select.tgl,
    //       keterangan: select.keterangan,
    //       nama: select.nama,
    //       idKtrBeban: select.idKtrBeban,
    //       idUser: select.idUser,
    //       namaKtrBeban: select.namaKtrBeban)
    //       .toMapForDb(),
    // );

    // var query = await DBHelper().DELETE('produk_local', id);
    // if (delete == 1) {
    //   await fetchBebanlocal(id_toko);
    //   await Get.find<dashboardController>().loadbebanhariini();
    //   await Get.find<dashboardController>().loadpendapatanhariini();
    //   await Get.find<dashboardController>().loadpendapatantotal();
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_success('Sukses', 'Beban berhasil dihapus'));
    //   print('deleted ' + id_local.toString());
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(toast()
    //       .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    // }
  }

  deleteKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Kelompok_produk', id: uuid);
    if (delete == 1) {
      final index = kategoriProduk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        kategoriProduk.removeAt(index);
      }
      await fetchKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }

    // var select = kategoripelangganList.where((x) => x.uuid == uuid).first;
    // var delete = await DBHelper().UPDATE(
    //   id: select.idLocal,
    //   table: 'beban_local',
    //   data: DataBeban(
    //       aktif: 'N',
    //       sync: 'N',
    //       id: select.id,
    //       idLocal: select.idLocal,
    //       idToko: select.idToko,
    //       jumlah: select.jumlah,
    //       tgl: select.tgl,
    //       keterangan: select.keterangan,
    //       nama: select.nama,
    //       idKtrBeban: select.idKtrBeban,
    //       idUser: select.idUser,
    //       namaKtrBeban: select.namaKtrBeban)
    //       .toMapForDb(),
    // );

    // var query = await DBHelper().DELETE('produk_local', id);
    // if (delete == 1) {
    //   await fetchBebanlocal(id_toko);
    //   await Get.find<dashboardController>().loadbebanhariini();
    //   await Get.find<dashboardController>().loadpendapatanhariini();
    //   await Get.find<dashboardController>().loadpendapatantotal();
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_success('Sukses', 'Beban berhasil dihapus'));
    //   print('deleted ' + id_local.toString());
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(toast()
    //       .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    // }
  }

  deleteProduk({uuid}) async {
    print('delete produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'produk', id: uuid);

    if (delete == 1) {
      final index = produk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        produk.removeAt(index);
      }

      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      print('delete error-------------------');
      print(delete);
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('Error', 'Gagal'));
    }
  }

  deleteSubKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete =
        await DBHelper().DELETE(table: 'Sub_Kelompok_produk', id: uuid);
    if (delete == 1) {
      final index = subKategoriProduk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        subKategoriProduk.removeAt(index);
      }
      await fetchSubKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
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
  searchPajakLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM pajak_produk WHERE id_toko = "$id_toko" AND nama_pajak LIKE "%${search}%" ');
    List<DataPajakProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataPajakProduk.fromJsondb(e)).toList()
        : [];
    pajakList.value = jenis;

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
}

class CentralHistoryController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('central history init -->');
    await fetchRiwayatPenjualan(id_toko: id_toko);
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
  var penjualan = <DataPenjualan>[].obs;
  List<DateTime?> dates = [];
  var pickdate = TextEditingController().obs;
  final dateformat = DateFormat('dd-MM-yyyy');
  var date1;
  var date2;

  var groupedPenjualan = <DataPenjualanByDate>[].obs;

  fetchRiwayatPenjualanByTanggal({
    required String id_toko,
    required String startDate, // format: "2025-08-01"
    required String endDate, // format: "2025-08-31"
  }) async {
    penjualan.value = [];
    groupedPenjualan.value = [];

    print(
        '-------------------fetch history central local---------------------');

    String sql = '''
    SELECT penjualan.*,
           pelanggan.nama_pelanggan as nama_pelanggan,
           promo.nama_promo as nama_promo,
           Karyawan.Nama_Karyawan as nama_karyawan
    FROM penjualan
    LEFT JOIN pelanggan ON penjualan.id_pelanggan = pelanggan.uuid
    LEFT JOIN promo ON penjualan.kode_promo = promo.uuid
    LEFT JOIN Karyawan ON penjualan.id_karyawan = Karyawan.uuid
    WHERE penjualan.id_toko = "$id_toko"
      AND DATE(penjualan.tanggal) BETWEEN DATE("$startDate") AND DATE("$endDate")
    ORDER BY penjualan.id DESC
  ''';

    List<Map<String, Object?>> query = await DBHelper().FETCH(sql);

    if (query.isNotEmpty) {
      List<DataPenjualan> data =
          query.map((e) => DataPenjualan.fromJsondb(e)).toList();
      print(data);
      penjualan.value = data;

      // Convert each DataPenjualan → PenjualanItem
      final List<PenjualanItem> items =
          data.map((dp) => PenjualanItem.fromDataPenjualan(dp)).toList();

      // Group by tanggal
      final Map<String, List<PenjualanItem>> tempMap = {};
      for (final item in items) {
        tempMap.putIfAbsent(item.tanggal, () => []).add(item);

        // Build grouped data
        final List<DataPenjualanByDate> groups = [];
        tempMap.forEach((date, listForThisDate) {
          listForThisDate.sort((a, b) => a.noFaktur.compareTo(b.noFaktur));

          final double dailyTotal = listForThisDate.fold<double>(
            0.0,
            (sum, item) => item.reversal == 1 ? sum : sum + item.totalBayar,
          );

          groups.add(DataPenjualanByDate(
            date: date,
            totalForDate: dailyTotal.toInt(),
            items: listForThisDate,
          ));
        });

        groups.sort((a, b) => b.date.compareTo(a.date));
        groupedPenjualan.value = groups;
      }

      Get.back();
      // Get.back();
    } else {
      print('empty');
      Get.back();
      return [];
    }
  }

  // Toggle for ascending/descending
  RxBool isAsc = false.obs; // default: descending

  void sortAndGroupPenjualan() {
    // 1) Copy penjualan list
    final List<DataPenjualan> data = [...penjualan];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.tanggal!.compareTo(b.tanggal!);
      } else {
        return b.tanggal!.compareTo(a.tanggal!);
      }
    });

    // 3) Update penjualan list
    penjualan.value = data;

    // 4) Rebuild groupedPenjualan
    final List<PenjualanItem> items =
        data.map((dp) => PenjualanItem.fromDataPenjualan(dp)).toList();

    final Map<String, List<PenjualanItem>> tempMap = {};
    for (final item in items) {
      tempMap.putIfAbsent(item.tanggal, () => []).add(item);
    }

    final List<DataPenjualanByDate> groups = [];
    tempMap.forEach((date, listForThisDate) {
      // Sort inside each date group by noFaktur
      listForThisDate.sort((a, b) => a.noFaktur.compareTo(b.noFaktur));

      // Compute daily total
      final double dailyTotal = listForThisDate.fold<double>(
        0.0,
        (sum, item) => item.reversal == 1 ? sum : sum + item.totalBayar,
      );

      groups.add(DataPenjualanByDate(
        date: date,
        totalForDate: dailyTotal.toInt(),
        items: listForThisDate,
      ));
    });

    // 5) Sort groups by date according to toggle
    groups.sort((a, b) {
      if (isAsc.value) {
        return a.date.compareTo(b.date);
      } else {
        return b.date.compareTo(a.date);
      }
    });

    // 6) Update groupedPenjualan
    groupedPenjualan.value = groups;
  }

// Helper: toggle sort order
  void toggleSortPenjualan() {
    isAsc.value = !isAsc.value;
    sortAndGroupPenjualan();
  }

  fetchRiwayatPenjualan({id_toko}) async {
    print(
        '-------------------fetch history central local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT penjualan.*,pelanggan.nama_pelanggan as nama_pelanggan,promo.nama_promo as nama_promo,Karyawan.Nama_Karyawan as nama_karyawan FROM penjualan LEFT JOIN pelanggan ON penjualan.id_pelanggan = pelanggan.uuid LEFT JOIN promo ON penjualan.kode_promo = promo.uuid LEFT JOIN Karyawan ON penjualan.id_karyawan = Karyawan.uuid WHERE penjualan.id_toko = "$id_toko" ORDER BY penjualan.id DESC');
    if (query.isNotEmpty) {
      List<DataPenjualan> data =
          query.map((e) => DataPenjualan.fromJsondb(e)).toList();
      print(data);
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
            (sum, item) => item.reversal == 1 ? sum : sum + item.totalBayar,
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

  var id_toko = GetStorage().read('uuid');
  var kategoriProduk = <DataKategoriProduk>[].obs;
  var produk = <DataProduk>[].obs;
  var subKategoriProduk = <DataSubKategoriProduk>[].obs;
  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var subsearch = TextEditingController().obs;
}

class CentralPromoController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPromo(id_toko: id_toko);
  }

  RxBool isAsc = false.obs;
  void sortPromo() {
    // 1) Copy penjualan list
    final List<DataPromo> data = [...promo];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.namaPromo!.compareTo(b.namaPromo!);
      } else {
        return b.namaPromo!.compareTo(a.namaPromo!);
      }
    });

    // 3) Update penjualan list
    promo.value = data;
  }

// Helper: toggle sort order
  void toggleSortPromo() {
    isAsc.value = !isAsc.value;
    sortPromo();
  }

  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var promo = <DataPromo>[].obs;
  var id_toko = box.read('uuid', fallback: 'null');
  fetchPromo({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM promo WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPromo> data = query.map((e) => DataPromo.fromJsondb(e)).toList();
      promo.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  fetchPromoKasir({id_toko}) async {
    print('-------------------fetch promo local---------------------');

    // Get today's date in YYYY-MM-DD format
    final today = DateTime.now();
    final todayStr = "${today.year.toString().padLeft(4, '0')}-"
        "${today.month.toString().padLeft(2, '0')}-"
        "${today.day.toString().padLeft(2, '0')}";

    // Query: promo not expired (end_date >= today)
    String sql = '''
    SELECT * FROM promo 
    WHERE id_toko = "$id_toko" 
    AND tgl_selesai >= "$todayStr"
  ''';

    List<Map<String, Object?>> query = await DBHelper().FETCH(sql);

    if (query.isNotEmpty) {
      List<DataPromo> data = query.map((e) => DataPromo.fromJsondb(e)).toList();
      promo.value = data;
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  searchPromoLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM promo WHERE id_toko = "$id_toko" AND promo.nama_promo LIKE "%${search}%" ');
    List<DataPromo> jenis = query.isNotEmpty
        ? query.map((e) => DataPromo.fromJsondb(e)).toList()
        : [];
    promo.value = jenis;

    return jenis;
  }
}

class CentralLaporanController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchPromo(id_toko: id_toko);
  }

  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var promo = <DataPromo>[].obs;
  var id_toko = GetStorage().read('uuid');

  deletePromo({uuid}) async {
    print('delete promo local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'promo', id: uuid);
    if (delete == 1) {
      final index = promo.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        promo.removeAt(index);
      }
      await fetchPromo(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }
  }

  fetchPromo({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM promo WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPromo> data = query.map((e) => DataPromo.fromJsondb(e)).toList();
      promo.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return [];
    }
  }
}

class CentralPenerimaanController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchPenerimaanLocal(id_toko: id_toko);
  }

  List<DateTime?> dates = [];
  var pickdate = TextEditingController().obs;
  final dateformat = DateFormat('dd-MM-yyyy');
  var date1;
  var date2;

  RxBool isAsc = false.obs;
  void sortPenerimaan() {
    // 1) Copy penjualan list
    final List<DataPenerimaanProduk> data = [...penerimaan];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.tanggal!.compareTo(b.tanggal!);
      } else {
        return b.tanggal!.compareTo(a.tanggal!);
      }
    });

    // 3) Update penjualan list
    penerimaan.value = data;
  }

// Helper: toggle sort order
  void toggleSortPenerimaan() {
    isAsc.value = !isAsc.value;
    sortPenerimaan();
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;

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
  var penerimaan = <DataPenerimaanProduk>[].obs;

  searchPenerimaanByDateLocal(
      {required String id_toko,
      required String startDate,
      required String endDate,
      bool ascending = true}) async {
    print('-------------------search penerimaan by date---------------------');
    penerimaan.value = [];

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      penerimaan_produk.*, 
      supplier.nama_supplier AS nama_supplier
  FROM 
      penerimaan_produk 
  LEFT JOIN 
      supplier ON penerimaan_produk.id_supplier = supplier.uuid
  WHERE 
      penerimaan_produk.id_toko = "$id_toko"
      AND DATE(penerimaan_produk.tanggal) BETWEEN "$startDate" AND "$endDate"
  ''');

    if (query.isNotEmpty) {
      List<DataPenerimaanProduk> data =
          query.map((e) => DataPenerimaanProduk.fromJsondb(e)).toList();
      penerimaan.value = data;
      data.forEach(
        (element) {
          print(element.tanggal);
        },
      );
      Get.back();

      return data;
    } else {
      Get.back();
      print('No results found between $startDate and $endDate');
      return [];
    }
  }

  fetchPenerimaanLocal({id_toko, bool ascending = true}) async {
    print('-------------------fetch penerimaan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      penerimaan_produk.*, 
      supplier.nama_supplier AS nama_supplier
  FROM 
      penerimaan_produk 
  LEFT JOIN 
     supplier ON penerimaan_produk.id_supplier = supplier.uuid
  WHERE 
      penerimaan_produk.id_toko = "$id_toko"
  
  ''');
    if (query.isNotEmpty) {
      List<DataPenerimaanProduk> data =
          query.map((e) => DataPenerimaanProduk.fromJsondb(e)).toList();
      penerimaan.value = data;
      return data;
    } else {
      print('empty');
      return null;
    }
  }
}

class CentralStockController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchProdukLocal(id_toko: id_toko);
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;

  deletepajak({uuid}) async {
    print('delete pajak local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'pajak_produk', id: uuid);
    if (delete == 1) {
      final index = pajakList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        pajakList.removeAt(index);
      }
      await fetchPajakLocal(id_toko: id_toko);
      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }
  }

  deleteukuran({uuid}) async {
    print('delete pajak local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'ukuran_produk', id: uuid);
    if (delete == 1) {
      final index = ukuranList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        ukuranList.removeAt(index);
      }
      await fetchUkuranLocal(id_toko: id_toko);
      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }
  }

  deleteKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Kelompok_produk', id: uuid);
    if (delete == 1) {
      final index = kategoriProduk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        kategoriProduk.removeAt(index);
      }
      await fetchKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }
  }

  deleteProduk({uuid}) async {
    print('delete produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'produk', id: uuid);

    if (delete == 1) {
      final index = produk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        produk.removeAt(index);
      }

      await fetchProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      print('delete error-------------------');
      print(delete);
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('Error', 'Gagal'));
    }
  }

  deleteSubKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete =
        await DBHelper().DELETE(table: 'Sub_Kelompok_produk', id: uuid);
    if (delete == 1) {
      final index = subKategoriProduk.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        subKategoriProduk.removeAt(index);
      }
      await fetchSubKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
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
  var penerimaan = <DataPenerimaanProduk>[].obs;
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

  fetchPenerimaanLocal({id_toko, bool ascending = true}) async {
    print('-------------------fetch penerimaan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      penerimaan_produk.*, 
      supplier.nama_supplier AS nama_supplier
  FROM 
      penerimaan_produk 
  LEFT JOIN 
     supplier ON penerimaan_produk.id_supplier = supplier.uuid
  WHERE 
      penerimaan_produk.id_toko = "$id_toko"
  
  ''');
    if (query.isNotEmpty) {
      List<DataPenerimaanProduk> data =
          query.map((e) => DataPenerimaanProduk.fromJsondb(e)).toList();
      penerimaan.value = data;
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
}

class CentralBebanController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('id_toko on init--->');
    id_toko = box.read('uuid', fallback: 'null');
    print('id toko --->');
    print(id_toko);
    fetchBeban();
    fetchKategoriBeban();
  }

  var id_toko;
  RxBool isAsc = false.obs;
  List<DateTime?> dates = [];
  var pickdate = TextEditingController().obs;
  final dateformat = DateFormat('dd-MM-yyyy');
  var date1;
  var date2;

  var listBeban = <DataBeban>[].obs;
  var listBebanRutin = <DataBeban>[].obs;
  var listKategoriBeban = <DataKategoriBeban>[].obs;
  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var subsearch = TextEditingController().obs;

  void sortBeban() {
    // 1) Copy penjualan list
    final List<DataBeban> data = [...listBeban];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.tanggalBeban!.compareTo(b.tanggalBeban!);
      } else {
        return b.tanggalBeban!.compareTo(a.tanggalBeban!);
      }
    });

    // 3) Update penjualan list
    listBeban.value = data;
  }

// Helper: toggle sort order
  void toggleSortBeban() {
    isAsc.value = !isAsc.value;
    sortBeban();
  }

  searchBebanByTanggal({
    required String id_toko,
    required String startDate, // format: "2025-08-01"
    required String endDate,
  }) async {
    listBeban.value = [];
    print('-------------------fetch beban by tgl CENTRAL---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        beban.*, 
        kategori_beban.nama_kategori_beban AS kategori_beban,
        karyawan.nama_karyawan as nama_karyawan
    FROM 
        beban 
    LEFT JOIN 
       kategori_beban ON beban.id_kategori_beban = kategori_beban.uuid 
    LEFT JOIN 
       karyawan ON beban.id_karyawan = karyawan.uuid 
    WHERE 
         beban.id_toko = "$id_toko" AND DATE(beban.tanggal_beban) BETWEEN DATE("$startDate") AND DATE("$endDate")
    ORDER BY 
        beban.id DESC
  ''');
    if (query.isNotEmpty) {
      List<DataBeban> data = query.map((e) => DataBeban.fromJsondb(e)).toList();
      listBeban.value = data;
      print('id_toko con');
      print(id_toko);
      Get.back();
      return data;
    } else {
      print('empty');
      print('id_toko con');
      print(id_toko);
      Get.back();
      return null;
    }
  }

  fetchBeban() async {
    print('-------------------fetch pelanggan CENTRAL---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        beban.*, 
        kategori_beban.nama_kategori_beban AS kategori_beban,
        karyawan.nama_karyawan as nama_karyawan
    FROM 
        beban 
    LEFT JOIN 
       kategori_beban ON beban.id_kategori_beban = kategori_beban.uuid 
    LEFT JOIN 
       karyawan ON beban.id_karyawan = karyawan.uuid 
    WHERE 
         beban.id_toko = "$id_toko"
    ORDER BY 
        beban.id DESC
  ''');
    if (query.isNotEmpty) {
      List<DataBeban> data = query.map((e) => DataBeban.fromJsondb(e)).toList();
      listBeban.value = data;
      print('id_toko con');
      print(id_toko);
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      print('id_toko con');
      print(id_toko);
      return null;
    }
  }

  fetchBebanRutin() async {
    print('-------------------fetch BEBAN RUITn CENTRAL---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        beban.*, 
        kategori_beban.nama_kategori_beban AS kategori_beban
    FROM 
        beban 
    LEFT JOIN 
       kategori_beban ON beban.id_kategori_beban = kategori_beban.uuid 
    WHERE 
         beban.id_toko = "$id_toko" AND beban.aktif = 1
    ORDER BY 
        beban.id DESC
  ''');

    if (query.isNotEmpty) {
      List<DataBeban> data = query.map((e) => DataBeban.fromJsondb(e)).toList();

      // ✅ Remove duplicates by `nama_beban`
      final seen = <String, DataBeban>{};
      for (var item in data) {
        if (!seen.containsKey(item.namaBeban)) {
          seen[item.namaBeban!] = item;
        }
      }

      listBebanRutin.value = seen.values.toList();

      print('Filtered beban by name: ${listBebanRutin.length}');
      return listBebanRutin;
    } else {
      print('empty');
      return null;
    }
  }

  fetchKategoriBeban() async {
    print(
        '-------------------fetch kategori beban CENTRAL---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM kategori_beban WHERE id_toko = "$id_toko" ');
    if (query.isNotEmpty) {
      List<DataKategoriBeban> data =
          query.map((e) => DataKategoriBeban.fromJsondb(e)).toList();
      listKategoriBeban.value = data;
      print('id_toko con');
      print(id_toko);
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      print('id_toko con');
      print(id_toko);
      return null;
    }
  }
}

class CentralKategoriProdukController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    id_toko = box.read('uuid', fallback: 'null');
    fetchKategoriProdukLocal(id_toko: id_toko);
    fetchSubKategoriProdukLocal(id_toko: id_toko);
  }

  RxBool isAsc = false.obs;

  void sortKategori() {
    // 1) Copy penjualan list
    final List<DataKategoriProduk> data = [...kategoriProduk];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.namakelompok!.compareTo(b.namakelompok!);
      } else {
        return b.namakelompok!.compareTo(a.namakelompok!);
      }
    });

    // 3) Update penjualan list
    kategoriProduk.value = data;
  }

// Helper: toggle sort order
  void toggleSortkategori() {
    isAsc.value = !isAsc.value;
    sortKategori();
  }

  void sortSubKategori() {
    // 1) Copy penjualan list
    final List<DataSubKategoriProduk> data = [...subKategoriProduk];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.namaSubkelompok!.compareTo(b.namaSubkelompok!);
      } else {
        return b.namaSubkelompok!.compareTo(a.namaSubkelompok!);
      }
    });

    // 3) Update penjualan list
    subKategoriProduk.value = data;
  }

// Helper: toggle sort order
  void toggleSortSubkategori() {
    isAsc.value = !isAsc.value;
    sortSubKategori();
  }

  serachKategoriProdukLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Kelompok_produk WHERE id_toko = "$id_toko" AND Nama_Kelompok LIKE "%${search}%" ');
    List<DataKategoriProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataKategoriProduk.fromJsondb(e)).toList()
        : [];
    kategoriProduk.value = jenis;

    return jenis;
  }

  serachSubKategoriProdukLocal({id_toko, search}) async {
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
    AND Sub_Kelompok_produk.Nama_Sub_Kelompok LIKE "%${search}%"
  ''');
    List<DataSubKategoriProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataSubKategoriProduk.fromJsondb(e)).toList()
        : [];
    subKategoriProduk.value = jenis;

    return jenis;
  }

  var kategoriProduk = <DataKategoriProduk>[].obs;
  var id_toko;
  var subKategoriProduk = <DataSubKategoriProduk>[].obs;
  var searchKategori = TextEditingController().obs;

  var subsearch = TextEditingController().obs;

  fetchKategoriProdukLocal({id_toko}) async {
    print(
        '-------------------fetch kategori central local---------------------');

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
}

class CentralUkuranProdukController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    id_toko = box.read('uuid', fallback: 'null');
    fetchUkuranLocal(id_toko: id_toko);
  }

  var id_toko;
  RxBool isAsc = false.obs;
  void sortUkuran() {
    // 1) Copy penjualan list
    final List<DataUkuranProduk> data = [...ukuranList];

    // 2) Sort penjualan by date
    data.sort((a, b) {
      if (isAsc.value) {
        return a.ukuran!.compareTo(b.ukuran!);
      } else {
        return b.ukuran!.compareTo(a.ukuran!);
      }
    });

    // 3) Update penjualan list
    ukuranList.value = data;
  }

// Helper: toggle sort order
  void toggleSortUkuran() {
    isAsc.value = !isAsc.value;
    sortUkuran();
  }

  var search = TextEditingController().obs;
  var ukuranValue;
  var ukuranList = <DataUkuranProduk>[].obs;

  searchUkuranLocal({id_toko, search}) async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM ukuran_produk WHERE id_toko = "$id_toko" AND ukuran LIKE "%${search}%" ');
    List<DataUkuranProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataUkuranProduk.fromJsondb(e)).toList()
        : [];
    ukuranList.value = jenis;

    return jenis;
  }

  fetchUkuranLocal({id_toko}) async {
    print('-------------------fetch ukuran produk local---------------------');

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
}
