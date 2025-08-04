import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/model_beban.dart';

import '../../../Controllers/CentralController.dart';
import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';

class EditKategoriBebanController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nama.value.text = data.namaKategoriBeban!;
    aktif.value = data.aktif == 1 ? true : false;
  }

  DataKategoriBeban data = Get.arguments;
  final registerKey = GlobalKey<FormState>().obs;
  var nama = TextEditingController().obs;
  var keterangan = TextEditingController().obs;
  var promovalue = TextEditingController().obs;
  var email = TextEditingController().obs;
  var aktif = true.obs;

  Map<String, dynamic> DataEditKategoriBeban({nama, aktif}) {
    var map = <String, dynamic>{};
    map['nama_kategori_beban'] = nama;
    map['aktif'] = aktif;
    return map;
  }

  editKategoriLocal() async {
    print('-------------------edit  produk local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var beban = await DBHelper().UPDATE(
        id: data.uuid,
        table: 'kategori_beban',
        data: DataEditKategoriBeban(nama: nama.value.text, aktif: aktif.value));
    if (beban == 1) {
      await Get.find<CentralBebanController>().fetchKategoriBeban();
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil diedit'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }
}
