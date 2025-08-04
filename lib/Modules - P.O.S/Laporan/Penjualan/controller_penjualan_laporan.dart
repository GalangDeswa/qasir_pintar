import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir/model_penjualan.dart';

import '../../../Config/config.dart';
import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
import '../Beban/model_beban_laporan.dart';
import 'model_penjualan_laporan.dart';

class PenjualanLaporanController extends GetxController {
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
  var dataPenjualan = <DataPenjualan>[].obs;
  var dataDetailPenjualan = <DataDetailPenjualan>[].obs;

  var summaryPenjualan = <SalesReport>[].obs;
  var total_transaksi = 0.obs;
  var total_penjualan = 0.0.obs;
  var total_keuntungan = 0.0.obs;
  var produk_terjual = 0.obs;
  var summaryByProduct = <ProductSalesReport>[].obs;

  String DateISO(DateTime date) {
    // Get the current date
    DateTime now = date;

    // Format the date as "YYYY-MM-DD"
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  // 1) Your combined SQL (in your repository method)
  Future<List<SalesReport>> fetchFullPenjualanReport({
    required String idToko,
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async {
    final df = DateFormat('yyyy-MM-dd');
    final fromStr = df.format(dateFrom);
    final toStr = df.format(dateTo);

    final sql = '''
  WITH
    summary AS (
      SELECT
        p.uuid                                         AS uuid,
        DATE(p.tanggal)                                AS tanggal,
        COUNT(p.uuid)                                  AS total_transactions,
        COALESCE(SUM(p.total_qty),      0)             AS total_items_sold,
        COALESCE(SUM(p.subtotal),       0)             AS sum_subtotal,
        COALESCE(SUM(p.total_diskon),   0)             AS sum_discount,
        COALESCE(SUM(p.total_pajak),    0)             AS sum_tax,
        COALESCE(SUM(p.total_bayar),    0)             AS sum_revenue,
        COALESCE(SUM(p.nilai_promo),    0)             AS sum_promo
      FROM penjualan p
      WHERE p.id_toko = '$idToko'
        AND DATE(p.tanggal) BETWEEN '$fromStr' AND '$toStr'
      GROUP BY DATE(p.tanggal)
    ),
    detail AS (
      SELECT
        DATE(p.tanggal)                                AS tanggal,
        x.nama_produk                                  AS nama_produk,
        y.nama_paket                                  AS nama_paket,
        d.id_produk                                    AS id_produk,
        d.id_paket                                      AS id_paket,
        d.subtotal                                      AS subtotal,
        COALESCE(SUM(d.qty),         0)                AS product_qty,
        COALESCE(SUM(d.total_harga), 0)                AS product_sales
      FROM penjualan p
      JOIN detail_penjualan d
        ON p.uuid = d.id_penjualan
      LEFT JOIN produk x
        ON x.uuid = d.id_produk
      LEFT JOIN paket_produk y
        ON y.uuid = d.id_paket
      WHERE p.id_toko = '$idToko'
        AND DATE(p.tanggal) BETWEEN '$fromStr' AND '$toStr'
      GROUP BY DATE(p.tanggal), d.id_produk
    )
  SELECT
    s.uuid,
    s.tanggal,
    s.total_transactions,
    s.total_items_sold,
    s.sum_subtotal,
    s.sum_discount,
    s.sum_tax,
    s.sum_revenue,
    s.sum_promo,
    d.nama_produk,
    d.nama_paket,
    d.id_paket,
    d.subtotal,
    d.id_produk,
    d.product_qty   AS qty,
    d.product_sales AS total_sales
  FROM summary s
  LEFT JOIN detail d
    ON s.tanggal = d.tanggal
  ORDER BY s.tanggal DESC;
  ''';

    final raw = await DBHelper().FETCH(sql);

    // 2) group rows by tanggal
    final Map<String, SalesReport> buffer = {};

    for (final r0 in raw) {
      final row = r0.cast<String, dynamic>();
      final dateKey = row['tanggal'] as String;
      final uuid = row['uuid'];
      //
      // List<DataPenjualan> penjualan =
      //     await fetchRiwayatPenjualan(id_toko: idToko);
      //
      // var filterP = penjualan.where((x) => x.tanggal == dateKey).toList();
      // dataPenjualan.value = filterP;
      // List<DataDetailPenjualan> detail =
      //     await fetchDetailRiwayat(id_toko: idToko, id_penjualan: uuid);
      // dataDetailPenjualan.value = detail;

      print(
          'FILTER P --------------------------------------------------------;');
      print(dataPenjualan);
      print('detail --------------------------------------------------------;');
      print(dataDetailPenjualan);

      // create the SalesReport once per date
      final parent = buffer.putIfAbsent(dateKey, () {
        return SalesReport(
          uuid: (row['uuid'] as String),
          tanggal: DateTime.parse(dateKey),
          totalTransactions: (row['total_transactions'] as num).toInt(),
          totalItemsSold: (row['total_items_sold'] as num).toInt(),
          sumSubtotal: (row['sum_subtotal'] as num).toDouble(),
          sumDiscount: (row['sum_discount'] as num).toDouble(),
          sumTax: (row['sum_tax'] as num).toDouble(),
          sumRevenue: (row['sum_revenue'] as num).toDouble(),
          sumPromo: (row['sum_promo'] as num).toDouble(),
          details: [],
        );
      });

      // for each non-null product row, add a detail entry
      if (row['id_paket'] != null) {
        print('this is packet');
        parent.details.add(
          ProductSalesReport(
            idPaket: row['id_paket'] as String,
            namaPaket: row['nama_paket'] as String,
            totalQty: (row['qty'] as num).toInt(),
            totalSales: (row['total_sales'] as num).toDouble(),
            subtotal: (row['subtotal'] as num).toDouble(),
          ),
        );
      } else {
        print('this is product');
        parent.details.add(
          ProductSalesReport(
            idProduk: row['id_produk'] as String,
            namaProduk: row['nama_produk'] as String,
            totalQty: (row['qty'] as num).toInt(),
            totalSales: (row['total_sales'] as num).toDouble(),
            subtotal: (row['subtotal'] as num).toDouble(),
          ),
        );
      }
    }

    print(raw);
    summaryPenjualan.value = buffer.values.toList();
    return buffer.values.toList();
  }

  Future<List<SalesReport>> laporanv2({
    required String idToko,
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async {
    final df = DateFormat('yyyy-MM-dd');
    final fromStr = df.format(dateFrom);
    final toStr = df.format(dateTo);

    // 1) Fetch ALL sales (with pelanggan/promo/karyawan joins) in the date range
    final allSales = await fetchRiwayatPenjualan(
          id_toko: idToko,
          from: fromStr,
          to: toStr,
        ) ??
        [];

    // 1b) Fetch ALL detail_penjualan in the same date range
    final allDetails = await fetchDetailRiwayat(
          id_toko: idToko,
        ) ??
        [];

    // 2) Group sales by the 'yyyy-MM-dd' string
    final salesByDate = groupBy<DataPenjualan, String>(
      allSales,
      (sale) => sale.tanggal!,
    );

    // 3) Build your reports
    final reports = <SalesReport>[];
    for (var dateKey in salesByDate.keys) {
      final salesOnThatDay = salesByDate[dateKey]!;

      // Collect UUIDs of all sales on this date
      final uuidsOnThatDay = salesOnThatDay.map((s) => s.uuid).toSet();
      dataPenjualan.value = salesOnThatDay;

      // Post-filter: grab only those detail rows whose id_penjualan matches one of today's sales
      final detailsOnThatDay = allDetails
          .where((d) => uuidsOnThatDay.contains(d.idPenjualan))
          .toList();
      dataDetailPenjualan.value = detailsOnThatDay;

      print('PENJUALANTGL INI____________________________');
      print(dataPenjualan);
      print('DETAIL TGL INI____________________________');
      print(dataDetailPenjualan);

      // Build the summary for this date by re-running your CTE logic (or store it earlier)
      // For brevity, let's assume you have a helper that gives you the precomputed summary row:
      final summary = await fetchSummaryForDate(
        idToko: idToko,
        date: dateKey,
      );

      // Create the SalesReport object
      final report = SalesReport(
        uuid: summary.uuid,
        tanggal: DateTime.parse(dateKey),
        totalTransactions: summary.totalTransactions,
        totalItemsSold: summary.totalItemsSold,
        sumSubtotal: summary.sumSubtotal,
        sumDiscount: summary.sumDiscount,
        sumTax: summary.sumTax,
        sumRevenue: summary.sumRevenue,
        sumPromo: summary.sumPromo,
        details: [],
      );

      // Attach each detail row
      for (var d in detailsOnThatDay) {
        report.details.add(
          ProductSalesReport(
            idProduk: d.idProduk,
            namaProduk: d.nama_produk,
            totalQty: d.qty,
            totalSales: d.totalHarga,
            subtotal: d.subtotal,
            namaPaket: d.namaPaket,
            idPaket: d.idPaket,
          ),
        );
      }

      reports.add(report);
    }
    summaryPenjualan.value = reports;
    return reports;
  }

  Future<SummaryRow> fetchSummaryForDate({
    required String idToko,
    required String date,
  }) async {
    final sql = '''
    SELECT
      uuid,
      COUNT(uuid)        AS totalTransactions,
      SUM(total_qty)     AS totalItemsSold,
      SUM(subtotal)      AS sumSubtotal,
      SUM(total_diskon)  AS sumDiscount,
      SUM(total_pajak)   AS sumTax,
      SUM(total_bayar)   AS sumRevenue,
      SUM(nilai_promo)   AS sumPromo
    FROM penjualan
    WHERE id_toko = '$idToko'
      AND DATE(tanggal) = '$date'
    GROUP BY DATE(tanggal)
  ''';

    final row = (await DBHelper().FETCH(sql)).first;
    return SummaryRow.fromMap(row);
  }

  fetchRiwayatPenjualan({id_toko, from, to}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT penjualan.*,pelanggan.nama_pelanggan as nama_pelanggan,promo.nama_promo as nama_promo,Karyawan.Nama_Karyawan as nama_karyawan FROM penjualan LEFT JOIN pelanggan ON penjualan.id_pelanggan = pelanggan.uuid LEFT JOIN promo ON penjualan.kode_promo = promo.uuid LEFT JOIN Karyawan ON penjualan.id_karyawan = Karyawan.uuid WHERE penjualan.id_toko = "$id_toko" AND DATE(tanggal) BETWEEN "$from" AND "$to" AND penjualan.reversal = 0');
    if (query.isNotEmpty) {
      List<DataPenjualan> data =
          query.map((e) => DataPenjualan.fromJsondb(e)).toList();
      //dataPenjualan.value = data;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchDetailRiwayat({id_toko}) async {
    print('-------------------fetch detail riwayat local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
     detail_penjualan.*, 
     produk.nama_produk AS nama_produk,
     produk.harga_jual_eceran AS harga_jual_eceran,
     paket_produk.nama_paket AS nama_paket
   
  FROM 
      detail_penjualan 
  LEFT JOIN 
     produk ON detail_penjualan.id_produk = produk.uuid
  LEFT JOIN 
     paket_produk ON detail_penjualan.id_paket = paket_produk.uuid
  WHERE 
      detail_penjualan.id_toko = "$id_toko"

  ''');
    if (query.isNotEmpty) {
      List<DataDetailPenjualan> data =
          query.map((e) => DataDetailPenjualan.fromJsondb(e)).toList();
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  pw.Widget _buildPdfDetailRow(String title, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
      ],
    );
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
    required List<SalesReport> summaryList,
    required List<DataPenjualan> transaksiList,
    required List<DataDetailPenjualan> detailList,
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
    final Map<String, List<SalesReport>> byDate = {};
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
              'Laporan Penjualan',
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
                          child: pw.Text(
                              'total penjualan: ${AppFormat().moneyFormat(rpt.sumRevenue)}')),
                      pw.Expanded(
                          child:
                              pw.Text('totalItemsSold: ${rpt.totalItemsSold}')),
                      // pw.Expanded(
                      //     child: pw.Text('sumSubtotal: ${rpt.sumSubtotal}')),
                    ]),
                    pw.Row(children: [
                      pw.Expanded(
                          child: pw.Text(
                              'total pajak: ${AppFormat().moneyFormat(rpt.sumTax)}')),
                      pw.Expanded(
                          child: pw.Text(
                              'total diskon: ${AppFormat().moneyFormat(rpt.sumDiscount)}')),
                    ]),
                    pw.Divider(),

                    pw.Row(children: [
                      pw.Expanded(
                          child: pw.Text(
                              'total promo: ${AppFormat().moneyFormat(rpt.sumPromo)}')),
                    ]),

                    // produk details
                    pw.SizedBox(height: 8),
                    pw.Text('Produk:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Table.fromTextArray(
                      headers: ['Nama Produk', 'Qty', 'Subtotal'],
                      data: rpt.details
                          .map((d) => [
                                d.namaProduk ?? d.namaPaket!,
                                d.totalQty.toString(),
                                AppFormat().moneyFormat(d.subtotal),
                              ])
                          .toList(),
                      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      cellAlignment: pw.Alignment.centerLeft,
                    ),

                    // transaction details
                    pw.SizedBox(height: 10),
                    pw.Text('Detail Transaksi:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Divider(),

                    for (final trx in transaksiList) ...[
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('No. Faktur: ${trx.noFaktur}'),
                          pw.Text('Kasir: ${trx.id_karyawan ?? ''}'),
                          pw.Text('Tanggal: ${trx.tanggal}'),
                          if (trx.idPelanggan != null &&
                              trx.idPelanggan!.isNotEmpty)
                            pw.Text('Pelanggan: ${trx.namaPelanggan}'),
                          // nested detail table
                          pw.Table.fromTextArray(
                            headers: ['Produk', 'Qty', 'Subtotal'],
                            data: detailList
                                .where((d) => d.idPenjualan == trx.uuid)
                                .map((d) => [
                                      d.nama_produk ?? d.namaPaket!,
                                      d.qty.toString(),
                                      AppFormat().moneyFormat(d.subtotal),
                                    ])
                                .toList(),
                            headerStyle:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            cellAlignment: pw.Alignment.centerLeft,
                          ),
                          pw.SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],

          // --- FOOTER ---
          pw.Spacer(),
          pw.Center(
            child: pw.Text(
              '<-------------------------------- qasir pintar -------------------------------->',
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
