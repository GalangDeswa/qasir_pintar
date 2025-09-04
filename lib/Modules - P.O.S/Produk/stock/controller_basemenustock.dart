import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/model_penerimaan.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../../Config/config.dart';
import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
import '../../Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../../Promo/model_promo.dart';
import '../Data produk/model_produk.dart';
import '../Kategori/model_subkategoriproduk.dart';
import '../Produk/model_kategoriproduk.dart';

class BasemenuStockController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchPenerimaanLocal(id_toko: id_toko);
    await fetchProdukLocal(id_toko: id_toko);
  }

  var tampilan = ''.obs;
  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
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

  var keranjang = <DataProdukApiCart>[].obs;
  var totalItem = 0.obs;
  var subtotal = 0.0.obs;
  var totalbayar = 0.0.obs;
  var total = 0.0.obs;
  var totalTax = 0.0.obs;

  var metode_diskon = 9.obs;
  RxDouble displaydiskon = 0.0.obs;

  var promolist = <DataPromo>[].obs;
  var promolistvalue;

  var data = Get.arguments;
  var sub;
  var jumlahdiskonkasir = 0.0.obs;
  var pelangganpilih = DataPelanggan;

  var savedCart = <DataKeranjangSavev2>[].obs;

  var pelangganvalue = ''.obs;
  var namaPelanggan = ''.obs;

  var keranjangv2 = <DataKeranjang>[].obs;

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

  var kasirsheet = SheetController().obs;
  var balikvalue = 0.0.obs;

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

  RxList<String> deletedDetailIds = <String>[].obs;

  deleteCart(int index) {
    final removed = keranjang.removeAt(index);
    deletedDetailIds.add(removed.id.toString());

    _updateTotals();
  }

  clearAll() {
    print('clear all -->');

    keranjangv2.clear();
    keranjangv2.refresh();
    totalitem.value = 0;
    totalItem.value = 0;
    subtotal.value = 0.0;
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

  var namaPromo = ''.obs;
  var totalitem = 0.obs;
  var bulkQTY = TextEditingController();

  void decrementItem(int index) {
    final item = keranjang[index];
    item.qty--;

    // adjust subtotal
    final hargaPer = item.fund;
    subtotal.value -= hargaPer!;

    // recalc tax
    // totalTax.value = keranjangv2.fold<double>(
    //   0.0,
    //       (sum, e) => sum + ((e.price * e.nominalpajak! / 100) * e.qty),
    // );

    // recalc total items
    totalItem.value = keranjang.fold<int>(
      0,
      (sum, e) => sum + e.qty,
    );

    // remove if zero
    if (item.qty <= 0) {
      final removed = keranjang.removeAt(index);
      deletedDetailIds.add(removed.id.toString());
    }

    // do any final calculations
    hitungPembayaran();

    // notify GetX that the list changed
    keranjang.refresh();
  }

  popaddqty(DataProdukApi cart) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              height: Get.height * 0.25,
              width: context.res_width,
              child: Column(children: [
                Expanded(child: Text('jumlah')),
                Expanded(
                  child: TextField(
                    controller: bulkQTY,
                    decoration: InputDecoration(hintText: 'Masukan jumlah Qty'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Expanded(
                  child: button_solid_custom(
                      onPressed: () {
                        if (bulkQTY.text.isEmpty) {
                          Get.showSnackbar(toast().bottom_snackbar_error(
                              'Error', 'Qty tidak boleh kosong'));
                          return;
                        }
                        final existingIndex =
                            keranjang.indexWhere((item) => item.id == cart.id);
                        final qty = int.parse(bulkQTY.value.text);
                        //produktemp.refresh();
                        if (existingIndex == -1) {
                          keranjang.add(DataProdukApiCart(
                              id: cart.id,
                              buy: cart.buy,
                              createdAt: cart.createdAt,
                              fund: cart.fund,
                              group: cart.group,
                              name: cart.name,
                              picture: cart.picture,
                              sell: cart.sell,
                              status: cart.status,
                              unit: cart.unit,
                              userId: cart.userId,
                              value: cart.value,
                              qty: qty));

                          keranjang.refresh();
                        } else {
                          keranjang[existingIndex].qty += qty;
                          keranjang.refresh();
                        }
                        _updateTotals();
                        bulkQTY.clear();
                        Get.back();
                      },
                      child: Text('Tambah'),
                      width: Get.width),
                )
              ]));
        },
      ),
    ));
  }

  editqty(DataProdukApiCart cart) {
    final existingIndex = keranjang.indexWhere((item) => item.id == cart.id);
    bulkQTY.text = cart.qty.toString();
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              height: Get.height * 0.25,
              width: context.res_width,
              child: Column(children: [
                Expanded(child: Text('jumlah')),
                Expanded(
                  child: TextField(
                    controller: bulkQTY,
                    decoration: InputDecoration(hintText: 'Edit jumlah Qty'),
                  ),
                ),
                Expanded(
                  child: button_solid_custom(
                      onPressed: () {
                        final existingIndex =
                            keranjang.indexWhere((item) => item.id == cart.id);
                        final qty = int.parse(bulkQTY.value.text);
                        //produktemp.refresh();

                        keranjang[existingIndex].qty = qty;
                        keranjang.refresh();

                        _updateTotals();

                        Get.back();
                      },
                      child: Text('Edit'),
                      width: Get.width),
                )
              ]));
        },
      ),
    ));
  }

  void _updateTotals() {
    totalItem.value = keranjang.fold(0, (sum, item) => sum + item.qty);
    subtotal.value =
        keranjang.fold(0.0, (sum, item) => sum + (item.fund! * item.qty));
    // totalTax.value = keranjang.fold(
    //   0.0,
    //       (sum, item) => sum + ((item.price * item.nominalpajak! / 100) * item.qty),
    // );
    print('total item --->');
    print(totalItem.value);
    print('subtotal --->');
    print(subtotal.value);
    print('total TAX --->');
    print(totalTax.value);
    hitungPembayaran();
    keranjang.refresh();
  }

  hitungPembayaran() {
    hitungbesardiskonkasir();
    hitungpromo();
    totalval();
  }

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

  var ppn = 0.0.obs;
  var ppnSwitch = false.obs;

  addKeranjang(DataProdukApi cart) async {
    var produk = Get.find<CentralPenerimaanController>().produkAPI;
    var check = produk.where((element) => element.id == cart.id).first;
    print('add keranjang ===>' + cart.name!);
    final existingIndex = keranjang.indexWhere((item) => item.id == cart.id);

    // if (check.qty == 0 &&
    //     check.tampilkan_di_produk == 1 &&
    //     check.hitung_stok == 1) {
    //   Get.showSnackbar(toast().bottom_snackbar_error(
    //       "Error", 'Stock sudah habis! harap isi stock terlebih dahulu'));
    //   return;
    // }

    if (existingIndex == -1) {
      keranjang.add(DataProdukApiCart(
          id: cart.id,
          buy: cart.buy,
          createdAt: cart.createdAt,
          fund: cart.fund,
          group: cart.group,
          name: cart.name,
          picture: cart.picture,
          sell: cart.sell,
          status: cart.status,
          unit: cart.unit,
          userId: cart.userId,
          value: cart.value,
          qty: 1));
      keranjang.refresh();
    } else {
      keranjang[existingIndex].qty++;
      keranjang.refresh();
    }
    totalItem.value = keranjang.fold(0, (sum, item) => sum + (item.qty ?? 0));
    subtotal.value =
        keranjang.fold(0.0, (sum, item) => sum + (item.fund! * item.qty));
  }

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

  // openSavedCart() {
  //   Get.dialog(AlertDialog(
  //     insetPadding: EdgeInsets.zero,
  //     contentPadding: EdgeInsets.zero,
  //     content: Builder(
  //       builder: (context) {
  //         var height = MediaQuery.of(context).size.height;
  //         var width = MediaQuery.of(context).size.width;
  //
  //         return Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.all(Radius.circular(10)),
  //               color: Colors.white,
  //             ),
  //             padding: EdgeInsets.all(20),
  //             width: width - 30,
  //             height: height - 200,
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: AppPading.customBottomPadding(),
  //                   child: Container(
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                         color: AppColor.primary,
  //                         borderRadius: BorderRadius.circular(10)),
  //                     child: Text(
  //                       ' Keranjang Tersimpan',
  //                       style: AppFont.regular_white_bold(),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: ListView.builder(
  //                       itemCount: savedCart.length,
  //                       itemBuilder: (context, index) {
  //                         var cart = savedCart[index];
  //
  //                         return Column(
  //                           children: [
  //                             ExpansionTile(
  //                               trailing: IconButton(
  //                                 onPressed: () async {
  //                                   print('add saved cart');
  //
  //                                   // 1) FIRST: pull it out of savedCart so your validator won't double‑count it
  //                                   final restored = savedCart.removeAt(index);
  //                                   savedCart.refresh();
  //                                   Get.back();
  //
  //                                   // 2) THEN: restore all the items
  //                                   for (final item in restored.item) {
  //                                     if (item.qty > 1) {
  //                                       for (var i = 0; i < item.qty; i++) {
  //                                         addToCart(
  //                                             item); // or just addToCart(item) if sync
  //                                       }
  //                                     } else {
  //                                       addToCart(item);
  //                                     }
  //                                   }
  //
  //                                   // 3) Restore all your discount/promo/customer info
  //                                   jumlahdiskonkasir.value = restored.diskon;
  //                                   promovalue.value = restored.promoValue;
  //                                   namaPromo.value = restored.namaPromo;
  //                                   promolistvalue = restored.promoUUID;
  //                                   namaPelanggan.value = restored.customerName;
  //                                   pelangganvalue.value =
  //                                       restored.customerUUID;
  //                                   metode_diskon.value = restored.metodeDiskon;
  //                                   displaydiskon.value =
  //                                       restored.displayDiskon;
  //
  //                                   print(
  //                                       'restored discount info for this cart:');
  //                                   print(' Discount: ${restored.diskon}');
  //                                   print(' Promo:    ${restored.namaPromo}');
  //                                   print(
  //                                       ' Customer: ${restored.customerName}');
  //
  //                                   // 4) slide the sheet up
  //                                   kasirsheet.value.animateTo(SheetOffset(1));
  //                                 },
  //                                 icon: Icon(FontAwesomeIcons.cartPlus),
  //                               ),
  //                               title: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     DateFormat('HH:mm dd-MM-yyyy')
  //                                         .format(cart.savedAt),
  //                                     style: AppFont.regular_bold(),
  //                                   ),
  //                                   Text(
  //                                     'Keranjang nomor : ${index + 1}',
  //                                     style: AppFont.regular(),
  //                                   ),
  //                                 ],
  //                               ),
  //                               childrenPadding: EdgeInsets.zero,
  //                               children: cart.item.map((data) {
  //                                 print(data);
  //                                 return Container(
  //                                   padding: EdgeInsets.all(10),
  //                                   color:
  //                                   AppColor.primary.withValues(alpha: 0.1),
  //                                   child: Column(
  //                                     children: [
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text('Produk',
  //                                               style: AppFont.regular()),
  //                                           Text('subtotal',
  //                                               style: AppFont.regular())
  //                                         ],
  //                                       ),
  //                                       Divider(),
  //                                       ListTile(
  //                                         contentPadding: EdgeInsets.zero,
  //                                         trailing: Text(
  //                                           (data.isPaket == true
  //                                               ? 'Rp. ' +
  //                                               AppFormat().numFormat(
  //                                                   data.hargaPaket! *
  //                                                       data.qty)
  //                                               : 'Rp. ' +
  //                                               AppFormat().numFormat(
  //                                                   data.hargaEceran! *
  //                                                       data.qty))
  //                                               .toString(),
  //                                           style: AppFont.regular(),
  //                                         ),
  //                                         title: data.isPaket == true
  //                                             ? Text(
  //                                           data.namaPaket!,
  //                                           style: AppFont.regular(),
  //                                         )
  //                                             : Text(
  //                                           data.namaProduk!,
  //                                           style: AppFont.regular(),
  //                                         ),
  //                                         subtitle: Row(
  //                                           children: [
  //                                             Text(
  //                                               data.isPaket == true
  //                                                   ? 'Rp. ' +
  //                                                   AppFormat().numFormat(
  //                                                       data.hargaPaket)
  //                                                   : 'Rp. ' +
  //                                                   AppFormat().numFormat(
  //                                                       data.hargaEceran),
  //                                               style: AppFont.regular(),
  //                                             ),
  //                                             Padding(
  //                                               padding:
  //                                               EdgeInsets.only(left: 5),
  //                                               child: Text(
  //                                                   'x ' + data.qty.toString()),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 );
  //                               }).toList(),
  //                             ),
  //                             Divider(),
  //                           ],
  //                         );
  //                       }),
  //                 ),
  //               ],
  //             ));
  //       },
  //     ),
  //   ));
  // }

  var id_toko = GetStorage().read('uuid');
  var kategoriProduk = <DataKategoriProduk>[].obs;
  var produk = <DataProduk>[].obs;
  var subKategoriProduk = <DataSubKategoriProduk>[].obs;
  var search = TextEditingController().obs;
  var filterstock = TextEditingController().obs;
  var filterval = 0.obs;
  var searchproduk = TextEditingController().obs;
  var subsearch = TextEditingController().obs;
  var penerimaan = <DataPenerimaanProduk>[].obs;

  List<DateTime?> dates = [];
  var pickdate = TextEditingController().obs;
  final dateformat = DateFormat('dd-MM-yyyy');
  var date1;
  var date2;

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

  seacrhPenerimaanLocal({id_toko, bool ascending = true}) async {
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

  searchPenerimaanByDateLocal(
      {required String id_toko,
      required String startDate,
      required String endDate,
      bool ascending = true}) async {
    print('-------------------search penerimaan by date---------------------');

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
      AND DATE(penerimaan_produk.tanggal) BETWEEN "$startDate" AND "$endDate"
  ''');

    if (query.isNotEmpty) {
      List<DataPenerimaanProduk> data =
          query.map((e) => DataPenerimaanProduk.fromJsondb(e)).toList();
      penerimaan.value = data;
      data.forEach(
        (element) {
          print(element.tanggal);
        },
      );
      return data;
    } else {
      print('No results found between $startDate and $endDate');
      return [];
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
