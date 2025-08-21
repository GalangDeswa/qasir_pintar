import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';

import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
import 'model_pelanggan.dart';

class PelangganController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    // await  fetchPelangganLocal(id_toko: id_toko);
    await Get.find<CentralPelangganController>()
        .fetchPelangganLocal(id_toko: id_toko);
  }

  deletePelanggan({uuid}) async {
    print(
        'delete kategori pelanggan local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'pelanggan', id: uuid);
    if (delete == 1) {
      final index = pelangganList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        pelangganList.removeAt(index);
      }

      await Get.find<PelangganController>()
          .fetchPelangganLocal(id_toko: id_toko);

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

  deletePelangganv2(uuid) async {
    print(
        '-------------------soft delete  pelanggan local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var beban = await DBHelper().softDelete(table: 'pelanggan', uuid: uuid);
    print('respon softdeleter pelanggan ---->');
    print(beban);
    if (beban == 1) {
      await Get.find<CentralPelangganController>()
          .fetchPelangganLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil dibatalkan'));
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
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

  var id_toko = GetStorage().read('uuid');
  var pelangganList = <DataPelanggan>[].obs;
  var search = TextEditingController().obs;
  serachPelangganLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        pelanggan.*, 
        kategori_pelanggan.kategori AS kategori_nama
    FROM 
        pelanggan 
    LEFT JOIN 
        kategori_pelanggan ON pelanggan.ID_Kategori = kategori_pelanggan.uuid 
    WHERE 
        pelanggan.id_toko = "$id_toko" AND pelanggan.nama_pelanggan LIKE "%${search.value.text}%"
  ''');
    List<DataPelanggan> jenis = query.isNotEmpty
        ? query.map((e) => DataPelanggan.fromJsondb(e)).toList()
        : [];
    pelangganList.value = jenis;

    return jenis;
  }

  fetchPelangganLocal({id_toko}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        pelanggan.*, 
        kategori_pelanggan.kategori AS kategori_nama
    FROM 
        pelanggan 
    LEFT JOIN 
        kategori_pelanggan ON pelanggan.ID_Kategori = kategori_pelanggan.uuid 
    WHERE 
        pelanggan.id_toko = "$id_toko"
  ''');
    if (query.isNotEmpty) {
      List<DataPelanggan> data =
          query.map((e) => DataPelanggan.fromJsondb(e)).toList();
      pelangganList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }
}
