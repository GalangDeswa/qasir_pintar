import 'dart:convert';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/model_karyawan.dart';
import 'package:qasir_pintar/Services/BoxStorage.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:uuid/uuid.dart';

import '../../Config/config.dart';
import '../../Controllers/printerController.dart';
import '../../Database/DB_helper.dart';
import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';
import '../Base menu/controller_basemenu.dart';
import '../Kasir - Rincian Pembayaran/view_rincianpembayaran.dart';
import '../Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../Pelanggan/List kategori pelanggan/controller_kategoripelanggan.dart';
import '../Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';
import '../Pelanggan/Tambah Pelanggan/controller_tambahpelanggan.dart';
import '../Pelanggan/Tambah Pelanggan/view_tambahpelanggan.dart';
import '../Produk/Data produk/model_produk.dart';
import '../Produk/Kategori/model_subkategoriproduk.dart';
import '../Produk/Produk/model_kategoriproduk.dart';
import '../Promo/model_promo.dart';
import '../Users/model_user.dart';
import 'model_penjualan.dart';

final StorageService box = Get.find<StorageService>();

class KasirController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('Kasir CON INIt--------------------------------->');
    uuid.value = box.read('uuid', fallback: 'null');
    Get.find<CentralProdukController>()
        .fetchProdukLocal(id_toko: uuid.value, isAktif: true);
    Get.find<CentralPaketController>()
        .fetchPaketLocal(id_toko: uuid.value, isAktif: true);
    rolevalue = box.read('karyawan_role', fallback: 'null');
    namaKaryawan.value = box.read('karyawan_nama', fallback: 'null');
    karyawanvalue = box.read('karyawan_id', fallback: 'null');
    print(box.read('karyawan_role', fallback: null));
    print(box.read('karyawan_id', fallback: null));
    print(box.read('karyawan_nama', fallback: null));
    // await getKaryawan();

    //await fetchPromo(id_toko: id_toko);

    namatoko.value = box.read('user_business_name', fallback: 'Default Toko');
    namaKaryawan.value =
        box.read('karyawan_nama', fallback: 'Default karyawan');
  }

  var namatoko = ''.obs;

  /// transfer pembayaran
  /// dari pembayaran controller ke kasir controller

  var id_toko = box.read('uuid', fallback: 'null');
  var diskondisplay = false.obs;
  var promodisplay = false.obs;
  var diskon = TextEditingController().obs;
  var promo = TextEditingController().obs;
  var searchpromo = TextEditingController().obs;
  var promovalue = 0.0.obs;
  var bayar = TextEditingController().obs;
  var bayarvalue = 0.0.obs;
  var opsidiskon = ['Rp.', '%'].obs;
  var selecteddiskon = ''.obs;

  var keranjang = <DataProdukTemp>[].obs;
  var totalItem = 0.obs;
  var subtotal = 0.0.obs;
  var totalbayar = 0.0.obs;
  var total = 0.0.obs;
  var totalTax = 0.0.obs;

  var data = Get.arguments;
  var sub;
  var jumlahdiskonkasir = 0.0.obs;
  var pelangganpilih = DataPelanggan;

  var savedCart = <DataKeranjangSavev2>[].obs;

  //TODO : sistem login karyawan buat kasir

  getKaryawan() async {
    print('get karyawan kasir');
    var isLogin = await GetStorage().read('karyawan_login') ?? false;
    if (!isLogin) {
      popLoginKaryawan();
    } else {
      return;
    }

    // print('get karyawanb --->');
    // var con = Get.find<CentralKaryawanController>();
    // con.fetchKaryawanLocal(id_toko: id_toko);
    // if (con.karyawanList.isEmpty) {
    //   print('karyawan kosong');
    //   Popscreen().noKaryawan();
    // } else {
    //   var isLogin = await GetStorage().read('karyawan_login') ?? false;
    //   print('status karyawan login');
    //
    //   print(isLogin);
    //   if (!isLogin) {
    //     Popscreen().karyawanLogin(this);
    //   } else {
    //     Popscreen().bukakasir();
    //     // print(namaKaryawan);
    //     // Get.snackbar('karyawan', namaKaryawan.value);
    //   }
    // }
  }

  getAvailableStock(String productUuid) async {
    final reserved = await _computeReservedByProduct();
    final reservedQty = reserved[productUuid] ?? 0;

    // Get actual stock from database
    final product = Get.find<CentralProdukController>()
        .produk
        .firstWhere((p) => p.uuid == productUuid);

    final actualStock = product.qty! - product.info_stok_habis! ?? 0;
    final availableStock = actualStock - reservedQty;
    print('avail stock ------------->' + availableStock.toString());

    if (reservedQty == 0) {
      print('reserved qty = 0');
    }
    return availableStock > 0 ? availableStock : 0;
  }

// Also add this method to get available stock for packages
  Future<int> getAvailableStockForPackage(String packageUuid) async {
    final reserved = await _computeReservedByProduct();

    // Get package details
    final packageItem = Get.find<CentralPaketController>()
        .paketproduk
        .firstWhere((p) => p.uuid == packageUuid);

    var details = await fetchdetailpaket(
      id_toko: packageItem.id_toko,
      id_paket_produk: packageUuid,
    );

    int minAvailablePackages = 999999; // Large number as starting point

    for (var detail in details) {
      final productUuid = detail.id_produk.toString();
      final product = Get.find<CentralProdukController>()
          .produk
          .firstWhereOrNull((p) => p.uuid == productUuid);

      if (product != null && product.hitung_stok == 1) {
        final actualStock = product.qty ?? 0;
        final reservedQty = reserved[productUuid] ?? 0;
        final availableStock = actualStock - reservedQty;

        // Calculate how many packages can be made with this product
        final possiblePackages = (availableStock / detail.qty).floor();

        if (possiblePackages < minAvailablePackages) {
          minAvailablePackages = possiblePackages;
        }
      }
    }

    return minAvailablePackages > 0 ? minAvailablePackages : 0;
  }

  // map uuid → stock observable
  final availStockMap = <String, RxInt>{}.obs;

  Future<void> loadStock(String uuid) async {
    final s = await getAvailableStock(uuid);
    // initialize or update the existing RxInt
    availStockMap[uuid] = (availStockMap[uuid] ?? 0.obs)..value = s;
    print('s------>');
    print(s);
  }

  Future<void> loadStockPackage(String uuid) async {
    final s = await getAvailableStockForPackage(uuid);
    // initialize or update the existing RxInt
    availStockMap[uuid] = (availStockMap[uuid] ?? 0.obs)..value = s;
    print('s------>');
    print(s);
  }

  // Widget buildStockDisplayv2(dynamic item, bool isPackage) {
  //   if (isPackage) {
  //     // For packages, we don't show individual stock
  //     return Text(
  //       'Package',
  //       overflow: TextOverflow.ellipsis,
  //       style: AppFont.small(),
  //     );
  //   } else {
  //     if (item.hitung_stok == 1) {
  //       var p = getAvailableStock(item.uuid);
  //
  //       final availableStock = p;
  //       final actualStock = item.qty ?? 0;
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Available: $availableStock',
  //             overflow: TextOverflow.ellipsis,
  //             style: AppFont.small().copyWith(
  //               color: availableStock == 0
  //                   ? Colors.red
  //                   : availableStock < 5
  //                       ? Colors.orange
  //                       : Colors.green,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           if (availableStock != actualStock)
  //             Text(
  //               'Total: $actualStock',
  //               overflow: TextOverflow.ellipsis,
  //               style: AppFont.small().copyWith(
  //                 color: Colors.grey,
  //                 fontSize: 10,
  //               ),
  //             ),
  //         ],
  //       );
  //     } else {
  //       return Text(
  //         'Nonstock',
  //         overflow: TextOverflow.ellipsis,
  //         style: AppFont.small(),
  //       );
  //     }
  //   }
  // }

  var savedDiskon = 0.0.obs;
  var savedMetodeDiskon = 0.obs;
  var savedPromovalue = 0.0.obs;
  var savedNamaPromo = ''.obs;
  var savedPromoUUID;
  var savedCustomerUUID = ''.obs;
  var savedCustumerName = ''.obs;
  var savedDisplayDiskon = 0.0.obs;

  saveCartv2() {
    print('saved cart v2 == >');
    final snapshot = List<DataKeranjang>.from(keranjangv2);
    // Save each cart with its own discount/coupon information
    savedCart.add(DataKeranjangSavev2(
      idToko: id_toko,
      savedAt: DateTime.now(),
      item: snapshot,
      // Store current discount/coupon info with this specific cart
      diskon: jumlahdiskonkasir.value,
      promoValue: promovalue.value,
      namaPromo: namaPromo.value,
      promoUUID: promolistvalue ?? null,
      customerName: namaPelanggan.value,
      customerUUID: pelangganvalue.value,
      metodeDiskon: metode_diskon.value,
      displayDiskon: displaydiskon.value,
    ));
    print('saved cart -->');
    print(savedCart.map((e) => e.item.map((x) => x.uuid)));
    clearAll();
  }

  openSavedCart() {
    Get.dialog(AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              width: width - 30,
              height: height - 200,
              child: Column(
                children: [
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        ' Keranjang Tersimpan',
                        style: AppFont.regular_white_bold(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: savedCart.length,
                        itemBuilder: (context, index) {
                          var cart = savedCart[index];

                          return Column(
                            children: [
                              ExpansionTile(
                                trailing: IconButton(
                                  onPressed: () async {
                                    print('add saved cart');

                                    // 1) FIRST: pull it out of savedCart so your validator won't double‑count it
                                    final restored = savedCart.removeAt(index);
                                    savedCart.refresh();
                                    Get.back();

                                    // 2) THEN: restore all the items
                                    for (final item in restored.item) {
                                      if (item.qty > 1) {
                                        for (var i = 0; i < item.qty; i++) {
                                          addToCart(
                                              item); // or just addToCart(item) if sync
                                        }
                                      } else {
                                        addToCart(item);
                                      }
                                    }

                                    // 3) Restore all your discount/promo/customer info
                                    jumlahdiskonkasir.value = restored.diskon;
                                    promovalue.value = restored.promoValue;
                                    namaPromo.value = restored.namaPromo;
                                    promolistvalue = restored.promoUUID;
                                    namaPelanggan.value = restored.customerName;
                                    pelangganvalue.value =
                                        restored.customerUUID;
                                    metode_diskon.value = restored.metodeDiskon;
                                    displaydiskon.value =
                                        restored.displayDiskon;

                                    print(
                                        'restored discount info for this cart:');
                                    print(' Discount: ${restored.diskon}');
                                    print(' Promo:    ${restored.namaPromo}');
                                    print(
                                        ' Customer: ${restored.customerName}');

                                    // 4) slide the sheet up
                                    kasirsheet.value.animateTo(SheetOffset(1));
                                  },
                                  icon: Icon(FontAwesomeIcons.cartPlus),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('HH:mm dd-MM-yyyy')
                                          .format(cart.savedAt),
                                      style: AppFont.regular_bold(),
                                    ),
                                    Text(
                                      'Keranjang nomor : ${index + 1}',
                                      style: AppFont.regular(),
                                    ),
                                  ],
                                ),
                                childrenPadding: EdgeInsets.zero,
                                children: cart.item.map((data) {
                                  print(data);
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    color:
                                        AppColor.primary.withValues(alpha: 0.1),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Produk',
                                                style: AppFont.regular()),
                                            Text('subtotal',
                                                style: AppFont.regular())
                                          ],
                                        ),
                                        Divider(),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          trailing: Text(
                                            (data.isPaket == true
                                                    ? 'Rp. ' +
                                                        AppFormat().numFormat(
                                                            data.hargaPaket! *
                                                                data.qty)
                                                    : 'Rp. ' +
                                                        AppFormat().numFormat(
                                                            data.hargaEceran! *
                                                                data.qty))
                                                .toString(),
                                            style: AppFont.regular(),
                                          ),
                                          title: data.isPaket == true
                                              ? Text(
                                                  data.namaPaket!,
                                                  style: AppFont.regular(),
                                                )
                                              : Text(
                                                  data.namaProduk!,
                                                  style: AppFont.regular(),
                                                ),
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                data.isPaket == true
                                                    ? 'Rp. ' +
                                                        AppFormat().numFormat(
                                                            data.hargaPaket)
                                                    : 'Rp. ' +
                                                        AppFormat().numFormat(
                                                            data.hargaEceran),
                                                style: AppFont.regular(),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                    'x ' + data.qty.toString()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              Divider(),
                            ],
                          );
                        }),
                  ),
                ],
              ));
        },
      ),
    ));
  }

  //printer----------------

  Future<bool> checkPermissions() async {
    if (Platform.isAndroid) {
      // For Android 12+
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();
    }
    return true;
  }

  String generateInvoiceNumber() {
    final now = DateTime.now();
    final currentDate = DateFormat('yyyyMMdd').format(now);

    // Get last stored date and sequence
    final lastDate = GetStorage().read('lastInvoiceDate');
    int sequence = GetStorage().read('invoiceSequence') ?? 1;

    // Reset sequence if it's a new day
    if (lastDate != currentDate) {
      sequence = 1;
    } else {
      sequence++;
    }

    // Store new values
    GetStorage().write('lastInvoiceDate', currentDate);
    GetStorage().write('invoiceSequence', sequence);

    // Format sequence with leading zeros
    final sequenceFormatted = sequence.toString().padLeft(4, '0');
    nofaktur = 'INV$currentDate-$sequenceFormatted';
    return 'INV$currentDate-$sequenceFormatted';
  }

  String getTodayDateISO() {
    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as "YYYY-MM-DD"
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  var ppn = 0.0.obs;
  var ppnSwitch = false.obs;
  var diskonpersen = 0.0.obs;
  var diskonnominal = 0.0.obs;

  hitungbesardiskonkasir() {
    if (metode_diskon.value == 1) {
      print(
          '------------------------------ persen diskon ------------------------------');

      diskonpersen.value = subtotal.value * displaydiskon.value / 100;
      return jumlahdiskonkasir.value =
          subtotal.value * displaydiskon.value / 100;
    } else {
      print(
          '------------------------------ nominal diskon ------------------------------');
      diskonnominal.value = displaydiskon.value;
      print(displaydiskon);
      return jumlahdiskonkasir.value = displaydiskon.value;
    }
  }

  hitungpromo() {
    var con = Get.find<CentralPromoController>();
    if (namaPromo.value == '') {
      print('tidak ada nama promo');
      promovalue.value = 0.0;
      return;
    }
    print('hitung prom new----->');
    var p = con.promo.where((x) => x.uuid == promolistvalue).first;
    print(p.promoNominal.toString() + '----' + p.promoPersen.toString());

    if (p.promoNominal == 0.0) {
      print('promo persen --->');
      promovalue.value = subtotal.value * p.promoPersen! / 100;
    } else {
      print('promo nominal --->');
      promovalue.value = p.promoNominal!;
    }
  }

  totalval() {
    print('total val--->');
    var total1 = subtotal.value -
        jumlahdiskonkasir.value -
        promovalue.value +
        totalTax.value;
    var ppn1 = 11 / 100 * total1;
    if (ppnSwitch.value == true) {
      ppn.value = ppn1;
      return total.value = total1 + ppn1;
    } else {
      ppn.value = 0.0;
      return total.value = total1;
    }
  }

  hitungPembayaran() {
    hitungbesardiskonkasir();
    hitungpromo();
    totalval();
  }

  var uuidpenjualanstruk;
  var nofaktur;
  var printtotalbayar;

  checktipe() {
    for (DataKeranjang produk in keranjangv2) {
      if (produk.isPaket == false) {
        print('produk bukan paket -->');
        print(produk.namaProduk);
      }
      if (produk.isPaket == true) {
        print('produk paket -->');
        print(produk.namaPaket);
      }
    }
  }

  pembayaran() async {
    print('-------------------pembayaran---------------------');

    Get.dialog(showloading(), barrierDismissible: false);

    var uuidpenjualan = Uuid().v4();
    uuidpenjualanstruk = uuidpenjualan;

    var bayar = await DBHelper().INSERT(
      'penjualan',
      DataPenjualan(
              uuid: uuidpenjualan,
              idPelanggan: pelangganvalue.value,
              idToko: id_toko,
              idLogin: id_toko,
              tanggal: getTodayDateISO(),
              noFaktur: generateInvoiceNumber(),
              subtotal: subtotal.value,
              diskonNominal: diskonnominal.value,
              diskonPersen: diskonpersen.value,
              kembalian: balikvalue.value,
              kodePromo: promolistvalue,
              nilaiBayar: bayarvalue.value,
              nilaiPromo: promovalue.value,
              totalBayar: total.value,
              totalQty: totalItem.value,
              totalDiskon: diskonnominal.value + diskonpersen.value ?? 0.0,
              namaPelanggan: namaPelanggan.value,
              namaPromo: namaPromo.value,
              totalPajak: totalTax.value,
              id_karyawan: karyawanvalue,
              reversal: 0)
          .DB(),
    );

    if (bayar != null) {
      for (DataKeranjang produk in keranjangv2) {
        if (produk.isPaket == false) {
          print('produk bukan paket -->');
          print(produk.namaProduk);
          var uuuidDetailpenjualan = Uuid().v4();
          var detail = await DBHelper().INSERT(
              'detail_penjualan',
              DataDetailPenjualan(
                      uuid: uuuidDetailpenjualan,
                      //idPaket: produk.idPaket,
                      totalHarga: total.value,
                      qty: produk.qty,
                      idToko: id_toko,
                      idProduk: produk.uuid,
                      subtotal: produk.hargaEceran! * produk.qty,
                      //subtotalPaket: produk.hargaPaket! * produk.qty,
                      discNominal: diskonnominal.value,
                      discPersen: diskonpersen.value,
                      idPenjualan: uuidpenjualan)
                  .DB());

          print('update stock ---->' +
              produk.namaProduk! +
              ' ' +
              produk.qty.toString());
          await DBHelper().decrementQty(
              table: 'stock_produk',
              id_produk: produk.uuid.toString(),
              decrement: produk.qty);
        }

        if (produk.isPaket == true) {
          await fetchdetailpaket(
              id_toko: id_toko, id_paket_produk: produk.idPaket);
          var allproduct = Get.find<CentralProdukController>().produk;
          print('produk  paket -->');
          print(produk.namaPaket);
          var uuuidDetailpenjualan = Uuid().v4();
          var detail = await DBHelper().INSERT(
              'detail_penjualan',
              DataDetailPenjualan(
                      uuid: uuuidDetailpenjualan,
                      idPaket: produk.idPaket,
                      totalHarga: total.value,
                      qty: produk.qty,
                      idToko: id_toko,
                      idProduk: produk.uuid,
                      subtotal: produk.hargaPaket! * produk.qty,
                      //subtotalPaket: produk.hargaPaket! * produk.qty,
                      discNominal: diskonnominal.value,
                      discPersen: diskonpersen.value,
                      idPenjualan: uuidpenjualan)
                  .DB());

          final productByUuid = {
            for (var p in allproduct) p.uuid!: p,
          };

          for (var item in detailpaket) {
            final localProd = productByUuid[item.id_produk];
            // if it exists AND is a stock‐tracked product
            if (localProd != null && localProd.hitung_stok == 1) {
              final totalMin = item.qty * produk.qty;
              print(' - Decrementing ${item.id_produk} by $totalMin');

              await DBHelper().decrementQty(
                table: 'stock_produk',
                id_produk: item.id_produk.toString(),
                decrement: totalMin,
              );
            } else {
              print(' Skipping ${item.id_produk}, non-stocked or not found');
            }
          }
        }
      }
      Popscreen().berhasilbayar(this);

      await Get.find<CentralProdukController>()
          .fetchProdukLocal(id_toko: id_toko);
      //clearAll();
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  printstruk() async {
    var conprint = Get.find<PrintController>();
    var penjualanprint = DataPenjualan(
        uuid: uuidpenjualanstruk,
        idPelanggan: pelangganvalue.value,
        idToko: id_toko,
        idLogin: id_toko,
        tanggal: getTodayDateISO(),
        noFaktur: nofaktur,
        subtotal: subtotal.value,
        diskonNominal: diskonnominal.value,
        diskonPersen: diskonpersen.value,
        kembalian: balikvalue.value,
        kodePromo: promo.value.text,
        nilaiBayar: bayarvalue.value,
        nilaiPromo: promovalue.value,
        totalBayar: total.value,
        totalQty: totalItem.value,
        totalDiskon: displaydiskon.value ?? 0.0,
        namaPelanggan: namaPelanggan.value,
        totalPajak: totalTax.value,
        id_karyawan: karyawanvalue,
        namaKaryawan: namaKaryawan.value,
        namaPromo: namaPromo.value);
    final List<DataKeranjang> daftarItem = List.from(keranjangv2);
    await conprint.printPenjualanReceipt(
        penjualan: penjualanprint,
        items: daftarItem,
        namaPelanggan: namaPelanggan.value,
        NamaToko: 'qwe');
    //clearAll();
  }

  RxList<String> deletedDetailIds = <String>[].obs;

  clearAll() {
    print('clear all -->');
    var x = Get.find<KasirController>();
    x.keranjangv2.clear();
    x.keranjangv2.refresh();
    x.totalitem.value = 0;
    x.totalItem.value = 0;
    x.subtotal.value = 0.0;
    total.value = 0.0;
    keranjangv2.clear();
    jumlahdiskonkasir.value = 0.0;
    promovalue.value = 0.0;
    namaPromo.value = '';
    promolistvalue = null;
    namaPelanggan.value = '';
    pelangganvalue.value = '';
    metode_diskon.value = 9;
    displaydiskon.value = 0.0;
    totalTax.value = 0.0;
    //Get.delete<PembayaranController>();
  }

  var kasirsheet = SheetController().obs;
  var balikvalue = 0.0.obs;

  balik() {
    var kem = bayarvalue.value - total.value;
    // kem < 0
    //     ? kembalian.value.text = ''
    //     : kembalian.value.text = kem
    //     .toStringAsFixed(0)
    //     .replaceAll(RegExp(r'[^\w\s]+'), '')
    //     .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    //         (Match m) => '${m[1]},');
    balikvalue.value = kem;
    //kembalian.value.text = kem.toString();
    print('---kembalian----');
    //print(kembalian.value.text);
    print('balik value---------');
    print(balikvalue.value.toString());
  }

  addbayar(double x) {
    if (bayar.value.text.isEmpty) {
      bayar.value.text = AppFormat().numFormat(x);
      bayarvalue.value = x;
    } else {
      var sum = bayarvalue.value + x;
      print(sum);
      bayar.value.text = sum
          .toStringAsFixed(0)
          .replaceAll(RegExp(r'[^\w\s]+'), '')
          .replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      bayarvalue.value = sum;
    }
    balik();
  }

  List<Widget> pages = [
    RincianPembayaran(),
    Container(
      height: 100,
      width: 100,
      color: Colors.red,
    ),
    Container(
      height: 100,
      width: 100,
      color: Colors.green,
    ),
    Container(
      height: 100,
      width: 100,
      color: Colors.blue,
    )
  ];
  var promolist = <DataPromo>[].obs;
  var promolistvalue;

  fetchPromo({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM promo WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPromo> data = query.map((e) => DataPromo.fromJsondb(e)).toList();
      promolist.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  var metode_diskon = 9.obs;
  RxDouble displaydiskon = 0.0.obs;

  editDiskonKasir(KasirController controller, promouuid) {
    Get.dialog(
        AlertDialog(
          surfaceTintColor: Colors.white,
          contentPadding: EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: context.res_width,
                    height: context.res_height / 2.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return metode_diskon.value == 9
                              ? Expanded(
                                  child: Container(
                                      child: Center(
                                          child: Text(
                                  'pilih metode diskon',
                                  style: AppFont.regular(),
                                ))))
                              : metode_diskon.value == 1
                                  ? Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: ((String num) {
                                          displaydiskon.value = double.parse(
                                              num.toString()
                                                  .replaceAll(',', ''));
                                          print(displaydiskon);
                                        }),
                                        decoration: InputDecoration(
                                          hintText: 'Persentase diskon',
                                          suffixText: '%',
                                          suffixStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        textAlign: TextAlign.center,
                                        controller: diskon.value,
                                        style: AppFont.regular(),
                                      ),
                                    )
                                  : Expanded(
                                      child: TextField(
                                        inputFormatters: [ThousandsFormatter()],
                                        onChanged: ((String num) {
                                          displaydiskon.value = double.parse(
                                              num.toString()
                                                  .replaceAll(',', ''));
                                          print(displaydiskon);
                                        }),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Potongan harga',
                                          prefixText: 'Rp.',
                                          suffixStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        textAlign: TextAlign.center,
                                        controller: diskon.value,
                                        style: AppFont.regular(),
                                      ),
                                    );
                        }),
                        Container(
                          child: GroupButton(
                            isRadio: true,
                            controller: GroupButtonController(
                                selectedIndex: metode_diskon.value - 1),
                            onSelected: (string, index, bool) {
                              metode_diskon.value = index + 1;
                              print(metode_diskon.value);
                              if (metode_diskon.value == 1) {
                                diskonnominal.value = 0.0;
                              }
                              if (metode_diskon.value == 2) {
                                diskonpersen.value = 0.0;
                              }
                            },
                            buttons: [
                              "Persen",
                              "Nominal",
                            ],
                            options: GroupButtonOptions(
                              selectedShadow: const [],
                              selectedTextStyle: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              selectedColor: AppColor.secondary,
                              unselectedShadow: const [],
                              unselectedColor: Colors.white,
                              unselectedTextStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              //selectedBorderColor: Colors.pink[900],
                              unselectedBorderColor: AppColor.primary,
                              borderRadius: BorderRadius.circular(10),
                              spacing: 5,
                              runSpacing: 5,
                              groupingType: GroupingType.column,
                              direction: Axis.vertical,
                              buttonHeight: context.res_height / 20,
                              buttonWidth: context.res_width,
                              mainGroupAlignment:
                                  MainGroupAlignment.spaceAround,
                              crossGroupAlignment: CrossGroupAlignment.center,
                              groupRunAlignment: GroupRunAlignment.spaceBetween,
                              textAlign: TextAlign.center,
                              textPadding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              elevation: 3,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: button_border_custom(
                                onPressed: () {
                                  metode_diskon.value = 9;
                                  diskon.value.clear();

                                  Get.back();
                                },
                                child: Text(
                                  'Batal',
                                  style: AppFont.regular(),
                                ),
                                width: context.res_width,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: button_solid_custom(
                                onPressed: () {
                                  if (metode_diskon.value == 9) {
                                    Get.showSnackbar(toast().bottom_snackbar_error(
                                        'Gagal',
                                        'Pilih metode diskon terlebih dahulu'));
                                  } else if (diskon.value.text.isEmpty) {
                                    Get.showSnackbar(toast()
                                        .bottom_snackbar_error('Gagal',
                                            'masukan diskon terlebih dahulu'));
                                  } else {
                                    // displaydiskon.value =
                                    //     double.parse(textdiskon.value.text);
                                    // hitungbesardiskonkasir();
                                    // totalval();
                                    hitungPembayaran();

                                    print(
                                        ' jumalh diskon kasir ---------------------> == $jumlahdiskonkasir');
                                    Get.back();
                                  }
                                },
                                child: Text(
                                  'Edit diskon',
                                  style: AppFont.regular_white_bold(),
                                ),
                                width: context.res_width,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            },
          ),
        ),
        barrierDismissible: false);
  }

  popAddPromo() {
    // Get.put(TambahPromoController());
    // Get.put(PromoController());
    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
      child: Material(
          color: Colors.white,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              padding: AppPading.defaultBodyPadding(),
              height: Get.height,
              child: TambahPromoPembayaran())),
    )));
  }

  popAddPelanggan() {
    // Get.put(TambahPromoController());
    // Get.put(PromoController());
    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
      child: Material(
          color: Colors.white,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              padding: AppPading.defaultBodyPadding(),
              height: Get.height,
              child: TambahPelangganPembayaran())),
    )));
  }

  var pelangganvalue = ''.obs;
  var namaPelanggan = ''.obs;

  popListPelanggan() async {
    var con = Get.find<CentralPelangganController>();
    await con.fetchPelangganLocal(id_toko: id_toko, isAktif: true);
    print('fetch pelanggan pop');

    con.pelangganList.refresh();
    //Get.put(PromoController());
    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
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
                    padding: AppPading.customBottomPadding(),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: con.search.value,
                            onChanged: (val) {
                              con.serachPelangganLocal(
                                  id_toko: con.id_toko, search: val);
                            },
                            decoration: InputDecoration(
                              hintText: 'Pencarian',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.primary),
                            child: IconButton(
                                onPressed: () {
                                  Get.put(TambahPelangganController());
                                  popAddPelanggan();
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ))),
                      ],
                    ),
                  ),
                  Obx(() {
                    return Expanded(
                      child: con.pelangganList.isNotEmpty
                          ? ListView.builder(
                              itemCount: con.pelangganList.length,
                              itemBuilder: (context, index) {
                                final customer = con.pelangganList;

                                return Column(children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (customer[index].uuid ==
                                          pelangganvalue.value) {
                                        pelangganvalue.value = '';
                                        namaPelanggan.value = '';
                                        Navigator.pop(context);
                                        Get.showSnackbar(toast()
                                            .bottom_snackbar_error("Berhasil",
                                                'Pelanggan dihapus'));
                                      } else {
                                        pelangganvalue.value =
                                            customer[index].uuid!;
                                        namaPelanggan.value =
                                            customer[index].namaPelanggan!;
                                        print(pelangganvalue.value);
                                        print(namaPelanggan.value);
                                        Navigator.pop(context);
                                        Get.showSnackbar(toast()
                                            .bottom_snackbar_success("Berhasil",
                                                'Pelanggan ditambah'));
                                      }
                                    },
                                    child: ListTile(
                                        trailing: customer[index].uuid ==
                                                pelangganvalue.value
                                            ? Icon(
                                                FontAwesomeIcons.check,
                                                size: 15,
                                                color: AppColor.primary,
                                              )
                                            : null,
                                        title: Text(
                                          customer[index].namaPelanggan!,
                                          style: AppFont.regular(),
                                        ),
                                        subtitle: Text(
                                          customer[index].noHp!,
                                          style: AppFont.small(),
                                        )),
                                  ),
                                  Container(
                                    height: 0.5,
                                    color: Colors.black,
                                  )
                                ]);
                              },
                            )
                          : EmptyData(),
                    );
                  }),
                ],
              ))),
    )));
  }

  searchPromoLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM promo WHERE id_toko = "$id_toko" AND promo.nama_promo LIKE "%${searchpromo.value.text}%" ');
    List<DataPromo> promoli = query.isNotEmpty
        ? query.map((e) => DataPromo.fromJsondb(e)).toList()
        : [];
    promolist.value = promoli;

    return promoli;
  }

  var namaPromo = ''.obs;

  popListPromo() async {
    var con = Get.find<CentralPromoController>();
    con.fetchPromoKasir(id_toko: id_toko);
    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
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
                  padding: AppPading.customBottomPadding(),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchpromo.value,
                          onChanged: (val) {
                            con.searchPromoKasir(
                                id_toko: con.id_toko, search: val);
                          },
                          decoration: InputDecoration(
                            hintText: 'Pencarian',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: AppColor.primary),
                          child: IconButton(
                              onPressed: () {
                                popAddPromo();
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ))),
                    ],
                  ),
                ),
                Obx(() {
                  return Expanded(
                    child: con.promo.isNotEmpty
                        ? ListView.builder(
                            itemCount: con.promo.length,
                            itemBuilder: (context, index) {
                              final promo = con.promo;

                              return Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    if (promo[index].uuid == promolistvalue) {
                                      promolistvalue = null;
                                      namaPromo.value = '';
                                      hitungPembayaran();
                                      Get.back();

                                      Get.showSnackbar(toast()
                                          .bottom_snackbar_error(
                                              "Berhasil", 'Promo dihapus'));
                                    } else {
                                      print(promo[index].uuid! +
                                          '  ' +
                                          promo[index].namaPromo!);
                                      promolistvalue = promo[index].uuid;
                                      namaPromo.value = promo[index].namaPromo!;
                                      hitungPembayaran();
                                      //Navigator.pop(context);
                                      Get.back();
                                      Get.showSnackbar(toast()
                                          .bottom_snackbar_success(
                                              "Berhasil", 'Promo ditambah'));
                                    }
                                  },
                                  child: ListTile(
                                      trailing:
                                          promo[index].uuid == promolistvalue
                                              ? Icon(
                                                  FontAwesomeIcons.check,
                                                  size: 15,
                                                  color: AppColor.primary,
                                                )
                                              : null,
                                      title: Text(
                                        promo[index].namaPromo!,
                                        style: AppFont.regular(),
                                      ),
                                      subtitle: Text(
                                        promo[index].promoNominal != 0.0
                                            ? 'Rp. ' +
                                                AppFormat().numFormat(
                                                    promo[index].promoNominal)
                                            : '% ' +
                                                promo[index]
                                                    .promoPersen
                                                    .toString(),
                                        style: AppFont.small(),
                                      )),
                                ),
                                Container(
                                  height: 0.5,
                                  color: Colors.black,
                                )
                              ]);
                            },
                          )
                        : EmptyData(),
                  );
                }),
              ],
            ),
          )),
    )));
  }

  List<DateTime?> dates = [];
  var pickdate = TextEditingController().obs;
  final dateformat = DateFormat('dd-MM-yyyy');
  var date1;
  var date2;
  var nama = TextEditingController().obs;
  var keterangan = TextEditingController().obs;

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

  var kategoripelangganList = <DataKategoriPelanggan>[].obs;
  var kategorivalue;
  var tambahpromotext = TextEditingController().obs;
  var usertemp = <DataUser>[].obs;
  var promonominal = 0.0.obs;
  var promopersen = 0.0.obs;

  tambahPromo() async {
    var con = Get.find<CentralPromoController>();
    print('-------------------tambah pelanggan local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'promo',
        DataPromo(
          uuid: uuid,
          idToko: id_toko,
          aktif: 1,
          keterangan: keterangan.value.text,
          namaPromo: nama.value.text,
          promoNominal: promonominal.value,
          promoPersen: promopersen.value,
          tglMulai: date1,
          tglSelesai: date2,
        ).DB());

    if (db != null) {
      await con.fetchPromo(id_toko: id_toko);
      await con.fetchPromoKasir(id_toko: id_toko);
      var x = con.promo.where((x) => x.uuid == uuid).first;
      promolistvalue = x.uuid!;
      namaPromo.value = x.namaPromo!;
      hitungPembayaran();
      Get.back();
      Get.back();
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  final formKey = GlobalKey<FormState>();
  var verifikasi_kode = TextEditingController().obs;
  var karyawanlist = <DataKaryawan>[].obs;
  var karyawanvalue;
  var namaKaryawan = ''.obs;
  var indexdisplay = 0.obs;
  var isLogin = false.obs;

  loginKaryawan(uuid, kode, role) async {
    Get.dialog(showloading(), barrierDismissible: false);
    print('-------------------login karyawan---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Karyawan WHERE id_toko = "$id_toko" AND uuid = "$uuid" AND Pin = "$kode" AND role IN ("KASIR")');
    if (query.isNotEmpty) {
      await box.write('karyawan_login', true);
      await box.write('karyawan_id', karyawanvalue);
      await box.write('karyawan_nama', namaKaryawan.value);
      await box.write('karyawan_role', rolevalue);

      print(box.read('karyawan_role', fallback: null));
      print(box.read('karyawan_id', fallback: null));
      print(box.read('karyawan_nama', fallback: null));
      isLogin.value = true;
      Get.back();
      Get.back();

      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Gagal', 'periksa pin / jabatan'));
    }
  }

  loginKaryawanUlang(uuid, kode, role) async {
    Get.dialog(showloading(), barrierDismissible: false);
    print('-------------------login karyawan---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Karyawan WHERE id_toko = "$id_toko" AND uuid = "$uuid" AND Pin = "$kode" AND role IN ("KASIR")');
    if (query.isNotEmpty) {
      await box.remove('karyawan_login');
      await box.remove('karyawan_nama');
      await box.remove('karyawan_id');
      await box.remove('karyawan_role');

      await box.write('karyawan_login', true);
      await box.write('karyawan_id', karyawanvalue);
      await box.write('karyawan_nama', namaKaryawan.value);
      await box.write('karyawan_role', rolevalue);

      print(box.read('karyawan_role', fallback: null));
      print(box.read('karyawan_id', fallback: null));
      print(box.read('karyawan_nama', fallback: null));

      isLogin.value = true;
      Get.back();
      Get.back();

      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Gagal', 'periksa pin / jabatan'));
    }
  }

  var isbuka = false.obs;
  var rolevalue;

  popLoginKaryawan() {
    print('<------------------- POP LOGIN KARYAWN -------------------------->');
    // verifikasi_kode.value.dispose();
    verifikasi_kode.value = TextEditingController();
    isLogin.value = false;
    var con = Get.find<CentralKaryawanController>();
    //con.fetchKaryawanLocal(id_toko: id_toko);
    Get.dialog(
        barrierDismissible: false,
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            print('pop');
            if (isLogin.value == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                var con = Get.find<BasemenuController>();
                con.index.value = 0;
                Get.back();
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
                                      'Login kasir',
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
                                    items: con.karyawanList.map((x) {
                                      return DropdownMenuItem(
                                        child: Text(x.nama_karyawan!),
                                        value: x.uuid,
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      rolevalue = con.karyawanList
                                          .where(
                                              (x) => x.uuid == val.toString())
                                          .first
                                          .role;
                                      namaKaryawan.value = con.karyawanList
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
                                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
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
                                        onPressed: () {
                                          loginKaryawan(
                                              karyawanvalue,
                                              verifikasi_kode.value.text,
                                              rolevalue);
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

  popLoginKaryawanUlang() {
    print(
        '<------------------- POP LOGIN KARYAWN Ualng -------------------------->');

    var templogin = true;
    var tempkaryawan_nama = namaKaryawan.value;
    var tempid = karyawanvalue;
    var temprole = rolevalue;
    // verifikasi_kode.value.dispose();
    verifikasi_kode.value = TextEditingController();
    isLogin.value = false;
    var con = Get.find<CentralKaryawanController>();
    //con.fetchKaryawanLocal(id_toko: id_toko);
    Get.dialog(
        barrierDismissible: false,
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            print('pop');
            if (isLogin.value == false) {
              await box.write('karyawan_login', true);
              namaKaryawan.value = tempkaryawan_nama;
              karyawanvalue = tempid;
              rolevalue = temprole;
              print(namaKaryawan.value);
              print(karyawanvalue);
              print(rolevalue);
              Get.back();
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
                                      'Ganti kasir',
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
                                    items: con.karyawanList.map((x) {
                                      return DropdownMenuItem(
                                        child: Text(x.nama_karyawan!),
                                        value: x.uuid,
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      rolevalue = con.karyawanList
                                          .where(
                                              (x) => x.uuid == val.toString())
                                          .first
                                          .role;
                                      namaKaryawan.value = con.karyawanList
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
                                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
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
                                        onPressed: () {
                                          loginKaryawanUlang(
                                              karyawanvalue,
                                              verifikasi_kode.value.text,
                                              rolevalue);
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

  fetchKaryawanLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Karyawan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKaryawan> data =
          query.map((e) => DataKaryawan.fromJsondb(e)).toList();
      karyawanlist.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  var keranjangv2 = <DataKeranjang>[].obs;

  void decrementItem(int index) {
    final item = keranjangv2[index];
    item.qty--;

    // reload stock
    if (!item.isPaket) {
      loadStock(item.uuid);
    } else {
      for (var d in detailpaket) {
        loadStock(d.id_produk!);
      }
    }

    // adjust subtotal
    final hargaPer = item.isPaket ? item.hargaPaket : item.hargaEceran!;
    subtotal.value -= hargaPer!;

    // recalc tax
    totalTax.value = keranjangv2.fold<double>(
      0.0,
      (sum, e) => sum + ((e.price * e.nominalpajak! / 100) * e.qty),
    );

    // recalc total items
    totalItem.value = keranjangv2.fold<int>(
      0,
      (sum, e) => sum + e.qty,
    );

    // remove if zero
    if (item.qty <= 0) {
      final removed = keranjangv2.removeAt(index);
      deletedDetailIds.add(removed.uuid!);
    }

    // do any final calculations
    hitungPembayaran();

    // notify GetX that the list changed
    keranjangv2.refresh();
  }

  void addToCart(dynamic item) async {
    if (item is DataProduk) {
      print('item is product');
      _addProduct(item);
    } else if (item is DataPaketProduk) {
      // _addPackagev2(item);
      print('item is paket');
      _addPackagev3(item);
      //checkqtypaket(item);
    } else if (item is DataKeranjang && item.isPaket == false) {
      print('tambah qty produk dari keranjang');
      _addProductFromCart(item);
    } else if (item is DataKeranjang && item.isPaket == true) {
      print('tambah qty paket dari keranjang');
      _addPackageFromCart(item);
    }
  }

  Future<Map<String, int>> _computeReservedByProduct() async {
    final allProducts = Get.find<CentralProdukController>().produk;
    // 1. Start from zero.
    final reserved = <String, int>{};

    // 2. Sum up loose items from current cart.
    //    Take a snapshot of keranjangv2 to avoid concurrent-modification.
    for (final item in keranjangv2.where((i) => !i.isPaket).toList()) {
      reserved[item.uuid] = (reserved[item.uuid] ?? 0) + item.qty;
    }

    // 3. Fetch and sum up every package in current cart.
    for (final paketItem in keranjangv2.where((i) => i.isPaket).toList()) {
      final details = await fetchdetailpaket(
        id_toko: paketItem.idToko,
        id_paket_produk: paketItem.uuid,
      );
      for (final d in details) {
        reserved[d.id_produk.toString()] =
            (reserved[d.id_produk.toString()] ?? 0) + (d.qty * paketItem.qty)
                as int;
      }
    }

    // 4. NEW: Sum up items from ALL saved carts
    //    Also snapshot savedCart so removals elsewhere won’t break this loop.
    for (final savedCartItem in savedCart.toList()) {
      // Loose items in saved cart
      for (final item in savedCartItem.item.where((i) => !i.isPaket).toList()) {
        reserved[item.uuid] = (reserved[item.uuid] ?? 0) + item.qty;
      }

      // Packages in saved cart
      for (final paketItem
          in savedCartItem.item.where((i) => i.isPaket).toList()) {
        final details = await fetchdetailpaket(
          id_toko: paketItem.idToko,
          id_paket_produk: paketItem.uuid,
        );
        for (final d in details) {
          reserved[d.id_produk.toString()] =
              (reserved[d.id_produk.toString()] ?? 0) + (d.qty * paketItem.qty)
                  as int;
        }
      }
    }

    return reserved;
  }

// Optional: Helper method to remove a saved cart and update stock
  void removeSavedCart(int index) {
    if (index >= 0 && index < savedCart.length) {
      savedCart.removeAt(index);
      savedCart.refresh();
      // Stock will be automatically updated on next addToCart call
      // since _computeReservedByProduct will recalculate without this cart
    }
  }

  Future<void> _addProductFromCart(DataKeranjang produk) async {
    print('add product from cart -->');
    var prod = Get.find<CentralProdukController>().produk;
    var prodById = prod.where((p) => p.uuid == produk.uuid).first;
    // 1) Quick early‐out if zero stock
    if (prodById.qty! <= prodById.info_stok_habis! &&
        prodById.tampilkan_di_produk == 1 &&
        prodById.hitung_stok == 1) {
      Get.showSnackbar(
          toast().bottom_snackbar_error("Error", 'Stock sudah habis!'));
      return;
    }

    // 2) Compute how many already reserved in packages
    final reserved = await _computeReservedByProduct();
    final existingIndex =
        keranjangv2.indexWhere((i) => i.uuid == produk.uuid && !i.isPaket);

    final currentLooseQty =
        existingIndex >= 0 ? keranjangv2[existingIndex].qty : 0;
    // if we add one more:
    final newTotalReserved = (reserved[prodById.uuid] ?? 0) + 1;

    if (prodById.hitung_stok == 1 &&
        prodById.tampilkan_di_produk == 1 &&
        newTotalReserved > prodById.qty! - prodById.info_stok_habis!) {
      Get.showSnackbar(
          toast().bottom_snackbar_error("Error", 'Stock tidak mencukupi'));
      return;
    }

    // 3) Passed → insert or increment
    if (existingIndex == -1) {
      keranjangv2.add(DataKeranjang(
        uuid: prodById.uuid!,
        idToko: prodById.id_toko!,
        qty: 1,
        pajak: prodById.pajak,
        hpp: prodById.hpp,
        nominalpajak: prodById.nominalpajak,
        namaPajak: prodById.namaPajak,
        gambar: prodById.gambar_produk_utama,
        namaProduk: prodById.nama_produk,
        hargaEceran: prodById.diskon != 0.0
            ? prodById.harga_jual_eceran! - prodById.harga_jual_eceran!
            : prodById.harga_jual_eceran,
        isPaket: false,
      ));
    } else {
      keranjangv2[existingIndex].qty++;
    }

    loadStock(produk.uuid);
    _updateTotals();
  }

  Future<void> _addPackageFromCart(
    DataKeranjang paket, {
    int packageQty = 1,
  }) async {
    print('add package -->');
    // Load product master once
    var pp = Get.find<CentralPaketController>().paketproduk;

    var selectpaket = pp.where((p) => p.uuid == paket.idPaket).first;

    await Get.find<CentralProdukController>()
        .fetchProdukLocal(id_toko: id_toko);
    final productsById = {
      for (var p in Get.find<CentralProdukController>().produk)
        p.uuid.toString(): p,
    };

    // Fetch details of this package
    final produkinpackage = await fetchdetailpaket(
      id_toko: id_toko,
      id_paket_produk: paket.idPaket,
    );

    // 1) Compute current reservations
    final reserved = await _computeReservedByProduct();

    // 2) Simulate adding this package
    for (var detail in produkinpackage) {
      final pid = detail.id_produk.toString();
      final newReserved = (reserved[pid] ?? 0) + detail.qty * packageQty;
      reserved[pid] = newReserved.toInt();
    }

    // 3) Check against stock
    final lacking = <String>[];
    final inactive = <String>[];
    for (var detail in produkinpackage) {
      final pid = detail.id_produk.toString();
      final local = productsById[pid];

      if (local != null && local.tampilkan_di_produk == 0) {
        inactive.add(local.nama_produk ?? '');
      }

      if (local != null && local.hitung_stok == 1) {
        final need = reserved[pid]!;
        final have = local.qty! - local.info_stok_habis!;
        if (have < need) {
          int stock = await getAvailableStock(pid);
          lacking.add('${local.nama_produk}: perlu $need, sisa $stock');
        }
      }
    }

    if (inactive.isNotEmpty) {
      Get.snackbar(
        'Produk tidak aktif :',
        inactive.join(', '), // <-- all product names
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (lacking.isNotEmpty) {
      Get.snackbar('Stok tidak cukup', lacking.join('\n'),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 4) Passed → add/increment package entry
    final idx =
        keranjangv2.indexWhere((i) => i.uuid == paket.uuid && i.isPaket);
    if (idx == -1) {
      keranjangv2.add(DataKeranjang(
        uuid: selectpaket.uuid!,
        idPaket: selectpaket.uuid!,
        idToko: selectpaket.id_toko!,
        qty: packageQty,
        pajak: selectpaket.pajak,
        hpp: selectpaket.hpp,
        nominalpajak: selectpaket.nominalpajak,
        namaPajak: selectpaket.namapajak,
        gambar: selectpaket.gambar_utama,
        namaPaket: selectpaket.nama_paket,
        hargaPaket: selectpaket.diskon != 0.0
            ? selectpaket.harga_jual_paket! - selectpaket.diskon!
            : selectpaket.harga_jual_paket,
        isPaket: true,
      ));
    } else {
      keranjangv2[idx].qty += packageQty;
    }

    for (var detail in produkinpackage) {
      final pid = detail.id_produk.toString();
      loadStock(pid);
    }

    _updateTotals();
  }

  Future<void> _addProduct(DataProduk produk) async {
    print('add product -->');
    // 1) Quick early‐out if zero stock
    if (produk.qty == produk.info_stok_habis &&
        produk.tampilkan_di_produk == 1 &&
        produk.hitung_stok == 1) {
      Get.showSnackbar(
          toast().bottom_snackbar_error("Error", 'Stock sudah habis!'));
      return;
    }

    // 2) Compute how many already reserved in packages

    final reserved = await _computeReservedByProduct();

    final existingIndex =
        keranjangv2.indexWhere((i) => i.uuid == produk.uuid && !i.isPaket);

    final currentLooseQty =
        existingIndex >= 0 ? keranjangv2[existingIndex].qty : 0;
    // if we add one more:
    final newTotalReserved = (reserved[produk.uuid] ?? 0) + 1;

    if (produk.hitung_stok == 1 &&
        produk.tampilkan_di_produk == 1 &&
        newTotalReserved > produk.qty! - produk.info_stok_habis!) {
      Get.showSnackbar(
          toast().bottom_snackbar_error("Error", 'Stock tidak mencukupi'));
      return;
    }

    // 3) Passed → insert or increment
    if (existingIndex == -1) {
      keranjangv2.add(DataKeranjang(
        uuid: produk.uuid!,
        idToko: produk.id_toko!,
        qty: 1,
        pajak: produk.pajak,
        hpp: produk.hpp,
        nominalpajak: produk.nominalpajak,
        namaPajak: produk.namaPajak,
        gambar: produk.gambar_produk_utama,
        namaProduk: produk.nama_produk,
        hargaEceran: produk.diskon != 0.0
            ? produk.harga_jual_eceran! - produk.diskon!
            : produk.harga_jual_eceran,
        isPaket: false,
      ));
    } else {
      keranjangv2[existingIndex].qty++;
    }
    loadStock(produk.uuid!);
    _updateTotals();
  }

  var detailpaket = <DataDetailPaketProduk>[].obs;

  fetchdetailpaket({id_toko, id_paket_produk}) async {
    print('-------------------fetch pajak local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      detail_paket_produk.*, 
      produk.nama_produk AS nama_produk,
      produk.harga_beli AS harga_beli_produk,
      produk.gambar_produk_utama AS gambar_produk
    
  FROM 
      detail_paket_produk 
  LEFT JOIN 
     produk ON detail_paket_produk.id_produk = produk.uuid
  WHERE 
      detail_paket_produk.id_toko = "$id_toko" AND detail_paket_produk.id_paket_produk = "$id_paket_produk"
 
  ''');
    if (query.isNotEmpty) {
      List<DataDetailPaketProduk> data =
          query.map((e) => DataDetailPaketProduk.fromJsondb(e)).toList();
      detailpaket.value = data;
      //print(data.first.uuid);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  Future<void> _addPackagev3(
    DataPaketProduk paket, {
    int packageQty = 1,
  }) async {
    print('add package -->');
    // Load product master once
    await Get.find<CentralProdukController>()
        .fetchProdukLocal(id_toko: id_toko);
    final productsById = {
      for (var p in Get.find<CentralProdukController>().produk)
        p.uuid.toString(): p,
    };

    // Fetch details of this package
    final produkinpackage = await fetchdetailpaket(
      id_toko: id_toko,
      id_paket_produk: paket.uuid,
    );

    // 1) Compute current reservations
    final reserved = await _computeReservedByProduct();

    // 2) Simulate adding this package
    for (var detail in produkinpackage) {
      final pid = detail.id_produk.toString();
      final newReserved = (reserved[pid] ?? 0) + detail.qty * packageQty;
      reserved[pid] = newReserved.toInt();
    }

    // 3) Check against stock
    final lacking = <String>[];
    final inactive = <String>[];
    for (var detail in produkinpackage) {
      final pid = detail.id_produk.toString();
      final local = productsById[pid];

      if (local != null && local.tampilkan_di_produk == 0) {
        inactive.add(local.nama_produk ?? '');
      }

      if (local != null &&
          local.hitung_stok == 1 &&
          local.tampilkan_di_produk == 1) {
        final need = reserved[pid]!;
        final have = local.qty! - local.info_stok_habis!;

        if (have < need) {
          int stock = await getAvailableStock(pid);
          lacking.add('${local.nama_produk}: perlu $need, sisa $stock');
        }
      }
    }

    // 2) Show snackbar if inactive products exist
    if (inactive.isNotEmpty) {
      Get.snackbar(
        'Produk tidak aktif :',
        inactive.join(', '), // <-- all product names
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (lacking.isNotEmpty) {
      Get.snackbar('Stok tidak cukup', lacking.join('\n'),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 4) Passed → add/increment package entry
    final idx =
        keranjangv2.indexWhere((i) => i.uuid == paket.uuid && i.isPaket);
    if (idx == -1) {
      keranjangv2.add(DataKeranjang(
        uuid: paket.uuid!,
        idPaket: paket.uuid!,
        idToko: paket.id_toko!,
        qty: packageQty,
        pajak: paket.pajak,
        hpp: paket.hpp,
        nominalpajak: paket.nominalpajak,
        namaPajak: paket.namapajak,
        gambar: paket.gambar_utama,
        namaPaket: paket.nama_paket,
        hargaPaket: paket.diskon != 0.0
            ? paket.harga_jual_paket! - paket.diskon!
            : paket.harga_jual_paket,
        isPaket: true,
      ));
    } else {
      keranjangv2[idx].qty += packageQty;
    }

    for (var detail in produkinpackage) {
      final pid = detail.id_produk.toString();
      loadStock(pid);
    }

    _updateTotals();
  }

  void _updateTotals() {
    totalItem.value = keranjangv2.fold(0, (sum, item) => sum + item.qty);
    subtotal.value =
        keranjangv2.fold(0.0, (sum, item) => sum + (item.price * item.qty));
    totalTax.value = keranjangv2.fold(
      0.0,
      (sum, item) => sum + ((item.price * item.nominalpajak! / 100) * item.qty),
    );
    print('total item --->');
    print(totalItem.value);
    print('subtotal --->');
    print(subtotal.value);
    print('total TAX --->');
    print(totalTax.value);
    hitungPembayaran();
    keranjangv2.refresh();
  }

  addKeranjang(DataProduk produkCahce) async {
    var produk = Get.find<CentralProdukController>().produk;
    var check =
        produk.where((element) => element.uuid == produkCahce.uuid).first;
    print('add keranjang ===>' + produkCahce.nama_produk!);
    final existingIndex =
        keranjang.indexWhere((item) => item.uuid == produkCahce.uuid);

    if (check.qty == 0 &&
        check.tampilkan_di_produk == 1 &&
        check.hitung_stok == 1) {
      Get.showSnackbar(toast().bottom_snackbar_error(
          "Error", 'Stock sudah habis! harap isi stock terlebih dahulu'));
      return;
    }

    if (existingIndex == -1) {
      keranjang.add(DataProdukTemp(
        uuid: produkCahce.uuid,
        id_toko: id_toko,
        qty: 1,
        pajak: produkCahce.pajak,
        hpp: produkCahce.hpp,
        nominalpajak: produkCahce.nominalpajak,
        namaPajak: produkCahce.pajak,
        gambar_produk_utama: produkCahce.gambar_produk_utama,
        harga_jual_eceran: produkCahce.harga_jual_eceran,
        nama_produk: produkCahce.nama_produk,
      ));
      keranjang.refresh();
    } else {
      if (keranjang[existingIndex].qty >= check.qty! &&
          check.tampilkan_di_produk == 1 &&
          check.hitung_stok == 1) {
        Get.showSnackbar(
            toast().bottom_snackbar_error("Error", 'Stock tidak mencukupi'));

        return;
      }

      keranjang[existingIndex].qty++;
      keranjang.refresh();
    }
    totalItem.value = keranjang.fold(0, (sum, item) => sum + (item.qty ?? 0));
    subtotal.value = keranjang.fold(
        0.0, (sum, item) => sum + (item.harga_jual_eceran! * item.qty));
  }

  var totalitem = 0.obs;
  var cartitem = 0.obs;

  RxString username = ''.obs;

  var token = ''.obs;
  var logo = ''.obs;
  var toko = ''.obs;

  List<String> produklist = ['kopi', 'milo', 'indomie', 'supermie', 'arabica'];

  var tampilan = ''.obs;

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

  var index = 0.obs;

  List<IconData> icons = [
// The underscore declares a variable as private in dart.
    FontAwesomeIcons.home,

    FontAwesomeIcons.cashRegister,
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

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
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

  var pickedIconPath = ''.obs;

  Future<String> svgToBase64(String assetPath) async {
    final String svgString = await rootBundle.loadString(assetPath);
    return base64Encode(utf8.encode(svgString));
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

  var tanggal = TextEditingController().obs;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  stringdate() {
    var ff = dateFormat.format(datedata.first!);
    tanggal.value.text = ff;
  }

  tambahPelangganLocal() async {
    var con = Get.find<TambahPelangganController>();
    print('-------------------tambah pelanggan local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'pelanggan',
        DataPelanggan(
          uuid: uuid,
          idToko: id_toko,
          email: con.email.value.text,
          alamat: con.alamat.value.text,
          namaPelanggan: con.nama.value.text,
          noHp: con.telepon.value.text,
          tglLahir: con.tanggal.value.text,
          foto: con.image64,
          statusPelanggan: 1,
          idKategori: con.kategorivalue,
        ).DB());

    if (db != null) {
      // await Get.find<PelangganController>()
      //     .fetchPelangganLocal(id_toko: id_toko);
      await Get.find<CentralPelangganController>()
          .fetchPelangganLocal(id_toko: id_toko, isAktif: true);

      var conpelanggan = Get.find<CentralPelangganController>();
      var x =
          conpelanggan.pelangganList.where((element) => element.uuid == uuid);
      pelangganvalue.value = x.first.uuid!;

      namaPelanggan.value = x.first.namaPelanggan!;
      print(pelangganvalue.value);
      print(namaPelanggan.value);
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'Berhasil registrasi'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}

class TambahPromoPembayaran extends GetView<KasirController> {
  const TambahPromoPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Tambah Promo',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nama.value,
                        decoration: InputDecoration(
                          labelText: 'kode Promo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'kode promo harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  Obx(
                    () {
                      return Padding(
                        padding: AppPading.customBottomPadding(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(() {
                                return TextFormField(
                                  inputFormatters: [ThousandsFormatter()],
                                  controller: controller.promo.value,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        controller.selecteddiskon.value ==
                                                controller.opsidiskon[0]
                                            ? const Icon(Icons.money)
                                            : const Icon(Icons.percent),
                                    labelText: 'Nilai Promo',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Diskon harus diisi';
                                    final parsed = double.tryParse(value
                                        .replaceAll(RegExp(r'[^0-9.]'), ''));
                                    if (parsed == null)
                                      return 'Masukkan angka valid';
                                    if (controller.selecteddiskon.value ==
                                            controller.opsidiskon[0] &&
                                        parsed <= 0) {
                                      return 'Nominal harus > 0';
                                    }
                                    if (controller.selecteddiskon.value !=
                                            controller.opsidiskon[0] &&
                                        (parsed <= 0 || parsed > 100)) {
                                      return 'Persen harus 1-100';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final cleanValue = value.replaceAll(
                                        RegExp(r'[^0-9.]'), '');
                                    final parsed = double.tryParse(cleanValue);
                                    if (parsed == null) return;

                                    if (controller.selecteddiskon.value ==
                                        controller.opsidiskon[0]) {
                                      controller.diskonpersen.value = 0.0;
                                      controller.diskonnominal.value = parsed;
                                      print('nominal');
                                      print('nominal --> ' +
                                          controller.diskonnominal.value
                                              .toString() +
                                          'persen --> ' +
                                          controller.diskonpersen.value
                                              .toString());
                                    } else {
                                      controller.diskonnominal.value = 0.0;
                                      controller.diskonpersen.value = parsed;
                                      print('persen');
                                      print('nominal --> ' +
                                          controller.diskonnominal.value
                                              .toString() +
                                          'persen --> ' +
                                          controller.diskonpersen.value
                                              .toString());
                                    }
                                  },
                                );
                              }),
                            ),
                            Expanded(
                              child: Obx(() {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: RadioMenuButton(
                                        value: controller.opsidiskon[0],
                                        groupValue:
                                            controller.selecteddiskon.value,
                                        onChanged: (x) => controller
                                            .selecteddiskon.value = x!,
                                        child: const Text('Rp.'),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioMenuButton(
                                        value: controller.opsidiskon[1],
                                        groupValue:
                                            controller.selecteddiskon.value,
                                        onChanged: (x) => controller
                                            .selecteddiskon.value = x!,
                                        child: const Text('%'),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Obx(() {
                    return Container(
                      //color: Colors.red,
                      margin: AppPading.customBottomPadding(),
                      //width: 200,
                      child: TextFormField(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Get.dialog(AlertDialog(
                            surfaceTintColor: Colors.white,
                            content: Container(
                              width: context.res_width / 1.5,
                              //height: context.height_query / 1.5,
                              child: CalendarDatePicker2WithActionButtons(
                                  config:
                                      CalendarDatePicker2WithActionButtonsConfig(
                                    weekdayLabels: [
                                      'Ming',
                                      'Sen',
                                      'Sel',
                                      'Rab',
                                      'Kam',
                                      'Jum',
                                      'Sab',
                                    ],
                                    firstDayOfWeek: 1,
                                    controlsTextStyle:
                                        const TextStyle(fontSize: 10),
                                    weekdayLabelTextStyle:
                                        const TextStyle(fontSize: 10),
                                    calendarType: CalendarDatePicker2Type.range,
                                    centerAlignModePicker: true,
                                  ),
                                  value: controller.dates,
                                  onOkTapped: () {
                                    Get.back();
                                    print('tgl-----------------------------');
                                  },
                                  onValueChanged: (dates) {
                                    var list = <String>[];
                                    var start = dates.first;
                                    final end = dates.last;
                                    controller.pickdate.value.text =
                                        (controller.dateformat.format(start!) +
                                            ' - ' +
                                            controller.dateformat.format(end!));

                                    controller.date1 =
                                        controller.dateformat.format(start);
                                    controller.date2 =
                                        controller.dateformat.format(end);
                                    print(controller.date1);
                                    print(controller.date2);
                                  }),
                            ),
                          ));
                        },
                        readOnly: true,
                        controller: controller.pickdate.value,
                        onChanged: ((String pass) {
                          // controller.fetchDataBeban();
                        }),
                        decoration: InputDecoration(
                            labelText: "Masa Berlaku",
                            labelStyle: AppFont.regular(),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pilih masa berlaku';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.keterangan.value,
                        decoration: InputDecoration(
                          labelText: 'Keterangan',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Alamat harus diisi';
                        //   }
                        //   return null;
                        // },
                      ),
                    );
                  }),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahPromo();
                        }
                        //Get.toNamed('/setuptoko');
                        // Get.toNamed('/loginform');
                      },
                      child: Text(
                        'Tambah',
                        style: AppFont.regular_white_bold(),
                      ),
                      width: context.res_width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//TODO : tambah user via kasir

class TambahPelangganPembayaran extends GetView<TambahPelangganController> {
  const TambahPelangganPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<KasirController>();
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Pelanggan Baru',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Container(
                      margin: AppPading.customBottomPadding(),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 0.5)),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 40, top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            controller.pikedImagePath.value == '' &&
                                    controller.pickedIconPath.value == ''
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.primary,
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.image,
                                          color: Colors.white,
                                          size: 55,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(8),
                                            backgroundColor: AppColor.secondary,
                                          ),
                                          onPressed: () async {
                                            DeviceInfoPlugin deviceInfo =
                                                DeviceInfoPlugin();
                                            AndroidDeviceInfo androidInfo =
                                                await deviceInfo.androidInfo;
                                            if (androidInfo.version.sdkInt >=
                                                33) {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            } else {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            }

                                            controller.pilihsourcefoto();
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.primary,
                                        ),
                                        child: ClipOval(
                                          child: controller.pikedImagePath != ''
                                              ? Image.file(
                                                  File(controller
                                                      .pickedImageFile!.path),
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                )
                                              : SvgPicture.asset(
                                                  controller
                                                      .pickedIconPath.value,
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(8),
                                            backgroundColor: AppColor.secondary,
                                          ),
                                          onPressed: () async {
                                            DeviceInfoPlugin deviceInfo =
                                                DeviceInfoPlugin();
                                            AndroidDeviceInfo androidInfo =
                                                await deviceInfo.androidInfo;
                                            if (androidInfo.version.sdkInt >=
                                                33) {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            } else {
                                              var status = await Permission
                                                  .camera.status;
                                              if (!status.isGranted) {
                                                await Permission.camera
                                                    .request();
                                              }
                                            }

                                            controller.pilihsourcefoto();
                                          },
                                          child: FaIcon(
                                            FontAwesomeIcons.pencil,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_border_custom(
                        onPressed: () async {
                          if (await controller.checkContactPermission()) {
                            controller.selectContact();
                          } else {
                            Get.snackbar(
                              'Izin Diperlukan',
                              'Silakan berikan izin akses kontak terlebih dahulu',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Text('Tambah dari kontak'),
                        width: context.res_width),
                  ),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nama.value,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.email.value,
                        decoration: InputDecoration(
                          labelText: 'Email (Optional)',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Email harus diisi';
                        //   } else if (value.isEmail == false) {
                        //     return 'Periksa format email';
                        //   }
                        //   return null;
                        // },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.telepon.value,
                        decoration: InputDecoration(
                          labelText: 'Nomor telepon',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nomor telepon harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Kategori pelanggan harus dipilih';
                                }
                                return null;
                              },
                              isExpanded: true,
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white)),
                              hint: Text('Kategori Pelanggan',
                                  style: AppFont.regular()),
                              value: controller.kategorivalue,
                              items: controller.kategoripelangganList.map((x) {
                                return DropdownMenuItem(
                                  child: Text(x.kategori!),
                                  value: x.uuid,
                                );
                              }).toList(),
                              onChanged: (val) {
                                controller.kategorivalue = val;
                                print(controller.kategorivalue);
                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.primary),
                              child: IconButton(
                                  onPressed: () {
                                    Get.toNamed('/tambahkategoripelanggan',
                                        arguments: Get.put(
                                            KategoriPelangganController()));
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ))),
                        ],
                      ),
                    );
                  }),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: Container(
                      child: TextFormField(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Container(
                                        width: context.res_width * 0.9,
                                        height: context.res_height * 0.6,
                                        child:
                                            CalendarDatePicker2WithActionButtons(
                                          config:
                                              CalendarDatePicker2WithActionButtonsConfig(
                                            dayMaxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    7 -
                                                10,
                                            controlsTextStyle: TextStyle(
                                              fontSize: 10, // Adjust font size
                                              fontWeight: FontWeight
                                                  .bold, // Make it bold
                                              color: Colors
                                                  .blue, // Change text color
                                            ),

                                            // Adjust day width based on screen width
                                            weekdayLabelTextStyle:
                                                TextStyle(fontSize: 10),
                                            weekdayLabels: [
                                              'Ming',
                                              'Sen',
                                              'Sel',
                                              'Rab',
                                              'Kam',
                                              'Jum',
                                              'Sab',
                                            ],
                                            firstDayOfWeek: 1,

                                            calendarType:
                                                CalendarDatePicker2Type.single,
                                          ),
                                          onCancelTapped: () {
                                            Get.back();
                                          },
                                          value: controller.datedata,
                                          onValueChanged: (dates) {
                                            print(dates);
                                            controller.datedata = dates;
                                            controller.stringdate();
                                            Get.back();
                                          },
                                        )),
                                  ));
                        },
                        controller: controller.tanggal.value,
                        onChanged: ((String pass) {}),
                        decoration: InputDecoration(
                          labelText: "Tanggal Lahir (opsional)",
                          labelStyle: AppFont.regular(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.alamat.value,
                        decoration: InputDecoration(
                          labelText: 'Alamat (Opsional)',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Alamat harus diisi';
                        //   }
                        //   return null;
                        // },
                      ),
                    );
                  }),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          con.tambahPelangganLocal();
                        }
                        //Get.toNamed('/setuptoko');
                        // Get.toNamed('/loginform');
                      },
                      child: Text(
                        'Tambah',
                        style: AppFont.regular_white_bold(),
                      ),
                      width: context.res_width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
