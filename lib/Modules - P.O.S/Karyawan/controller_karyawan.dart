import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/model_karyawan.dart';

import '../../Database/DB_helper.dart';
import '../../Widget/widget.dart';

class KaryawanController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchKaryawanLocal(id_toko: id_toko);
  }

  deleteKaryawan({uuid}) async {
    print('delete karyawan local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Karyawan', id: uuid);
    if (delete == 1) {
      // Manually remove from the list first
      final index = karyawanList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        karyawanList.removeAt(index);
      }

      // Then refresh from database
      await fetchKaryawanLocal(id_toko: id_toko);

      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'Karyawan berhasil dihapus'));
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
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

  var karyawanList = <DataKaryawan>[].obs;
  var search = TextEditingController().obs;

  searchKaryawanLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Karyawan WHERE id_toko = "$id_toko" AND Nama_Karyawan LIKE "%${search.value.text}%" ');
    List<DataKaryawan> jenis = query.isNotEmpty
        ? query.map((e) => DataKaryawan.fromJsondb(e)).toList()
        : [];
    karyawanList.value = jenis;

    return jenis;
  }

  fetchKaryawanLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Karyawan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKaryawan> data =
          query.map((e) => DataKaryawan.fromJsondb(e)).toList();
      karyawanList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }
}
