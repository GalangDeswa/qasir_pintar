import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';

import '../../Database/DB_helper.dart';
import '../../Widget/widget.dart';
import '../Kasir/model_penjualan.dart';
import '../Produk/Data produk/model_produk.dart';
import '../Produk/Kategori/model_subkategoriproduk.dart';
import '../Produk/Produk/model_kategoriproduk.dart';

class HistoryPenjualanController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('history controller init-->');
    await Get.find<CentralHistoryController>()
        .fetchRiwayatPenjualan(id_toko: id_toko);
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
  var penjualan = <DataPenjualan>[].obs;
  var groupedPenjualan = <DataPenjualanByDate>[].obs;

  // fetchRiwayatPenjualan({id_toko}) async {
  //   print('-------------------fetch produk local---------------------');
  //
  //   List<Map<String, Object?>> query = await DBHelper().FETCH(
  //       'SELECT penjualan.*,pelanggan.nama_pelanggan as nama_pelanggan,promo.nama_promo as nama_promo,Karyawan.Nama_Karyawan as nama_karyawan FROM penjualan LEFT JOIN pelanggan ON penjualan.id_pelanggan = pelanggan.uuid LEFT JOIN promo ON penjualan.kode_promo = promo.uuid LEFT JOIN Karyawan ON penjualan.id_karyawan = Karyawan.uuid WHERE penjualan.id_toko = "$id_toko" ORDER BY penjualan.id DESC');
  //   if (query.isNotEmpty) {
  //     List<DataPenjualan> data =
  //         query.map((e) => DataPenjualan.fromJsondb(e)).toList();
  //     penjualan.value = data;
  //     // 3) Convert each DataPenjualan → PenjualanItem
  //     final List<PenjualanItem> items =
  //         data.map((dp) => PenjualanItem.fromDataPenjualan(dp)).toList();
  //     // 4) Group by tanggal (String key)
  //     final Map<String, List<PenjualanItem>> tempMap = {};
  //     for (final item in items) {
  //       tempMap.putIfAbsent(item.tanggal, () => []).add(item);
  //       // 5) Build a List<PenjualanByDate> from that map
  //       final List<DataPenjualanByDate> groups = [];
  //       tempMap.forEach((date, listForThisDate) {
  //         // Sort the transactions however you like. Since there is no “waktu,”
  //         // we can just leave them in insertion order, or sort by noFaktur:
  //         listForThisDate.sort((a, b) => a.noFaktur.compareTo(b.noFaktur));
  //
  //         // Compute daily total:
  //         final double dailyTotal = listForThisDate.fold<double>(
  //           0.0,
  //           (sum, item) => item.reversal == 1 ? sum : sum + item.totalBayar,
  //         );
  //
  //         groups.add(DataPenjualanByDate(
  //           date: date,
  //           totalForDate: dailyTotal.toInt(),
  //           items: listForThisDate,
  //         ));
  //       });
  //
  //       // 6) Sort the date‐groups descending, so the newest date appears first
  //       groups.sort((a, b) => b.date.compareTo(a.date));
  //
  //       groupedPenjualan.value = groups;
  //     }
  //   } else {
  //     print('empty');
  //     return null;
  //   }
  // }

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
}
