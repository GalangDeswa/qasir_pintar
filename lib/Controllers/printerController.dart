import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:app_settings/app_settings.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir%20-%20Pembayaran/controller_pembayaran.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Kasir/controller_kasir.dart';

import '../Config/config.dart';
import '../Modules - P.O.S/History/detail/controller_detailriwayatpenjualan.dart';
import '../Modules - P.O.S/Kasir/model_penjualan.dart';
import '../Modules - P.O.S/Produk/Data produk/model_produk.dart';
import '../Widget/popscreen.dart';
import '../Widget/widget.dart';

class PrintController extends GetxController {
  final BluetoothPrintPlus _btPrinter = BluetoothPrintPlus();

  /// Discovered Bluetooth devices
  final RxList<BluetoothDevice> devices = <BluetoothDevice>[].obs;

  /// Currently selected device
  final Rx<BluetoothDevice?> selectedDevice = Rx<BluetoothDevice?>(null);

  RxnString selectedAddress = RxnString();

  /// Connection status
  final RxBool isConnected = false.obs;

  /// CapabilityProfile for ESC/POS (loaded once)
  CapabilityProfile? _profile;

  @override
  void onInit() {
    super.onInit();
    print('On init printer controller -->');
    print('devices on init -->   ');
    print(devices);

    checkPermissions();

    // 1) Load the ESC/POS capability profile (for mm58 paper, we'll do that on demand)
    CapabilityProfile.load().then((profile) {
      _profile = profile;
    });

    // 2) Listen to scan results
    BluetoothPrintPlus.scanResults.listen((List<BluetoothDevice> list) {
      devices.assignAll(list);
      print('devices scan resdult -->');
      print(devices);
      if (devices.isNotEmpty) {
        isScanning.value = false;
      }
    });

    // 3) Listen to connect state changes
    BluetoothPrintPlus.connectState.listen((ConnectState status) {
      isConnected.value = status == ConnectState.connected;
      // if(isConnected.value){
      //   isCetakHistoryReady.value = true;
      // }
    });
  }

  Future<bool> checkPermissions() async {
    if (Platform.isAndroid) {
      // For Android 12+
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();
    }
    return true;
  }

  var isScanning = false.obs;

  /// Trigger a ~4-second BLE scan
  Future<void> startScan() async {
    devices.clear();
    selectedDevice.value = null;
    isScanning.value = true;
    await checkPermissions();
    // 1. Check if Bluetooth is enabled

    if (Platform.isAndroid) {
      final blue = await Permission.bluetooth.serviceStatus;
      if (!blue.isEnabled) {
        _showBluetoothEnableDialog();
        return;
      }
    }
    // bool isBluetoothOn = await BluetoothPrintPlus.isBlueOn;
    // if (!isBluetoothOn) {
    //   _showBluetoothEnableDialog();
    //   return;
    // }

    // 2. Check Location service (Android only)
    if (Platform.isAndroid) {
      final locationStatus = await Permission.locationWhenInUse.serviceStatus;
      if (!locationStatus.isEnabled) {
        _showLocationEnableDialog();
        return;
      }
    }

    BluetoothPrintPlus.startScan(timeout: const Duration(seconds: 10));
    // if (devices.isNotEmpty) {
    //   isScanning.value = false;
    // }
    print('scan true/false -->');
    print(isScanning.value);
  }

  /// Set the selected device from dropdown
  void selectDevice(BluetoothDevice? device) {
    selectedAddress.value = null;
    selectedDevice.value = null;
    selectedDevice.value = device;
    selectedAddress.value = device?.address;
  }

  void _showBluetoothEnableDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Bluetooth Disabled'),
        content: const Text('Please enable Bluetooth to scan for printers'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await AppSettings.openAppSettings(
                  type: AppSettingsType.bluetooth);
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showLocationEnableDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Location Disabled'),
        content:
            const Text('Location service is required for Bluetooth scanning'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await AppSettings.openAppSettings(type: AppSettingsType.location);
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  var connecting = false.obs;

  /// Connect to the chosen device
  Future<void> connect() async {
    print('connecting...');
    connecting.value = true;
    final dev = selectedDevice.value;
    if (dev != null) {
      var con = await BluetoothPrintPlus.connect(dev);
      if (con != null) {
        connecting.value = false;
      }
    }
  }

  /// Disconnect
  Future<void> disconnect() async {
    print('disconnecting...');
    await BluetoothPrintPlus.disconnect();
    selectedDevice.value = null;
    connecting.value = false;
  }

  /// Build a simple text receipt (using ESC/POS) and send it
  Future<void> printSampleText() async {
    if (!(isConnected.value && selectedDevice.value != null)) {
      Get.snackbar('Error', 'Printer not connected');
      return;
    }

    // Ensure the CapabilityProfile has loaded
    if (_profile == null) {
      // In practice, you might await this earlier or show a loading indicator
      _profile = await CapabilityProfile.load();
    }

    // Create an ESC/POS Generator for 58 mm paper
    final generator = Generator(PaperSize.mm58, _profile!);

    // Accumulate the bytes
    List<int> bytes = [];

    Uint8List assetBytes =
        (await rootBundle.load('assets/icons/logoprintstruk.png'))
            .buffer
            .asUint8List();
    // 4) Decode into an `img.Image` using the `image` package
    img.Image? logo = img.decodeImage(assetBytes);
    if (logo == null) {
      Get.snackbar('Error', 'Failed to decode logo image');
      return;
    }

    bytes += generator.image(
      logo,
      align: PosAlign.center,
      // you can adjust the printed width (in pixels) as needed
    );

    // 1) Centered, large header
    bytes += generator.text(
      '*** Struk belanja ***',
      styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2),
      linesAfter: 1,
    );

    // 2) Left‐aligned date/time
    bytes += generator.text(
      'Date: ${DateTime.now()}',
      styles: const PosStyles(align: PosAlign.left),
      linesAfter: 1,
    );

    // 3) Two items with left/right columns
    bytes += generator.row([
      PosColumn(text: 'Item A', width: 6),
      PosColumn(
          text: '\$5.00',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Item B', width: 6),
      PosColumn(
          text: '\$3.25',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.text('<-- QASIR PINTAR -->',
        linesAfter: 1, styles: PosStyles(align: PosAlign.center));

    // 4) Footer message, centered
    bytes += generator.text(
      'Thank you for your purchase!',
      styles: const PosStyles(align: PosAlign.center),
      linesAfter: 2,
    );

    // 5) Cut command
    bytes += generator.cut();

    // Finally, send the raw bytes via bluetooth_print_plus
    final Uint8List dataToSend = Uint8List.fromList(bytes);
    await BluetoothPrintPlus.write(dataToSend);
  }

  /// Reusable function to print a "penjualan" (sale) receipt.
  ///
  /// [penjualan] = your DataPenjualan object (header info)
  /// [items]     = list of DataProdukTemp (each product in the cart)
  Future<void> printPenjualanReceipt({
    required DataPenjualan penjualan,
    required List<DataKeranjang> items,
    required String NamaToko,
    namaPelanggan,
  }) async {
    print('print penjualan --->');
    if (!(isConnected.value && selectedDevice.value != null)) {
      Get.snackbar('Error', 'Printer not connected');
      print('error printer gak konek');
      popPrinterpenjualan();
      return;
    }

    // 2) Ensure ESC/POS profile is loaded
    if (_profile == null) {
      _profile = await CapabilityProfile.load();
    }
    final generator = Generator(PaperSize.mm58, _profile!);

    // 3) Optionally: print a logo from assets (uncomment if you want a logo)
    //    Make sure "assets/logo.png" is declared under flutter.assets in pubspec.yaml
    //
    // Uint8List imgBytes =
    //     (await rootBundle.load('assets/logo.png')).buffer.asUint8List();
    // img.Image? logo = img.decodeImage(imgBytes);
    // if (logo != null) {
    //   bytes += generator.image(logo, align: PosAlign.center, width: 150);
    //   bytes += generator.text('', linesAfter: 1);
    // }

    Uint8List assetBytes =
        (await rootBundle.load('assets/icons/logoprintstruk.png'))
            .buffer
            .asUint8List();
    // 4) Decode into an `img.Image` using the `image` package
    img.Image? logo = img.decodeImage(assetBytes);
    if (logo == null) {
      Get.snackbar('Error', 'Failed to decode logo image');
      return;
    }

    // 4) Start building receipt bytes
    List<int> bytes = [];

    bytes += generator.image(
      logo,
      align: PosAlign.center,
      // you can adjust the printed width (in pixels) as needed
    );

    bytes += generator.text(
      '*** ' + NamaToko! + ' ***',
      styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2),
      linesAfter: 1,
    );

    // 4a) Header (Store name, invoice no, date, etc.)
    bytes += generator.text(
      penjualan.noFaktur ?? 'No Faktur: -',
      styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2),
      linesAfter: 1,
    );
    final currentTime = DateFormat('HH:mm').format(DateTime.now());
    bytes += generator.text(
      'Tanggal: $currentTime - ${AppFormat().dateFormat(penjualan.tanggal) ?? ''}',
      styles: const PosStyles(align: PosAlign.left),
      linesAfter: 1,
    );
    bytes += generator.text(
      'Kasir: ${penjualan.namaKaryawan}',
      styles: const PosStyles(align: PosAlign.left),
      linesAfter: 1,
    );
    if (penjualan.idPelanggan != null &&
        penjualan.idPelanggan!.isNotEmpty &&
        namaPelanggan != null) {
      bytes += generator.text(
        'Pelanggan: ${namaPelanggan}',
        styles: const PosStyles(align: PosAlign.left),
        linesAfter: 1,
      );
    }
    bytes += generator.hr(); // horizontal line

    // 4b) Column headers
    // We’ll create 3 columns: Nama Produk (width 6), Qty (width 2), Harga (width 4)
    bytes += generator.row([
      PosColumn(
        text: 'Item',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: 'Total',
        width: 4,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);

    // 4c) List each item
    for (var prod in items) {
      // Assuming DataProdukTemp has: nama_produk, qty, harga_jual_eceran
      final nama = prod.isPaket == false ? prod.namaProduk : prod.namaPaket;
      final qty = prod.qty.toString();
      final hargaTotal = prod.isPaket == false
          ? (prod.hargaEceran! * prod.qty).toStringAsFixed(0)
          : (prod.hargaPaket! * prod.qty).toStringAsFixed(0);

      bytes += generator.row([
        PosColumn(text: nama!, width: 6),
        PosColumn(
            text: qty,
            width: 2,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
            text: hargaTotal,
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr(); // horizontal line before totals

    // 4d) Subtotal, Discount, Total
    bytes += generator.row([
      PosColumn(
          text: 'Subtotal', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.subtotal!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // If there is a discount nominal
    if ((penjualan.diskonNominal ?? 0) > 0) {
      bytes += generator.row([
        PosColumn(text: 'Diskon (Rp)', width: 6),
        PosColumn(text: '', width: 2),
        PosColumn(
          text: penjualan.diskonNominal!.toStringAsFixed(0),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    // If there is a discount percent
    if ((penjualan.diskonPersen ?? 0) > 0) {
      bytes += generator.row([
        PosColumn(text: 'Diskon (%)', width: 6),
        PosColumn(text: '', width: 2),
        PosColumn(
          text: '${penjualan.diskonPersen}%',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    // If there is a promo code / promo value
    if ((penjualan.nilaiPromo ?? 0) > 0) {
      bytes += generator.row([
        PosColumn(text: 'Promo (${penjualan.namaPromo})', width: 6),
        PosColumn(text: '', width: 2),
        PosColumn(
          text: penjualan.nilaiPromo!.toStringAsFixed(0),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    if ((penjualan.totalPajak ?? 0) > 0) {
      bytes += generator.row([
        PosColumn(text: 'Total pajak', width: 6),
        PosColumn(text: '', width: 2),
        PosColumn(
          text: penjualan.totalPajak!.toStringAsFixed(0),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    // Grand total
    bytes += generator.row([
      PosColumn(
          text: 'Total Bayar', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.totalBayar!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    // 4e) Bayar & Kembalian
    bytes += generator.row([
      PosColumn(text: 'Dibayar', width: 6),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.nilaiBayar!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // Kembalian
    bytes += generator.row([
      PosColumn(text: 'Kembalian', width: 6),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.kembalian!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr(); // horizontal line

    // 4f) Footer
    bytes += generator.text(
      'Terima kasih atas kunjungan Anda!',
      styles: const PosStyles(align: PosAlign.center),
      linesAfter: 0,
    );

    // 4g) Cut
    bytes += generator.cut(mode: PosCutMode.partial);

    // 5) Finally, send all bytes to the printer
    final Uint8List dataToSend = Uint8List.fromList(bytes);
    await BluetoothPrintPlus.write(dataToSend);
  }

  /// [printStrukHistory]--------------------------------------------------------------------------------------------------
  ///
  ///
  Future<void> printStrukHistory({
    required DataPenjualan penjualan,
    required List<DataDetailPenjualan> items,
    required String NamaToko,
  }) async {
    Get.dialog(showloading(), barrierDismissible: false);
    print('print penjualan --->');
    if (!(isConnected.value && selectedDevice.value != null)) {
      print('error printer gak konek');
      Get.snackbar('Error', 'Printer not connected');
      popPrinter();
      return;
    }

    // 2) Ensure ESC/POS profile is loaded
    if (_profile == null) {
      _profile = await CapabilityProfile.load();
    }
    final generator = Generator(PaperSize.mm58, _profile!);

    // 3) Optionally: print a logo from assets (uncomment if you want a logo)
    //    Make sure "assets/logo.png" is declared under flutter.assets in pubspec.yaml
    //
    // Uint8List imgBytes =
    //     (await rootBundle.load('assets/logo.png')).buffer.asUint8List();
    // img.Image? logo = img.decodeImage(imgBytes);
    // if (logo != null) {
    //   bytes += generator.image(logo, align: PosAlign.center, width: 150);
    //   bytes += generator.text('', linesAfter: 1);
    // }

    Uint8List assetBytes =
        (await rootBundle.load('assets/icons/logoprintstruk.png'))
            .buffer
            .asUint8List();
    // 4) Decode into an `img.Image` using the `image` package
    img.Image? logo = img.decodeImage(assetBytes);
    if (logo == null) {
      Get.snackbar('Error', 'Failed to decode logo image');
      return;
    }

    // 4) Start building receipt bytes
    List<int> bytes = [];

    bytes += generator.image(
      logo,
      align: PosAlign.center,
      // you can adjust the printed width (in pixels) as needed
    );

    bytes += generator.text(
      '*** ' + NamaToko! + ' ***',
      styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2),
      linesAfter: 1,
    );

    // 4a) Header (Store name, invoice no, date, etc.)
    bytes += generator.text(
      penjualan.noFaktur ?? 'No Faktur: -',
      styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2),
      linesAfter: 1,
    );
    final currentTime = DateFormat('HH:mm').format(DateTime.now());
    bytes += generator.text(
      'Tanggal: $currentTime - ${AppFormat().dateFormat(penjualan.tanggal) ?? ''}',
      styles: const PosStyles(align: PosAlign.left),
      linesAfter: 1,
    );
    // TODO : check id karyawan/nama karyawan dari penjualan db
    // TODO : karyawan harus login dulu sebelum  buka kasir
    bytes += generator.text(
      'Kasir: ${penjualan.id_karyawan}',
      styles: const PosStyles(align: PosAlign.left),
      linesAfter: 1,
    );
    if (penjualan.idPelanggan != null &&
        penjualan.idPelanggan!.isNotEmpty &&
        penjualan.namaPelanggan != null) {
      bytes += generator.text(
        'Pelanggan: ${penjualan.namaPelanggan}',
        styles: const PosStyles(align: PosAlign.left),
        linesAfter: 1,
      );
    }
    bytes += generator.hr(); // horizontal line

    // 4b) Column headers
    // We’ll create 3 columns: Nama Produk (width 6), Qty (width 2), Harga (width 4)
    bytes += generator.row([
      PosColumn(
        text: 'Item',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: 'Total',
        width: 4,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);

    // 4c) List each item
    for (var prod in items) {
      // Assuming DataProdukTemp has: nama_produk, qty, harga_jual_eceran
      final nama = prod.nama_produk ?? prod.namaPaket;
      final qty = prod.qty.toString();
      final hargaTotal = 'Rp.' + AppFormat().numFormat(prod.subtotal!);

      bytes += generator.row([
        PosColumn(text: nama!, width: 6),
        PosColumn(
            text: qty,
            width: 2,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
            text: hargaTotal,
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr(); // horizontal line before totals

    // 4d) Subtotal, Discount, Total
    bytes += generator.row([
      PosColumn(
          text: 'Subtotal', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.subtotal!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // If there is a discount nominal
    if ((penjualan.diskonNominal ?? 0) > 0) {
      bytes += generator.row([
        PosColumn(text: 'Diskon (Rp)', width: 6),
        PosColumn(text: '', width: 2),
        PosColumn(
          text: penjualan.diskonNominal!.toStringAsFixed(0),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    // If there is a discount percent
    if ((penjualan.diskonPersen ?? 0) > 0) {
      bytes += generator.row([
        PosColumn(text: 'Diskon (%)', width: 6),
        PosColumn(text: '', width: 2),
        PosColumn(
          text: '${penjualan.diskonPersen}%',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    // If there is a promo code / promo value
    if ((penjualan.nilaiPromo ?? 0) > 0) {
      bytes += generator.row([
        PosColumn(text: 'Promo (${penjualan.namaPromo})', width: 6),
        PosColumn(text: '', width: 2),
        PosColumn(
          text: penjualan.nilaiPromo!.toStringAsFixed(0),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    // If there is a promo code / promo value

    bytes += generator.row([
      PosColumn(text: 'Total pajak ', width: 6),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.totalPajak == null
            ? 0.0.toString()
            : penjualan.totalPajak!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // Grand total
    bytes += generator.row([
      PosColumn(
          text: 'Total Bayar', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.totalBayar!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    // 4e) Bayar & Kembalian
    bytes += generator.row([
      PosColumn(text: 'Dibayar', width: 6),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.nilaiBayar!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // Kembalian
    bytes += generator.row([
      PosColumn(text: 'Kembalian', width: 6),
      PosColumn(text: '', width: 2),
      PosColumn(
        text: penjualan.kembalian!.toStringAsFixed(0),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr(); // horizontal line

    // 4f) Footer
    bytes += generator.text(
      'Terima kasih atas kunjungan Anda!',
      styles: const PosStyles(align: PosAlign.center),
      linesAfter: 0,
    );

    // 4g) Cut
    bytes += generator.cut(mode: PosCutMode.partial);

    // 5) Finally, send all bytes to the printer
    final Uint8List dataToSend = Uint8List.fromList(bytes);
    await BluetoothPrintPlus.write(dataToSend);
    Get.back();
  }

  var isCetakHistoryReady = false.obs;

  void popPrinter() async {
    onInit();
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Setting printer',
        icon: Icons.print,
        icon_color: AppColor.primary,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Obx(() {
            return Container(
              height: Get.height / 2,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) Scan Button + Spinner
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('Scan Printers'),
                        onPressed: () => startScan(),
                      ),
                      const SizedBox(width: 12),
                      if (isScanning.value == true)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  devices.isEmpty
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              // 2) Dropdown of discovered devices
                              const Text(
                                'Select Printer:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownButton<BluetoothDevice>(
                                isExpanded: true,
                                hint: const Text('Choose a device'),
                                value: selectedDevice.value,
                                items: devices.map((device) {
                                  final name = device.name ?? 'Unknown';
                                  final addr = device.address ?? '—';
                                  return DropdownMenuItem<BluetoothDevice>(
                                    value: device,
                                    child: Text('$name ($addr)'),
                                  );
                                }).toList(),
                                onChanged: (device) {
                                  print(device!.name);
                                  selectDevice(device);
                                },
                              ),
                              const SizedBox(height: 20),

                              // 3) Connect / Disconnect Button
                              if (!isConnected.value)
                                connecting.value == true
                                    ? Row(children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                              Icons.bluetooth_connected),
                                          label: const Text('Connect'),
                                          onPressed:
                                              (selectedDevice.value != null)
                                                  ? () => connect()
                                                  : null,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                        )
                                      ])
                                    : ElevatedButton.icon(
                                        icon: const Icon(
                                            Icons.bluetooth_connected),
                                        label: const Text('Connect'),
                                        onPressed:
                                            (selectedDevice.value != null)
                                                ? () => connect()
                                                : null,
                                      )
                              else
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.bluetooth_disabled),
                                  label: const Text('Disconnect'),
                                  //style: ElevatedButton.styleFrom(primary: Colors.red),
                                  onPressed: () => disconnect(),
                                ),

                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.print),
                                label: const Text('Cetak struk'),
                                onPressed: (isConnected.value)
                                    ? () {
                                        var x = Get.find<
                                            DetailHistoryPenjualanController>();
                                        x.printstruk();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(45)),
                              ),

                              // 4) Print Sample Text (only enabled when connected)
                              // ElevatedButton.icon(
                              //   icon: const Icon(Icons.print),
                              //   label: const Text('Cetak struk'),
                              //   onPressed: (isConnected.value)
                              //       ? () => printSampleText()
                              //       : null,
                              //   style: ElevatedButton.styleFrom(
                              //       minimumSize: const Size.fromHeight(45)),
                              // ),
                            ]),

                  const SizedBox(height: 30),

                  // 5) Status indicator
                  Row(
                    children: [
                      const Text('Status printer : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        isConnected.value ? 'Connected' : 'Not Connected',
                        style: TextStyle(
                          color: isConnected.value ? Colors.green : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        },
      ),
    ));
  }

  void popPrinterpenjualan() async {
    onInit();
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Setting printer',
        icon: Icons.print,
        icon_color: AppColor.primary,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Obx(() {
            return Container(
              height: Get.height / 2,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) Scan Button + Spinner
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('Scan Printers'),
                        onPressed: () => startScan(),
                      ),
                      const SizedBox(width: 12),
                      if (isScanning.value == true)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  devices.isEmpty
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              // 2) Dropdown of discovered devices
                              const Text(
                                'Select Printer:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownButton<BluetoothDevice>(
                                isExpanded: true,
                                hint: const Text('Choose a device'),
                                value: selectedDevice.value,
                                items: devices.map((device) {
                                  final name = device.name ?? 'Unknown';
                                  final addr = device.address ?? '—';
                                  return DropdownMenuItem<BluetoothDevice>(
                                    value: device,
                                    child: Text('$name ($addr)'),
                                  );
                                }).toList(),
                                onChanged: (device) {
                                  print(device!.name);
                                  selectDevice(device);
                                },
                              ),
                              const SizedBox(height: 20),

                              // 3) Connect / Disconnect Button
                              if (!isConnected.value)
                                connecting.value == true
                                    ? Row(children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                              Icons.bluetooth_connected),
                                          label: const Text('Connect'),
                                          onPressed:
                                              (selectedDevice.value != null)
                                                  ? () => connect()
                                                  : null,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                        )
                                      ])
                                    : ElevatedButton.icon(
                                        icon: const Icon(
                                            Icons.bluetooth_connected),
                                        label: const Text('Connect'),
                                        onPressed:
                                            (selectedDevice.value != null)
                                                ? () => connect()
                                                : null,
                                      )
                              else
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.bluetooth_disabled),
                                  label: const Text('Disconnect'),
                                  //style: ElevatedButton.styleFrom(primary: Colors.red),
                                  onPressed: () => disconnect(),
                                ),

                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.print),
                                label: const Text('Cetak struk'),
                                onPressed: (isConnected.value)
                                    ? () {
                                        var x = Get.find<KasirController>();
                                        x.printstruk();
                                        Get.back();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(45)),
                              ),

                              // 4) Print Sample Text (only enabled when connected)
                              // ElevatedButton.icon(
                              //   icon: const Icon(Icons.print),
                              //   label: const Text('Cetak struk'),
                              //   onPressed: (isConnected.value)
                              //       ? () => printSampleText()
                              //       : null,
                              //   style: ElevatedButton.styleFrom(
                              //       minimumSize: const Size.fromHeight(45)),
                              // ),
                            ]),

                  const SizedBox(height: 30),

                  // 5) Status indicator
                  Row(
                    children: [
                      const Text('Status printer : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        isConnected.value ? 'Connected' : 'Not Connected',
                        style: TextStyle(
                          color: isConnected.value ? Colors.green : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        },
      ),
    ));
  }
}
