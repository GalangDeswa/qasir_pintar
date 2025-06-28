import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20kategori%20pelanggan/model_kategoriPelanggan.dart';

import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';

class KategoriPelangganController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchKategoriPelangganLocal(id_toko);
  }

  var id_toko = GetStorage().read('uuid');
  var kategoripelangganList = <DataKategoriPelanggan>[].obs;

  deleteKategoriPelanggan({uuid}) async {
    print(
        'delete kategori pelanggan local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'kategori_pelanggan', id: uuid);
    if (delete == 1) {
      final index = kategoripelangganList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        kategoripelangganList.removeAt(index);
      }
      await Get.find<KategoriPelangganController>()
          .fetchKategoriPelangganLocal(id_toko);

      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }
  }

  fetchKategoriPelangganLocal(id_toko) async {
    print(
        '-------------------fetch kategori pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM kategori_pelanggan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKategoriPelanggan> data =
          query.map((e) => DataKategoriPelanggan.fromJsondb(e)).toList();
      kategoripelangganList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var search = TextEditingController().obs;
  serachKategoriPelangganLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM kategori_pelanggan WHERE id_toko = "$id_toko" AND kategori LIKE "%${search.value.text}%"');
    List<DataKategoriPelanggan> jenis = query.isNotEmpty
        ? query.map((e) => DataKategoriPelanggan.fromJsondb(e)).toList()
        : [];
    kategoripelangganList.value = jenis;
    print(jenis);

    return jenis;
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
}
