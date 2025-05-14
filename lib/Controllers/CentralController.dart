import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

import '../Database/DB_helper.dart';
import '../Modules/Karyawan/model_karyawan.dart';
import '../Modules/Kasir/model_penjualan.dart';
import '../Modules/Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../Modules/Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';
import '../Modules/Produk/Data produk/model_produk.dart';
import '../Modules/Produk/Kategori/model_subkategoriproduk.dart';
import '../Modules/Produk/Produk/model_kategoriproduk.dart';
import '../Modules/Produk/stock/model_penerimaan.dart';
import '../Modules/Promo/model_promo.dart';
import '../Modules/Supplier/model_supplier.dart';
import '../Widget/widget.dart';

class CentralProdukController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchProdukLocal(id_toko: id_toko);
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

class CentralPaketController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchPaketLocal(id_toko: id_toko);
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

class CentralSupplierController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchSupplierLocal(id_toko: id_toko);
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
  var search = TextEditingController().obs;

  serachSupplierLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Supplier WHERE id_toko = "$id_toko" AND Nama_Supplier LIKE "%${search.value.text}%" ');
    List<DataSupplier> jenis = query.isNotEmpty
        ? query.map((e) => DataSupplier.fromJsondb(e)).toList()
        : [];
    supplierList.value = jenis;

    return jenis;
  }

  fetchSupplierLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Supplier WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataSupplier> data =
          query.map((e) => DataSupplier.fromJsondb(e)).toList();
      supplierList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }
}

class CentralKaryawanController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchKaryawanLocal(id_toko: id_toko);
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
  var search = TextEditingController().obs;

  searchKaryawanLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Karyawan WHERE id_toko = "$id_toko" AND Nama_Karyawan LIKE "%${search.value.text}%" ');
    List<DataKaryawan> jenis = query.isNotEmpty
        ? query.map((e) => DataKaryawan.fromJsondb(e)).toList()
        : [];
    karyawanList.value = jenis;

    return jenis;
  }

  fetchKaryawanLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Karyawan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKaryawan> data =
          query.map((e) => DataKaryawan.fromJsondb(e)).toList();
      karyawanList.value = data;
      //logo.value = userList.value.first.logo!;
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
    await fetchPelangganLocal(id_toko: id_toko);
    await fetchKategoriPelangganLocal(id_toko);
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
  var kategoripelangganList = <DataKategoriPelanggan>[].obs;
  serachPelangganLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        pelanggan.*, 
        kategori_pelanggan.kategori AS kategori_nama
    FROM 
        pelanggan 
    LEFT JOIN 
        kategori_pelanggan ON pelanggan.ID_Kategori = kategori_pelanggan.uuid 
    WHERE 
        pelanggan.id_toko = "$id_toko" AND pelanggan.nama_pelanggan LIKE "%${search.value.text}%"
  ''');
    List<DataPelanggan> jenis = query.isNotEmpty
        ? query.map((e) => DataPelanggan.fromJsondb(e)).toList()
        : [];
    pelangganList.value = jenis;

    return jenis;
  }

  fetchPelangganLocal({id_toko}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        pelanggan.*, 
        kategori_pelanggan.kategori AS kategori_nama
    FROM 
        pelanggan 
    LEFT JOIN 
        kategori_pelanggan ON pelanggan.ID_Kategori = kategori_pelanggan.uuid 
    WHERE 
        pelanggan.id_toko = "$id_toko"
  ''');
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

  fetchKategoriPelangganLocal(id_toko) async {
    print(
        '-------------------fetch kategori pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM kategori_pelanggan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKategoriPelanggan> data =
          query.map((e) => DataKategoriPelanggan.fromJsondb(e)).toList();
      kategoripelangganList.value = data;
      //logo.value = userList.value.first.logo!;
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
    await fetchRiwayatPenjualan(id_toko: id_toko);
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
  var penjualan = <DataPenjualan>[].obs;

  fetchRiwayatPenjualan({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM penjualan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPenjualan> data =
          query.map((e) => DataPenjualan.fromJsondb(e)).toList();
      penjualan.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
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

class CentralPromoController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
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
