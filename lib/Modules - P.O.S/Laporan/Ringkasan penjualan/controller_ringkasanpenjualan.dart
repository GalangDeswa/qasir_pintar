import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
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
  var netProfit = 0.0.obs;

  /// Fetch summary report for a given store (idToko)
  Future<ReportSummary?> fetchReport({
    required String idToko,
    required DateTime dateFrom, // format: 'YYYY-MM-DD'
    required DateTime dateTo, // format: 'YYYY-MM-DD'
  }) async {
    final df = DateFormat('yyyy-MM-dd');
    final fromStr = df.format(dateFrom);
    final toStr = df.format(dateTo);
    // Aggregate SQL
    String sql = '''
  SELECT
    COUNT(DISTINCT t.uuid) AS total_transaksi,
    COALESCE(SUM(td.qty * CAST(COALESCE(p.harga_jual_eceran, '0') AS REAL)), 0) AS total_penjualan,
    COALESCE(SUM(td.qty * (CAST(COALESCE(p.harga_jual_eceran, '0') AS REAL) - CAST(COALESCE(p.harga_beli, '0') AS REAL))), 0) AS total_keuntungan,
    COALESCE(SUM(td.qty), 0) AS produk_terjual,

    (
      SELECT COALESCE(SUM(b.jumlah_beban), 0)
      FROM beban b
      WHERE b.id_toko = "$idToko" AND b.aktif = 1
        AND DATE(b.tanggal_beban) BETWEEN "$fromStr" AND "$toStr"
    ) AS total_jumlah_beban,

    (
      SELECT COUNT(DISTINCT b.uuid)
      FROM beban b
      WHERE b.id_toko = "$idToko" AND b.aktif = 1
        AND DATE(b.tanggal_beban) BETWEEN "$fromStr" AND "$toStr"
    ) AS total_beban

  FROM penjualan t
  INNER JOIN detail_penjualan td ON t.uuid = td.id_penjualan
  INNER JOIN produk p ON td.id_produk = p.uuid
  WHERE t.id_toko = "$idToko"
    AND DATE(t.tanggal) BETWEEN "$fromStr" AND "$toStr" AND t.reversal = 0
''';

    // Fetch aggregate
    List<Map<String, Object?>> result = await DBHelper().FETCH(sql);
    if (result.isNotEmpty) {
      final report = ReportSummary.fromJsondb(result.first);
      summary.add(report);
      netProfit.value = report.totalKeuntungan - report.totalJumlahBeban;
      print('Laporan Summary: $report');
      print(report.totalTransaksi);
      return report;
    }
    print('No data found for the given date range.');
    return null;
  }

  Future<void> createPDF() async {
    final ok = await _ensureStoragePermission();
    if (!ok) {
      Get.back();
      Get.snackbar('Permission required',
          'Please grant "All files access" in Settings to save PDFs.');
      return;
    }
    Get.dialog(showloading(), barrierDismissible: false);

    // 1) Load logo
    final logoData = await rootBundle.load('assets/icons/splash.png');
    final logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);
    final df = DateFormat('yyyy-MM-dd');
    final fromStr = df.format(date1);
    final toStr = df.format(date2);

    // 3) Build PDF
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
              // --- HEADER ---
              pw.Center(child: pw.Image(logoImage, height: 50, width: 50)),
              pw.SizedBox(height: 12),
              pw.Center(
                child: pw.Text(
                  'Laporan Umum',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  '$fromStr – $toStr',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                ),
              ),
              pw.Divider(height: 32, thickness: 0.5),

              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                margin: const pw.EdgeInsets.only(bottom: 16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // summary rows
                    pw.Row(children: [
                      pw.Expanded(
                          child: pw.Text(
                              'total penjualan: ${summary.first.totalPenjualan}')),
                      pw.Expanded(
                          child: pw.Text(
                              'total keuntungan: ${summary.first.totalKeuntungan}')),
                    ]),
                    pw.Divider(),
                    pw.Row(children: [
                      pw.Expanded(
                          child: pw.Text(
                              'total transaksi: ${summary.first.totalTransaksi}')),
                      pw.Expanded(
                          child: pw.Text(
                              'total produk: ${summary.first.totalProdukTerjual}')),
                    ]),
                    pw.Divider(),
                    pw.Row(children: [
                      pw.Expanded(
                          child: pw.Text(
                              'total beban: ${summary.first.totalBeban}')),
                      pw.Expanded(
                          child: pw.Text(
                              'total jumlah beban: ${summary.first.totalJumlahBeban}')),
                    ]),
                    pw.Divider(),
                    pw.Row(children: [
                      pw.Expanded(
                          child: pw.Text('net profit: ${netProfit.value}')),
                    ]),
                    pw.Divider(),
                    // --- FOOTER ---

                    pw.Center(
                      child: pw.Text(
                        '<-------------------------------- TubinMart -------------------------------->',
                        style:
                            pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                      ),
                    ),
                  ],
                ),
              )
            ]));

    // Get downloads directory
    final Directory? downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      print("Could not access downloads directory");
      return;
    }

    // Create subdirectory path
    final String subDirPath =
        '/storage/emulated/0/Download/qasir_pintar/laporan/penjualan';
    final Directory subDir = Directory(subDirPath);

    // Create directory if it doesn't exist
    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }

    // Create file
    String filename = 'Laporan penjualan';
    ;
    final File file = File('${subDir.path}/$filename.pdf');

    // Save PDF
    await file.writeAsBytes(await pdf.save());
    print('PDF saved to: ${file.path}');
    Get.back(closeOverlays: true);
    openPDF(file.path);
  }

  dir() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    new Directory(appDocDirectory.path + '/' + 'pdf')
        .create(recursive: true)
// The created directory is returned as a Future.
        .then((Directory directory) {
      print('Path of New Dir: ' + directory.path);
    });
  }

  openPDF(path) {
    OpenFilex.open(path);
  }

  Future<bool> _ensureStoragePermission() async {
    if (Platform.isAndroid) {
      // On Android 11+ we need MANAGE_EXTERNAL_STORAGE
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      // Prompt the special "All files access" dialog:
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;

      // If still not granted, send user to Settings page:
      await openAppSettings();
      return false;
    } else {
      // iOS/macOS flow if you need it (probably not)
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }
}
