import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Config/config.dart';
import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
import '../Beban/model_beban_laporan.dart';
import 'model_reversal_laporan.dart';
import 'package:pdf/widgets.dart' as pw;

class ReversalLaporanController extends GetxController {
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
  var tanggalBebanIso = DateFormat('yyyy-MM-dd');
  var date1;
  var date2;
  var id_toko = GetStorage().read('uuid');

  var summaryReversal = <ReversalReportSummary>[].obs;
  var summaryDetailReversal = <ReversalDetail>[].obs;
  var total_transaksi = 0.obs;
  var total_penjualan = 0.0.obs;
  var total_keuntungan = 0.0.obs;
  var produk_terjual = 0.obs;

  String DateISO(DateTime date) {
    // Get the current date
    DateTime now = date;

    // Format the date as "YYYY-MM-DD"
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  Future<void> fetchReportReversal({
    required String idToko,
    required DateTime dateFrom, // as DateTime
    required DateTime dateTo, // as DateTime
  }) async {
    // 1) format your DateTimes to 'YYYY-MM-DD' strings:
    final df = DateFormat('yyyy-MM-dd');
    final fromStr = df.format(dateFrom);
    final toStr = df.format(dateTo);

    // 2) build the SQL (you could also use '?' placeholders + args):
    final sql = '''
    SELECT
    DATE(tanggal)                AS tanggal,
    COUNT(*)                     AS count_reversal,
    COALESCE(SUM(total_bayar),0) AS total_reversed_value
    FROM penjualan
WHERE reversal = 1
  AND id_toko = '$idToko'
  AND DATE(tanggal) BETWEEN '$fromStr' AND '$toStr'
GROUP BY DATE(tanggal)
ORDER BY DATE(tanggal) DESC;
  ''';

    // debug
    print('reversal Report SQL: $sql');

    // 3) fetch a List<Map<String,Object?>>
    final List<Map<String, Object?>> raw = await DBHelper().FETCH(sql);
    print('RAW rows: $raw');

    // 4) map each row into your model
    final List<ReversalReportSummary> report = raw.map((row) {
      return ReversalReportSummary.fromJsondb(row);
    }).toList();

    // 5) update your observable list
    summaryReversal.value = report;
  }

  Future<void> fetchReportDetailReversal({
    required String idToko,
    required DateTime dateFrom, // as DateTime
    required DateTime dateTo, // as DateTime
  }) async {
    // 1) format your DateTimes to 'YYYY-MM-DD' strings:
    final df = DateFormat('yyyy-MM-dd');
    final fromStr = df.format(dateFrom);
    final toStr = df.format(dateTo);

    // 2) build the SQL (you could also use '?' placeholders + args):
    final sql = '''
    SELECT
      uuid,
      no_faktur,
      tanggal,
      id_karyawan,
      total_bayar
    FROM
    penjualan
    WHERE 
    reversal = 1
  AND id_toko = '$idToko'
  AND DATE(tanggal) BETWEEN '$fromStr' AND '$toStr'
ORDER BY tanggal DESC;
  ''';

    // debug
    print('reversal Detailed Report SQL: $sql');

    // 3) fetch a List<Map<String,Object?>>
    final List<Map<String, Object?>> raw = await DBHelper().FETCH(sql);
    print('RAW rows: $raw');

    // 4) map each row into your model
    final List<ReversalReportSummary> report = raw.map((row) {
      return ReversalReportSummary.fromJsondb(row);
    }).toList();

    // 5) update your observable list
    summaryReversal.value = report;
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

  Future<void> createPDF({
    required List<ReversalReportSummary> summaryList,
    required String date1,
    required String date2,
  }) async {
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

    // 2) Group summaries by yyyy-MM-dd
    final dfKey = DateFormat('yyyy-MM-dd');
    final Map<String, List<ReversalReportSummary>> byDate = {};
    for (final rpt in summaryList) {
      final key = dfKey.format(rpt.tanggal);
      byDate.putIfAbsent(key, () => []).add(rpt);
    }
    final sortedDates = byDate.keys.toList()..sort((a, b) => b.compareTo(a));

    // 3) Build PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          // --- HEADER ---
          pw.Center(child: pw.Image(logoImage, height: 50, width: 50)),
          pw.SizedBox(height: 12),
          pw.Center(
            child: pw.Text(
              'Laporan Reversal',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Center(
            child: pw.Text(
              '$date1 – $date2',
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
            ),
          ),
          pw.Divider(height: 32, thickness: 0.5),

          // --- BODY: per day ---
          for (final dateKey in sortedDates) ...[
            // 3a) Date header
            pw.Text(
              DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(dateKey)),
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),

            // 3b) For each summary record on that date
            for (final rpt in byDate[dateKey]!) ...[
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
                          child: pw.Text('reversal: ${rpt.countReversal}')),
                      pw.Expanded(
                          child: pw.Text(
                              'total reversal: ${AppFormat().moneyFormat(rpt.totalReversedValue)}')),
                    ]),
                    pw.Divider(),
                  ],
                ),
              ),
            ],
          ],

          // --- FOOTER ---
          pw.Spacer(),
          pw.Center(
            child: pw.Text(
              '<-------------------------------- TubinMart -------------------------------->',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ),
        ],
      ),
    );

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
}
