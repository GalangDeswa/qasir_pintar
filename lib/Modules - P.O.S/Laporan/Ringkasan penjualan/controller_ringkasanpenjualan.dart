import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../Database/DB_helper.dart';
import 'model_ringkasan_penjualan.dart';

class RingkasanPenjualanController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  var tanggal = TextEditingController().obs;
  List<DateTime?> datedata = [
    //DateTime.now(),
  ];
  List<DateTime?> dates = [];
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  stringdate() {
    var ff = dateFormat.format(datedata.first!);
    tanggal.value.text = ff;
  }

  var pickdate = TextEditingController().obs;
  final dateformat = DateFormat('dd-MM-yyyy');
  var date1;
  var date2;
  var id_toko = GetStorage().read('uuid');

  var summary = <ReportSummary>[].obs;
  var total_transaksi = 0.obs;
  var total_penjualan = 0.0.obs;
  var total_keuntungan = 0.0.obs;
  var produk_terjual = 0.obs;
//TODO : Kunci kasir, karyawan harus login
  /// Fetch summary report for a given store (idToko)
  Future<ReportSummary?> fetchReport({
    required String idToko,
    required String dateFrom, // format: 'YYYY-MM-DD'
    required String dateTo, // format: 'YYYY-MM-DD'
  }) async {
    // Aggregate SQL
    String sql = '''
      SELECT
        COUNT(DISTINCT t.uuid)                                                    AS total_transaksi,
        COALESCE(SUM(td.qty * CAST(COALESCE(p.harga_jual_eceran, '0') AS REAL)), 0)      AS total_penjualan,
        COALESCE(SUM(td.qty * (CAST(COALESCE(p.harga_jual_eceran, '0') AS REAL)
                         - CAST(COALESCE(p.harga_beli, '0') AS REAL))), 0)            AS total_keuntungan,
        COALESCE(SUM(td.qty), 0)                                                  AS produk_terjual
      FROM penjualan t
      INNER JOIN detail_penjualan td ON t.uuid = td.id_penjualan
      INNER JOIN produk p ON td.id_produk = p.uuid
      WHERE t.id_toko = "$idToko"
        AND DATE(t.tanggal) BETWEEN "$dateFrom" AND "$dateTo"
    ''';

    // Debug: log SQL and detailed breakdown per line
    print('Report SQL: $sql');
    String detailSql = '''
      SELECT
        td.qty,
        p.harga_jual_eceran AS jual,
        p.harga_beli AS beli,
        td.qty * CAST(COALESCE(p.harga_jual_eceran, '0') AS REAL) AS line_penjualan,
        td.qty * (CAST(COALESCE(p.harga_jual_eceran, '0') AS REAL)
                  - CAST(COALESCE(p.harga_beli, '0') AS REAL)) AS line_keuntungan
      FROM penjualan t
      INNER JOIN detail_penjualan td ON t.uuid = td.id_penjualan
      INNER JOIN produk p ON td.id_produk = p.uuid
      WHERE t.id_toko = "$idToko"
        AND DATE(t.tanggal) BETWEEN "$dateFrom" AND "$dateTo"
    ''';
    final detailRows = await DBHelper().FETCH(detailSql);
    print('Detail Rows: $detailRows');

    // Fetch aggregate
    List<Map<String, Object?>> result = await DBHelper().FETCH(sql);
    if (result.isNotEmpty) {
      final report = ReportSummary.fromJsondb(result.first);
      summary.add(report);
      print('Laporan Summary: $report');
      print(report.totalKeuntungan);
      return report;
    }
    print('No data found for the given date range.');
    return null;
  }
}
