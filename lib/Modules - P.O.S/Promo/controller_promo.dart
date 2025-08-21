import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';

import '../../Database/DB_helper.dart';
import '../../Widget/widget.dart';
import 'model_promo.dart';

class PromoController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchPromo(id_toko: id_toko);
  }

  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var promo = <DataPromo>[].obs;
  var id_toko = GetStorage().read('uuid');

  deletePromo({uuid}) async {
    print('delete promo local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'promo', id: uuid);
    if (delete == 1) {
      final index = promo.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        promo.removeAt(index);
      }
      await fetchPromo(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }
  }

  deletePromov2(uuid) async {
    print('-------------------soft delete  promo local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var beban = await DBHelper().softDelete(table: 'promo', uuid: uuid);
    print('respon softdeleter beban ---->');
    print(beban);
    if (beban == 1) {
      await Get.find<CentralPromoController>().fetchPromo(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil dihapus'));
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }

  fetchPromo({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM promo WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPromo> data = query.map((e) => DataPromo.fromJsondb(e)).toList();
      promo.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  searchPromoLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM promo WHERE id_toko = "$id_toko" AND promo.nama_promo LIKE "%${search.value.text}%" ');
    List<DataPromo> jenis = query.isNotEmpty
        ? query.map((e) => DataPromo.fromJsondb(e)).toList()
        : [];
    promo.value = jenis;

    return jenis;
  }
}
