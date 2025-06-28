import 'dart:io';
import 'dart:typed_data';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Controllers/printerController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/model_penjualan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20Pelanggan/model_pelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/add/controller_tambahpromo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/add/view_tambahpromo.dart';
import 'package:qasir_pintar/Widget/popscreen.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:uuid/uuid.dart';

import '../../Database/DB_helper.dart';
import '../../Widget/widget.dart';
import '../Kasir - Rincian Pembayaran/view_rincianpembayaran.dart';
import '../Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';
import '../Promo/controller_promo.dart';
import '../Promo/model_promo.dart';
import '../Users/model_user.dart';

class PembayaranController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('init pembayranadasdsada');
    await fetchPromo(id_toko: id_toko);
    await Get.find<CentralPelangganController>()
        .fetchPelangganLocal(id_toko: id_toko);
    if (data != null) {
      keranjang.value = data['keranjang'];
      // totalItem.value = data['totalItem'];
      // subtotal.value = data['subtotal'];
      // sub = keranjang.fold(
      //     0.0, (sum, item) => sum + (item.harga_jual_eceran! * item.qty));
    }
    totalItem.value = keranjang.fold(0, (sum, item) => sum + (item.qty ?? 0));
    subtotal.value = keranjang.fold(
        0.0, (sum, item) => sum + (item.harga_jual_eceran! * item.qty));
    print('item :' + totalItem.toString());
    print('subtotal :' + subtotal.toString());
    selecteddiskon.value = opsidiskon[0];
    await totalval();
  }

  var id_toko = GetStorage().read('uuid');
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

  var data = Get.arguments;
  var sub;
  var jumlahdiskonkasir = 0.0.obs;
  var pelangganpilih = DataPelanggan;

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

  hitungpromo(uuid) {
    // print('hitung prom----->');
    // if (promodisplay.value == true) {
    //   var p = promolist.where((x) => x.uuid == uuid).first;
    //   print(p.promoNominal.toString() + '----' + p.promoPersen.toString());
    //
    //   if (p.promoNominal == 0.0) {
    //     print('promo persen --->');
    //     promovalue.value = subtotal.value * p.promoPersen! / 100;
    //   } else {
    //     print('promo nominal --->');
    //     promovalue.value = p.promoNominal!;
    //   }
    // } else {
    //   promovalue.value = 0.0;
    // }
    if (namaPromo.value == '') {
      print('tidak ada nama promo');
      promovalue.value = 0.0;
      return;
    }
    print('hitung prom new----->');
    var p = promolist.where((x) => x.uuid == uuid).first;
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
    var total1 = subtotal.value - jumlahdiskonkasir.value - promovalue.value;
    var ppn1 = 11 / 100 * total1;
    if (ppnSwitch.value == true) {
      ppn.value = ppn1;
      return total.value = total1 + ppn1;
    } else {
      ppn.value = 0.0;
      return total.value = total1;
    }
  }

  hitungPembayaran(promouuid) {
    hitungbesardiskonkasir();
    hitungpromo(promouuid);
    totalval();
  }

  var uuidpenjualanstruk;
  var nofaktur;
  var printtotalbayar;

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
              totalDiskon: displaydiskon.value ?? 0.0,
              namaPelanggan: namaPelanggan.value,
              namaPromo: namaPromo.value)
          .DB(),
    );

    if (bayar != null) {
      for (DataProdukTemp produk in keranjang) {
        var uuuidDetailpenjualan = Uuid().v4();
        var detail = await DBHelper().INSERT(
            'detail_penjualan',
            DataDetailPenjualan(
                    uuid: uuuidDetailpenjualan,
                    totalHarga: total.value,
                    qty: produk.qty,
                    idToko: id_toko,
                    idProduk: produk.uuid,
                    subtotal: produk.harga_jual_eceran! * produk.qty,
                    discNominal: diskonnominal.value,
                    discPersen: diskonpersen.value,
                    idPenjualan: uuidpenjualan)
                .DB());

        print('update stock ---->' +
            produk.nama_produk! +
            ' ' +
            produk.qty.toString());
        await DBHelper().decrementQty(
            table: 'stock_produk',
            id_produk: produk.uuid!,
            decrement: produk.qty);
      }
      Popscreen().berhasilbayar(this);
      await Get.find<KasirController>().fetchProdukLocal(id_toko: id_toko);
      clearAll();

      //Popscreen().berhasilbayar(this);
      // Get.back(closeOverlays: true);
      // Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
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
    );
    final List<DataProdukTemp> daftarItem = List.from(keranjang);
    await conprint.printPenjualanReceipt(
        penjualan: penjualanprint,
        items: daftarItem,
        namaPelanggan: namaPelanggan.value,
        NamaToko: GetStorage().read('user_business_name') ?? 'QASIR PINTAR');
  }

  RxList<String> deletedDetailIds = <String>[].obs;
  clearAll() {
    print('clear all -->');
    var x = Get.find<KasirController>();
    x.keranjang.value.clear();
    x.keranjang.refresh();
    x.totalitem.value = 0;
    x.subtotal.value = 0.0;
    total.value = 0.0;
    keranjang.value.clear();
    //Get.delete<PembayaranController>();
  }

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
      bayar.value.text = x.toString();
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
  editDiskonKasir(PembayaranController controller, promouuid) {
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
                                    hitungPembayaran(promouuid);

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
    Get.put(TambahPromoController());
    Get.put(PromoController());
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

  var pelangganvalue = ''.obs;
  var namaPelanggan = ''.obs;

  popListPelanggan() async {
    var con = Get.find<CentralPelangganController>();
    print('fetch pelanggan pop');
    con.fetchPelangganLocal(id_toko: id_toko);
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
                              con.serachPelangganLocal();
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
                                  Get.toNamed('/tambahpelanggan');
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
                                      pelangganvalue.value =
                                          customer[index].uuid!;
                                      namaPelanggan.value =
                                          customer[index].namaPelanggan!;
                                      print(pelangganvalue.value);
                                      print(namaPelanggan.value);
                                      Navigator.pop(context);
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
                            searchPromoLocal();
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
                    child: promolist.isNotEmpty
                        ? ListView.builder(
                            itemCount: promolist.length,
                            itemBuilder: (context, index) {
                              final promo = promolist;

                              return Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    promolistvalue = promo[index].uuid;
                                    namaPromo.value = promo[index].namaPromo!;
                                    hitungPembayaran(promolistvalue);
                                    Navigator.pop(context);
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
      await fetchPromo(id_toko: id_toko);
      var x = promolist.where((x) => x.uuid == uuid).first;
      promolistvalue = x.uuid!;
      namaPromo.value = x.namaPromo!;
      hitungPembayaran(promolistvalue);
      Get.back();
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}

class TambahPromoPembayaran extends GetView<PembayaranController> {
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
                  // Obx(() {
                  //   return Padding(
                  //     padding: EdgeInsets.only(bottom: 100, top: 50),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         controller.pikedImagePath.value == '' &&
                  //             controller.pickedIconPath.value == ''
                  //             ? Stack(
                  //           alignment: Alignment.center,
                  //           children: [
                  //             Container(
                  //               width: 120,
                  //               height: 120,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: AppColor.primary,
                  //               ),
                  //               child: Icon(
                  //                 FontAwesomeIcons.image,
                  //                 color: Colors.white,
                  //                 size: 55,
                  //               ),
                  //             ),
                  //             Positioned(
                  //               bottom: 0,
                  //               right: 0,
                  //               child: TextButton(
                  //                 style: TextButton.styleFrom(
                  //                   shape: CircleBorder(),
                  //                   padding: EdgeInsets.all(8),
                  //                   backgroundColor: AppColor.secondary,
                  //                 ),
                  //                 onPressed: () async {
                  //                   DeviceInfoPlugin deviceInfo =
                  //                   DeviceInfoPlugin();
                  //                   AndroidDeviceInfo androidInfo =
                  //                   await deviceInfo.androidInfo;
                  //                   if (androidInfo.version.sdkInt >=
                  //                       33) {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   } else {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   }
                  //
                  //                   controller.pilihsourcefoto();
                  //                 },
                  //                 child: Icon(
                  //                   Icons.add,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //             : Stack(
                  //           alignment: Alignment.center,
                  //           children: [
                  //             Container(
                  //               width: 120,
                  //               height: 120,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: AppColor.primary,
                  //               ),
                  //               child: ClipOval(
                  //                 child: controller.pikedImagePath != ''
                  //                     ? Image.file(
                  //                   File(controller
                  //                       .pickedImageFile!.path),
                  //                   width: 120,
                  //                   height: 120,
                  //                   fit: BoxFit.cover,
                  //                 )
                  //                     : SvgPicture.asset(
                  //                   controller.pickedIconPath.value,
                  //                   width: 120,
                  //                   height: 120,
                  //                   fit: BoxFit.contain,
                  //                 ),
                  //               ),
                  //             ),
                  //             Positioned(
                  //               bottom: 0,
                  //               right: 0,
                  //               child: TextButton(
                  //                 style: TextButton.styleFrom(
                  //                   shape: CircleBorder(),
                  //                   padding: EdgeInsets.all(8),
                  //                   backgroundColor: AppColor.secondary,
                  //                 ),
                  //                 onPressed: () async {
                  //                   DeviceInfoPlugin deviceInfo =
                  //                   DeviceInfoPlugin();
                  //                   AndroidDeviceInfo androidInfo =
                  //                   await deviceInfo.androidInfo;
                  //                   if (androidInfo.version.sdkInt >=
                  //                       33) {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   } else {
                  //                     var status =
                  //                     await Permission.camera.status;
                  //                     if (!status.isGranted) {
                  //                       await Permission.camera.request();
                  //                     }
                  //                   }
                  //
                  //                   controller.pilihsourcefoto();
                  //                 },
                  //                 child: FaIcon(
                  //                   FontAwesomeIcons.pencil,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }),
                  // Padding(
                  //   padding: AppPading.customBottomPadding(),
                  //   child: button_border_custom(
                  //       onPressed: () async {
                  //         if (await controller.checkContactPermission()) {
                  //           controller.selectContact();
                  //         } else {
                  //           Get.snackbar(
                  //             'Izin Diperlukan',
                  //             'Silakan berikan izin akses kontak terlebih dahulu',
                  //             snackPosition: SnackPosition.BOTTOM,
                  //           );
                  //         }
                  //       },
                  //       child: Text('Tambah dari kontak'),
                  //       width: context.res_width),
                  // ),
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
                      // Update text field when radio changes
                      final isNominal = controller.selecteddiskon.value ==
                          controller.opsidiskon[0];
                      final currentValue = isNominal
                          ? controller.promonominal.value.toStringAsFixed(0)
                          : controller.promopersen.value.toStringAsFixed(0);

                      // Update controller text when value changes
                      if (controller.promo.value.text != currentValue) {
                        controller.promo.value.text = currentValue;
                      }

                      return Padding(
                        padding: AppPading.customBottomPadding(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.promo.value,
                                decoration: InputDecoration(
                                  prefixIcon: isNominal
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
                                  final parsed = double.tryParse(value);
                                  if (parsed == null)
                                    return 'Masukkan angka valid';
                                  if (isNominal && parsed <= 0)
                                    return 'Nominal harus > 0';
                                  if (!isNominal &&
                                      (parsed <= 0 || parsed > 100)) {
                                    return 'Persen harus 1-100';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed == null) return;

                                  if (isNominal) {
                                    controller.promopersen.value = 0.0;
                                    controller.promonominal.value = parsed;
                                    print('nominal');
                                    print('nominal --> ' +
                                        controller.promonominal.value
                                            .toString() +
                                        'persen --> ' +
                                        controller.promopersen.value
                                            .toString());
                                  } else {
                                    controller.promonominal.value = 0.0;
                                    controller.promopersen.value = parsed;
                                    print('persen');
                                    print('nominal --> ' +
                                        controller.promonominal.value
                                            .toString() +
                                        'persen --> ' +
                                        controller.promopersen.value
                                            .toString());
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => Row(
                                  children: [
                                    Expanded(
                                      child: RadioMenuButton(
                                        value: controller.opsidiskon[0],
                                        groupValue:
                                            controller.selecteddiskon.value,
                                        onChanged: (x) {
                                          controller.selecteddiskon.value = x!;
                                        },
                                        child: const Text('Rp.'),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioMenuButton(
                                        value: controller.opsidiskon[1],
                                        groupValue:
                                            controller.selecteddiskon.value,
                                        onChanged: (x) {
                                          controller.selecteddiskon.value = x!;
                                        },
                                        child: const Text('%'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                      'Minggu',
                                      'Senin',
                                      'Selasa',
                                      'Rabu',
                                      'Kamis',
                                      'Jumat',
                                      'Sabtu',
                                    ],
                                    firstDayOfWeek: 1,
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
