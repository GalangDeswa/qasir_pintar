import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';

import '../../../../Widget/widget.dart';
import '../../Data produk/model_produk.dart';

class DetailStockController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  DataProduk data = Get.arguments;

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

  Future<void> createPDF(DataProduk produk) async {
    Get.dialog(showloading(), barrierDismissible: false);
    final pdf = pw.Document();
    final ByteData logoData = await rootBundle.load('assets/icons/splash.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logo = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(25),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(child: pw.Image(logo, height: 50, width: 50)),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('Stock barang - ' + produk.nama_produk!,
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Divider(height: 20, thickness: 0.5),
              pw.SizedBox(height: 20),

              // Report Date
              pw.Text(
                  'Tanggal laporan : ${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 30),

              // Product Details
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  children: [
                    _buildPdfDetailRow('Nama produk:', produk.nama_produk!),
                    pw.Divider(height: 20, thickness: 0.5),
                    _buildPdfDetailRow(
                        'Kode produk:',
                        produk.kode_produk?.isNotEmpty == true
                            ? produk.kode_produk!
                            : '-'),
                    pw.Divider(height: 20, thickness: 0.5),
                    _buildPdfDetailRow('Harga beli:',
                        'Rp ${NumberFormat('#,###').format(produk.harga_beli)}'),
                    pw.Divider(height: 20, thickness: 0.5),
                    _buildPdfDetailRow('Stock:',
                        '${NumberFormat('#,###').format(produk.qty)} unit'),
                    pw.Divider(height: 20, thickness: 0.5),
                    _buildPdfDetailRow('Nilai persediaan:',
                        'Rp ${NumberFormat('#,###').format(produk.harga_beli! * produk.qty!)}'),
                  ],
                ),
              ),

              // Footer
              pw.Spacer(),
              pw.Center(
                child: pw.Text(
                    '<----------------------------------- TubinMart ----------------------------------->',
                    style: const pw.TextStyle(fontSize: 8)),
              )
            ],
          );
        },
      ),
    );

    // Get downloads directory
    final Directory? downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      print("Could not access downloads directory");
      return;
    }

    // Create subdirectory path
    final String subDirPath = '/storage/emulated/0/Download/qasir_pintar/stock';
    final Directory subDir = Directory(subDirPath);

    // Create directory if it doesn't exist
    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }

    // Create file
    String filename = 'Stock barang ' +
        produk.nama_produk! +
        ' ' +
        DateFormat('dd MMMM yyyy').format(DateTime.now());
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
