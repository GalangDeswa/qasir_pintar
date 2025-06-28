import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:uuid/uuid.dart';

import '../../../../Database/DB_helper.dart';
import '../../../../Widget/widget.dart';
import '../../../Pelanggan/List Pelanggan/controller_pelanggan.dart';
import '../../../Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../../../Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';
import '../../../Supplier/model_supplier.dart';
import '../../Data produk/model_produk.dart';
import '../controller_basemenustock.dart';
import '../model_penerimaan.dart';

class DetailPenerimaanProdukController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchSupplierLocal(id_toko: id_toko);
    await fetchDetailPenerimaan(id_toko: id_toko, id_penerimaan: data.uuid);
    // print('SUpplier id --->' + suppliervalue);
    namaSupplier.value = supplierList
            .where((e) => e.uuid == data.idSupplier.toString())
            .first
            .nama_supplier ??
        '-';

    nomorfaktur.value.text = data.nomorFaktur!;
    jumlahqty.value.text = data.jumlahQty.toString();
    totalharga.value.text = data.totalHarga.toString();
    ongkir.value.text = data.ongkosKirim.toString();
    jumlahbayar.value.text = data.jumlahBayar.toString();
    totalbayar.value.text = data.totalBayar.toString();
    sisabayar.value.text = data.sisaBayar.toString();
    jenispenerimaanvalue.value = data.jenisPenerimaan!;
    print('data --.' + data.jenisPenerimaan!);
    print(jenispenerimaanvalue);
  }

  DataPenerimaanProduk data = Get.arguments;
  var namaSupplier = '-'.obs;

  List<dynamic> insertResults = []; // Track insertion results
  var harga_modal = 0.0.obs;
  var harga_hpp = 0.0.obs;
  var produktemp = <DataProdukTemp>[].obs;
  var detailpenerimaan = <DataDetailPenerimaanProduk>[].obs;
  var hargaModal = TextEditingController().obs;
  var hpp = TextEditingController().obs;
  popaddproduk() {
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
            width: context.res_width,
            child: produk.isNotEmpty
                ? ListView.builder(
                    itemCount: produk.length,
                    itemBuilder: (context, index) {
                      final customer = produk;

                      return customer[index].tampilkan_di_produk == 1
                          ? GestureDetector(
                              onTap: () {
                                final existingIndex = produktemp.indexWhere(
                                    (item) =>
                                        item.uuid == customer[index].uuid);
                                //produktemp.refresh();
                                if (existingIndex == -1) {
                                  produktemp.add(DataProdukTemp(
                                    qty: 1,
                                    hpp: customer[index].hpp,
                                    nama_produk: customer[index].nama_produk,
                                    uuid: customer[index].uuid,
                                    harga_jual_pelanggan:
                                        customer[index].harga_jual_pelanggan,
                                    serial_key: customer[index].serial_key,
                                    namaKategori: customer[index].namaKategori,
                                    namasubKategori:
                                        customer[index].namasubKategori,
                                    id_toko: customer[index].id_toko,
                                    imei: customer[index].imei,
                                    harga_jual_eceran:
                                        customer[index].harga_jual_eceran,
                                    harga_jual_grosir:
                                        customer[index].harga_jual_grosir,
                                    id_sub_kelompok_produk:
                                        customer[index].id_sub_kelompok_produk,
                                    id_kelompok_produk:
                                        customer[index].id_kelompok_produk,
                                    kode_produk: customer[index].kode_produk,
                                    jenisProduk: customer[index].jenisProduk,
                                    pajak: customer[index].pajak,
                                    info_stok_habis:
                                        customer[index].info_stok_habis,
                                    ukuran: customer[index].ukuran,
                                    berat: customer[index].berat,
                                    volume_panjang:
                                        customer[index].volume_panjang,
                                    volume_lebar: customer[index].volume_lebar,
                                    volume_tinggi:
                                        customer[index].volume_tinggi,
                                    id_gambar: customer[index].id_gambar,
                                    gambar_produk_utama:
                                        customer[index].gambar_produk_utama,
                                    stockawal: customer[index].stockawal,
                                    nominalpajak: customer[index].nominalpajak,
                                    harga_beli: customer[index].harga_beli,
                                    hitung_stok: customer[index].hitung_stok,
                                    tampilkan_di_produk:
                                        customer[index].tampilkan_di_produk,
                                    namaPajak: customer[index].namaPajak,
                                    namaukuran: customer[index].namaukuran,
                                  ));

                                  // harga_modal.value +=
                                  //     customer[index].harga_beli!;
                                  // harga_hpp.value += customer[index].hpp!;
                                  // hargaModal.value.text =
                                  //     harga_modal.value.toString();
                                  // hpp.value.text = harga_hpp.value.toString();
                                  // print('sum harga modal --->' +
                                  //     harga_modal.value.toString());
                                  // print('sum harga hpp --->' +
                                  //     harga_hpp.value.toString());
                                  produktemp.refresh();
                                } else {
                                  produktemp[existingIndex].qty++;
                                  produktemp.refresh();
                                }
                                harga_modal.value +=
                                    customer[index].harga_beli!;
                                harga_hpp.value += customer[index].hpp!;
                                hargaModal.value.text =
                                    harga_modal.value.toString();
                                hpp.value.text = harga_hpp.value.toString();
                                print('sum harga modal --->' +
                                    harga_modal.value.toString());
                                print('sum harga hpp --->' +
                                    harga_hpp.value.toString());
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: ClipOval(
                                        child: customer[index]
                                                        .gambar_produk_utama !=
                                                    '' &&
                                                customer[index]
                                                        .gambar_produk_utama !=
                                                    null
                                            ? isBase64Svg(customer[index]
                                                    .gambar_produk_utama!)
                                                ? SvgPicture.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.asset(
                                                AppString.defaultImg,
                                                width: 30,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      title: Text(
                                        customer[index].nama_produk ??
                                            'default nama',
                                        style: AppFont.regular(),
                                      ),
                                      subtitle: Text(
                                        customer[index].namaKategori!,
                                        style: AppFont.small(),
                                      ),
                                      trailing: Text(
                                        customer[index].hpp.toString(),
                                        style: AppFont.small(),
                                      )),
                                  Container(
                                    height: 0.5,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Get.toNamed('/isiproduk',
                                    arguments: customer[index]);
                              },
                              child: Card(
                                color: Colors.grey[300],
                                margin: EdgeInsets.only(bottom: 25),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: ClipOval(
                                    child:
                                        customer[index].gambar_produk_utama !=
                                                    '' &&
                                                customer[index]
                                                        .gambar_produk_utama !=
                                                    null
                                            ? isBase64Svg(customer[index]
                                                    .gambar_produk_utama!)
                                                ? SvgPicture.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.asset(
                                                AppString.defaultImg,
                                                width: 30,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                  title: Text(
                                    customer[index].nama_produk ??
                                        'default nama',
                                    style: AppFont.regular(),
                                  ),
                                  subtitle: Text('Nonaktif',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            );
                    },
                  )
                : EmptyData(),
          );
        },
      ),
    ));
  }

  var searchproduk = TextEditingController().obs;

  searchProdukLocal({id_toko}) async {
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
      print("data search-------->" + data.toString());
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  popaddprodukv2() {
    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
      child: Material(
        color: Colors.white,
        child: Obx(() {
          return Container(
              padding: AppPading.defaultBodyPadding(),
              height: Get.height * 0.5,
              child: Column(children: [
                Obx(() {
                  return TextField(
                    onChanged: (val) {
                      print(val);
                      searchProdukLocal(id_toko: id_toko);
                    },
                    controller: searchproduk.value,
                    decoration: InputDecoration(hintText: 'Cari...'),
                  );
                }),
                produk.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: produk.length,
                          itemBuilder: (context, index) {
                            final customer = produk;

                            return customer[index].tampilkan_di_produk == 1
                                ? GestureDetector(
                                    onTap: () {
                                      final existingIndex =
                                          produktemp.indexWhere((item) =>
                                              item.uuid ==
                                              customer[index].uuid);
                                      //produktemp.refresh();
                                      if (existingIndex == -1) {
                                        produktemp.add(DataProdukTemp(
                                          qty: 1,
                                          hpp: customer[index].hpp,
                                          nama_produk:
                                              customer[index].nama_produk,
                                          uuid: customer[index].uuid,
                                          harga_jual_pelanggan: customer[index]
                                              .harga_jual_pelanggan,
                                          serial_key:
                                              customer[index].serial_key,
                                          namaKategori:
                                              customer[index].namaKategori,
                                          namasubKategori:
                                              customer[index].namasubKategori,
                                          id_toko: customer[index].id_toko,
                                          imei: customer[index].imei,
                                          harga_jual_eceran:
                                              customer[index].harga_jual_eceran,
                                          harga_jual_grosir:
                                              customer[index].harga_jual_grosir,
                                          id_sub_kelompok_produk:
                                              customer[index]
                                                  .id_sub_kelompok_produk,
                                          id_kelompok_produk: customer[index]
                                              .id_kelompok_produk,
                                          kode_produk:
                                              customer[index].kode_produk,
                                          jenisProduk:
                                              customer[index].jenisProduk,
                                          pajak: customer[index].pajak,
                                          info_stok_habis:
                                              customer[index].info_stok_habis,
                                          ukuran: customer[index].ukuran,
                                          berat: customer[index].berat,
                                          volume_panjang:
                                              customer[index].volume_panjang,
                                          volume_lebar:
                                              customer[index].volume_lebar,
                                          volume_tinggi:
                                              customer[index].volume_tinggi,
                                          id_gambar: customer[index].id_gambar,
                                          gambar_produk_utama: customer[index]
                                              .gambar_produk_utama,
                                          stockawal: customer[index].stockawal,
                                          nominalpajak:
                                              customer[index].nominalpajak,
                                          harga_beli:
                                              customer[index].harga_beli,
                                          hitung_stok:
                                              customer[index].hitung_stok,
                                          tampilkan_di_produk: customer[index]
                                              .tampilkan_di_produk,
                                          namaPajak: customer[index].namaPajak,
                                          namaukuran:
                                              customer[index].namaukuran,
                                        ));

                                        produktemp.refresh();
                                      } else {
                                        produktemp[existingIndex].qty++;
                                        produktemp.refresh();
                                      }
                                      harga_modal.value +=
                                          customer[index].harga_beli!;
                                      harga_hpp.value += customer[index].hpp!;
                                      totalharga.value.text =
                                          harga_modal.value.toString();
                                      hpp.value.text =
                                          harga_hpp.value.toString();
                                      print('sum harga modal --->' +
                                          harga_modal.value.toString());
                                      print('sum harga hpp --->' +
                                          harga_hpp.value.toString());

                                      // Calculate sum of quantities
                                      var sumqty = produktemp.fold(0,
                                          (sum, item) => sum + (item.qty ?? 0));
                                      var sumharga = produktemp.fold(
                                          0.0,
                                          (sum, item) =>
                                              sum +
                                              (item.harga_jual_eceran ?? 0));
                                      jumlahqty.value.text = sumqty.toString();
                                      // totalharga.value.text =
                                      //     sumharga.toString();
                                      // cariTotalBayar();
                                      print('Total Qty: $sumqty');
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                  leading: ClipOval(
                                                    child: customer[index]
                                                                    .gambar_produk_utama !=
                                                                '' &&
                                                            customer[index]
                                                                    .gambar_produk_utama !=
                                                                null
                                                        ? isBase64Svg(customer[
                                                                    index]
                                                                .gambar_produk_utama!)
                                                            ? SvgPicture.memory(
                                                                base64Decode(customer[
                                                                        index]
                                                                    .gambar_produk_utama!),
                                                                width: 30,
                                                                height: 40,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.memory(
                                                                base64Decode(customer[
                                                                        index]
                                                                    .gambar_produk_utama!),
                                                                width: 30,
                                                                height: 40,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                        : Image.asset(
                                                            AppString
                                                                .defaultImg,
                                                            width: 30,
                                                            height: 40,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  title: Text(
                                                    customer[index]
                                                            .nama_produk ??
                                                        'default nama',
                                                    style: AppFont.regular(),
                                                  ),
                                                  subtitle: Text(
                                                    'Rp. ' +
                                                        customer[index]
                                                            .hpp
                                                            .toString(),
                                                    style: AppFont.small(),
                                                  )),
                                            ),
                                            Expanded(
                                              child: button_border_custom(
                                                  onPressed: () {
                                                    popaddqty(customer[index]);
                                                  },
                                                  child: Text(
                                                    '+ sekaligus banyak',
                                                    style: AppFont.small(),
                                                  ),
                                                  width: 0),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Get.toNamed('/isiproduk',
                                          arguments: customer[index]);
                                    },
                                    child: Card(
                                      color: Colors.grey[300],
                                      margin: EdgeInsets.only(bottom: 25),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: ClipOval(
                                          child: customer[index]
                                                          .gambar_produk_utama !=
                                                      '' &&
                                                  customer[index]
                                                          .gambar_produk_utama !=
                                                      null
                                              ? isBase64Svg(customer[index]
                                                      .gambar_produk_utama!)
                                                  ? SvgPicture.memory(
                                                      base64Decode(customer[
                                                              index]
                                                          .gambar_produk_utama!),
                                                      width: 30,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.memory(
                                                      base64Decode(customer[
                                                              index]
                                                          .gambar_produk_utama!),
                                                      width: 30,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    )
                                              : Image.asset(
                                                  AppString.defaultImg,
                                                  width: 30,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        title: Text(
                                          customer[index].nama_produk ??
                                              'default nama',
                                          style: AppFont.regular(),
                                        ),
                                        subtitle: Text('Nonaktif',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      )
                    : Expanded(child: Text('kosong')),
              ]));
        }),
      ),
    )));
  }

  var customqty = TextEditingController().obs;

  popaddqty(DataProduk data) {
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
                    controller: customqty.value,
                    decoration:
                        InputDecoration(hintText: 'Masukan jumlah produk'),
                  ),
                ),
                Expanded(
                  child: button_solid_custom(
                      onPressed: () {
                        final existingIndex = produktemp
                            .indexWhere((item) => item.uuid == data.uuid);
                        final qty = int.parse(customqty.value.text);
                        //produktemp.refresh();
                        if (existingIndex == -1) {
                          produktemp.add(DataProdukTemp(
                            qty: qty,
                            hpp: data.hpp,
                            nama_produk: data.nama_produk,
                            uuid: data.uuid,
                            harga_jual_pelanggan: data.harga_jual_pelanggan,
                            serial_key: data.serial_key,
                            namaKategori: data.namaKategori,
                            namasubKategori: data.namasubKategori,
                            id_toko: data.id_toko,
                            imei: data.imei,
                            harga_jual_eceran: data.harga_jual_eceran,
                            harga_jual_grosir: data.harga_jual_grosir,
                            id_sub_kelompok_produk: data.id_sub_kelompok_produk,
                            id_kelompok_produk: data.id_kelompok_produk,
                            kode_produk: data.kode_produk,
                            jenisProduk: data.jenisProduk,
                            pajak: data.pajak,
                            info_stok_habis: data.info_stok_habis,
                            ukuran: data.ukuran,
                            berat: data.berat,
                            volume_panjang: data.volume_panjang,
                            volume_lebar: data.volume_lebar,
                            volume_tinggi: data.volume_tinggi,
                            id_gambar: data.id_gambar,
                            gambar_produk_utama: data.gambar_produk_utama,
                            stockawal: data.stockawal,
                            nominalpajak: data.nominalpajak,
                            harga_beli: data.harga_beli,
                            hitung_stok: data.hitung_stok,
                            tampilkan_di_produk: data.tampilkan_di_produk,
                            namaPajak: data.namaPajak,
                            namaukuran: data.namaukuran,
                          ));

                          produktemp.refresh();
                        } else {
                          produktemp[existingIndex].qty += qty;
                          produktemp.refresh();
                        }
                        harga_modal.value += data.harga_beli! * qty;
                        harga_hpp.value += data.hpp! * qty;
                        totalharga.value.text = harga_modal.value.toString();
                        hpp.value.text = harga_hpp.value.toString();
                        print('sum harga modal --->' +
                            harga_modal.value.toString());
                        print(
                            'sum harga hpp --->' + harga_hpp.value.toString());

                        // Calculate total quantities
                        var sumqty = produktemp.fold(
                            0, (sum, item) => sum + (item.qty ?? 0));

                        // check pengecekan harga dan belum dikali qty
                        var sumharga = produktemp.fold(0.0,
                            (sum, item) => sum + (item.harga_jual_eceran ?? 0));
                        jumlahqty.value.text = sumqty.toString();
                        //totalharga.value.text = sumharga.toString();

                        print('Total Quantity: $sumqty');
                        //cariTotalBayar();

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

  var nama = TextEditingController().obs;
  var nomorfaktur = TextEditingController().obs;
  var email = TextEditingController().obs;
  var jumlahqty = TextEditingController().obs;
  var totalharga = TextEditingController().obs;
  var ongkir = TextEditingController().obs;
  var totalbayar = TextEditingController().obs;
  var jumlahbayar = TextEditingController().obs;
  var sisabayar = TextEditingController().obs;
  var id_toko = GetStorage().read('uuid');
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
  RxString jenispenerimaanvalue = ''.obs;
  var jenispenerimaan = ['Lunas', 'Hutang'].obs;

  var kategoripelangganList = <DataKategoriPelanggan>[].obs;
  var kategorivalue;

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
          imageQuality: 85,
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

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
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

  var pickedIconPath = ''.obs;

  Future<String> svgToBase64(String assetPath) async {
    final String svgString = await rootBundle.loadString(assetPath);
    return base64Encode(utf8.encode(svgString));
  }

  var tanggal = TextEditingController().obs;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  stringdate() {
    var ff = dateFormat.format(datedata.first!);
    tanggal.value.text = ff;
  }

  fetchKategoriPelangganLocal(id_toko) async {
    print(
        '-------------------fetch kategori pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM kategori_pelanggan WHERE id_toko = "$id_toko" AND aktif = 1');
    if (query.isNotEmpty) {
      List<DataKategoriPelanggan> data =
          query.map((e) => DataKategoriPelanggan.fromJsondb(e)).toList();
      kategoripelangganList.value = data;

      return data;
    } else {
      print('empty');
      return null;
    }
  }

  tambahPelangganLocal() async {
    print('-------------------tambah pelanggan local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'pelanggan',
        DataPelanggan(
          uuid: uuid,
          idToko: id_toko,
          email: email.value.text,
          alamat: alamat.value.text,
          namaPelanggan: nama.value.text,
          noHp: telepon.value.text,
          tglLahir: tanggal.value.text,
          foto: image64,
          statusPelanggan: 1,
          idKategori: kategorivalue,
        ).DB());

    if (db != null) {
      await Get.find<PelangganController>()
          .fetchPelangganLocal(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'Berhasil registrasi'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  var supplierList = <DataSupplier>[].obs;
  var suppliervalue;
  fetchSupplierLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Supplier WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataSupplier> data =
          query.map((e) => DataSupplier.fromJsondb(e)).toList();
      supplierList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var produk = <DataProduk>[].obs;
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

  fetchDetailPenerimaan({id_toko, id_penerimaan}) async {
    print(
        '-------------------fetch detail penerimaan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
     detail_penerimaan_produk.*, 
     produk.nama_produk AS nama_produk,
     produk.harga_jual_eceran AS harga_jual_eceran
   
  FROM 
      detail_penerimaan_produk 
  LEFT JOIN 
     produk ON detail_penerimaan_produk.id_produk = produk.uuid
  WHERE 
      detail_penerimaan_produk.id_toko = "$id_toko" AND detail_penerimaan_produk.id_penerimaan = "$id_penerimaan"

  ''');
    if (query.isNotEmpty) {
      List<DataDetailPenerimaanProduk> data =
          query.map((e) => DataDetailPenerimaanProduk.fromJsondb(e)).toList();
      detailpenerimaan.value = data;
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

  cariTotalBayar() {
    var x = double.parse(totalharga.value.text);
    var y = double.parse(ongkir.value.text);
    var z = x + y;
    return totalbayar.value.text = z.toString();
  }

  cariSisaBayar() {
    var x = double.parse(totalbayar.value.text);
    var y = double.parse(jumlahbayar.value.text);
    var z = x - y;
    return sisabayar.value.text = z.toString();
  }

  tambahPenerimaanProduk() async {
    print('-------------------tambah paket produk local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    //var uuid_produk = Uuid().v4();
    //var uuid_gambar = Uuid().v4();
    var uuidpenerimaan = Uuid().v4();

    var uuid_pajak = Uuid().v4();
    var uuid_ukuran = Uuid().v4();

    var paket = await DBHelper().INSERT(
      'penerimaan_produk',
      DataPenerimaanProduk(
              uuid: uuidpenerimaan,
              idToko: id_toko,
              idSupplier: suppliervalue,
              jenisPenerimaan: jenispenerimaanvalue.value,
              nomorFaktur: generateInvoiceNumber(),
              jumlahQty: int.parse(jumlahqty.value.text),
              totalHarga: double.parse(totalharga.value.text),
              ongkosKirim: double.parse(ongkir.value.text),
              totalBayar: double.parse(totalbayar.value.text),
              jumlahBayar: double.parse(jumlahbayar.value.text),
              sisaBayar: jenispenerimaanvalue == 'Hutang'
                  ? double.parse(sisabayar.value.text)
                  : 0.0,
              tanggal: getTodayDateISO(),
              idLogin: id_toko)
          .DB(),
    );

    if (paket != null) {
      for (DataProdukTemp produk in produktemp) {
        var uuuidDetauilpenerimaan = Uuid().v4();
        var detail = await DBHelper().INSERT(
            'detail_penerimaan_produk',
            DataDetailPenerimaanProduk(
              uuid: uuuidDetauilpenerimaan,
              qty: produk.qty,
              idPenerimaan: uuidpenerimaan,
              idProduk: produk.uuid,
              idToko: id_toko,
              subtotal: produk.harga_jual_eceran! * produk.qty,
            ).DB());
      }
      await Get.find<BasemenuStockController>()
          .fetchPenerimaanLocal(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}
