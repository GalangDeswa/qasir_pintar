import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules/Produk/controller_basemenuproduk.dart';

import '../../../../Database/DB_helper.dart';
import '../../../../Widget/widget.dart';

class EditDetailProdukController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (data is DataPajakProduk) {
      print('kjhieufghuiksgbfkusbfgkusefgkus');
      print(data.nama_pajak);
      namaPajak.value.text = data.nama_pajak!;
      isAktifpajak.value = data.aktif == 1 ? true : false;
      nominalPajak.value.text = data.nominal_pajak.toString();
    }
    if (data is DataUkuranProduk) {
      ukuranProduk.value.text = data.ukuran!;
      isAktifukuran.value = data.aktif == 1 ? true : false;
    }
  }

  var isAktifpajak = true.obs;
  var isAktifukuran = true.obs;
  var id_toko = GetStorage().read('uuid');

  // DataPajakProduk datapajak = Get.arguments;
  // DataUkuranProduk dataUkuran = Get.arguments;
  var data = Get.arguments;
  var pajakkey = GlobalKey<FormState>().obs;
  var ukurankey = GlobalKey<FormState>().obs;

  var namaPajak = TextEditingController().obs;
  var nominalPajak = TextEditingController().obs;
  var ukuranProduk = TextEditingController().obs;

  Map<String, dynamic> dataeditpajak({pajak, nominal, aktif}) {
    var map = <String, dynamic>{};

    map['nama_pajak'] = pajak;
    map['aktif'] = aktif;
    map['nominal_pajak'] = nominal;
    return map;
  }

  Map<String, dynamic> dataeditukuran({ukuran, aktif}) {
    var map = <String, dynamic>{};

    map['ukuran'] = ukuran;
    map['aktif'] = aktif;

    return map;
  }

  editpajaklocal() async {
    print('-------------------edit pajak local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var query = await DBHelper().UPDATE(
        table: 'pajak_produk',
        data: dataeditpajak(
          pajak: namaPajak.value.text,
          aktif: isAktifpajak.value == true ? 1 : 0,
          nominal: double.parse(nominalPajak.value.text.replaceAll(',', '')),
        ),
        id: data.uuid);

    print(query);
    if (query == 1) {
      //print('edit user local berhasil------------------------------------->');
      await Get.find<BaseMenuProdukController>()
          .fetchPajakLocal(id_toko: id_toko);
      await Get.find<BaseMenuProdukController>()
          .fetchProdukLocal(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil diedit'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }

  editukuranlocal() async {
    print('-------------------edit ukuran local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var query = await DBHelper().UPDATE(
        table: 'ukuran_produk',
        data: dataeditukuran(
            ukuran: ukuranProduk.value.text,
            aktif: isAktifukuran.value == true ? 1 : 0),
        id: data.uuid);

    print(query);
    if (query == 1) {
      //print('edit user local berhasil------------------------------------->');
      await Get.find<BaseMenuProdukController>()
          .fetchUkuranLocal(id_toko: id_toko);
      await Get.find<BaseMenuProdukController>()
          .fetchProdukLocal(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil diedit'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }

  deleteKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Kelompok_produk', id: uuid);
    if (delete == 1) {
      // await Get.find<PelangganController>()
      //     .fetchPelangganLocal(id_toko: id_toko);
      //await fetchKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }

    // var select = kategoripelangganList.where((x) => x.uuid == uuid).first;
    // var delete = await DBHelper().UPDATE(
    //   id: select.idLocal,
    //   table: 'beban_local',
    //   data: DataBeban(
    //       aktif: 'N',
    //       sync: 'N',
    //       id: select.id,
    //       idLocal: select.idLocal,
    //       idToko: select.idToko,
    //       jumlah: select.jumlah,
    //       tgl: select.tgl,
    //       keterangan: select.keterangan,
    //       nama: select.nama,
    //       idKtrBeban: select.idKtrBeban,
    //       idUser: select.idUser,
    //       namaKtrBeban: select.namaKtrBeban)
    //       .toMapForDb(),
    // );

    // var query = await DBHelper().DELETE('produk_local', id);
    // if (delete == 1) {
    //   await fetchBebanlocal(id_toko);
    //   await Get.find<dashboardController>().loadbebanhariini();
    //   await Get.find<dashboardController>().loadpendapatanhariini();
    //   await Get.find<dashboardController>().loadpendapatantotal();
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_success('Sukses', 'Beban berhasil dihapus'));
    //   print('deleted ' + id_local.toString());
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(toast()
    //       .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    // }
  }
}
